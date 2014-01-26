require 'rubygems'

module Unbundler
  class KeepList
    def initialize(gems_list)
      name_version_pairs = gems_list.map do |gem|
        gem = gem.tr("\"'", "")
        pair = gem.split(" ", 2)
        [pair.shift, Gem::Dependency.new('unbundler', pair.shift)]
      end
      @keep_list = Hash[name_version_pairs]
    end

    def include?(gem)
      return false unless @keep_list.keys.include?(gem.name)
      return false unless @keep_list[gem.name].match?('unbundler', gem.version || ">= 0")
      true
    end
  end
end
