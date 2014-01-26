require 'unbundler/keep_list'
require 'bundler'

module Unbundler
  class GemList
    def initialize(keep_list)
      @keep_list = KeepList.new(keep_list || [])
      @global_keep_list = KeepList.new(global_keep_list)
    end

    def each
      gems_to_unbundle.each do |gem|
        yield gem.name
      end
    end

    private

    def unbundler_runtime_dependencies
      Gem::Dependency.new("unbundler").to_spec.runtime_dependencies
    end

    def create_default_keep_list
      keep_list_file = File.expand_path("~/.unbundler_keep")
      File.open(keep_list_file, "w") do |keep_list|
        keep_list.puts "unbundler"
        unbundler_runtime_dependencies.each do |gem|
          keep_list.puts  "#{gem.name} '#{gem.requirement.to_s}'"
        end
      end
    end

    def global_keep_list
      keep_list_file = File.expand_path("~/.unbundler_keep")
      create_default_keep_list unless File.exist?(keep_list_file)
      File.open(keep_list_file).readlines.map(&:chomp).map(&:strip)
    end

    def in_keep_list?(gem)
      @keep_list.include?(gem) || @global_keep_list.include?(gem)
    end

    def bundled_gems
      @bundled_gems ||= Bundler.load.specs
    end


    def gems_to_unbundle
      @gems_to_unbundle ||= bundled_gems.reject { |gem| in_keep_list?(gem) }
    end
  end
end
