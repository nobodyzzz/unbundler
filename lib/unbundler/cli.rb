require 'trollop'
require 'unbundler/gem_list'
require 'pp'

module Unbundler
  class CLI
    def self.start
      cli = CLI.new
      cli.run(cli.parse_args)
    end

    def run(opts)
      @interactive = opts[:interactive]
      @plain = opts[:plain]
      @quiet = opts[:quiet]
      @gems = GemList.new(opts[:keep])
      self.send(opts[:action])
    end

    def parse_args
      opts = { :action => :unbundle }
      case ARGV.first
      when "show", "list"
        opts[:action] = :show
      when "edit_keep_list"
        opts[:action] = :edit_keep_list
      end
      opts.merge( Trollop::options do
                    version "unbundler v#{Unbundler::VERSION}"
                    opt :keep, "List of gems to keep", :type => :strings
                    opt :plain, "Plain output for unbundle list"
                    opt :interactive, "Interactive unbundle(ask about each gem)"
                    opt :quiet, "Produce no output"
                  end)
    end

private

    def unbundle
      @gems.each do |gem|
        uninstall_gem(gem) unless keep(gem)
      end
    end

    def show
      puts "Gems to be unbundled:" unless @plain
      @gems.each do |gem|
        puts @plain ? gem : "  * #{gem}"
      end
    end

    def edit_keep_list
      exec "${FCEDIT:-${VISUAL:-${EDITOR:-vi}}} ~/.unbundler_keep"
    end

    # http://stackoverflow.com/a/14527475/162459
    def get_char
      state = `stty -g`
      `stty raw -echo -icanon isig`
      STDIN.getc.chr
    ensure
      `stty #{state}`
    end

    def keep(gem)
      return false unless @interactive
      while true do
        puts "Delete #{gem} (y/n/a)"
        case get_char
        when 'y', 'Y'
          return false
        when 'n', 'N'
          return true
        when 'a', 'A'
          @interactive = false
          return false
        else
          puts "y/n/a expected"
        end
      end
    end

    def uninstall_gem(gem)
      `gem uninstall -x #{gem}`
    end
  end
end
