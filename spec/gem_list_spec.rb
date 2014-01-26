require 'unbundler'
require 'unbundler/gem_list'
require 'spec_helper'

describe Unbundler::GemList do
  subject { lambda { |keep_list=nil| Unbundler::GemList.new(keep_list || []) } }
  let(:specs) { [Gem::Specification.new("gem1"),
                 Gem::Specification.new("gem2"),
                 Gem::Specification.new("gem3"),
                 Gem::Specification.new("gem4"),
                 Gem::Specification.new("gem5"),
                 Gem::Specification.new("gem6")] }
  before(:each) do
    bundler_load = double("Bundler.load")
    bundler_load.should_receive(:specs).and_return(specs)
    Bundler.should_receive(:load).and_return(bundler_load)
  end

  it 'should allow to enumarate gems to unbundle' do
    gems = []
    subject.call.each { |gem| gems << gem }
    gems.should =~  specs.map { |spec| spec.name }
  end

  it 'should exclude gems from global keep list' do
    file = double(file)
    keep_list_file = File.expand_path("~/.unbundler_keep")
    File.should_receive(:exist?).with(keep_list_file).and_return(true)
    File.should_receive(:open).with(keep_list_file).and_return(file)
    file.should_receive(:readlines).and_return(["gem3"])
    gems = []
    subject.call.each { |gem| gems << gem }
    gems.should_not include "gem3"
  end

  it 'should exclude gems from provided keep list' do
    gems = []
    keep_list = %w(gem2 gem4 gem6)
    subject.call(keep_list).each { |gem| gems << gem }
    expect(gems).not_to match_array keep_list
  end
end
