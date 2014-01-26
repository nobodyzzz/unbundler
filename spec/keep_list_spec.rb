require 'unbundler'
require 'unbundler/keep_list'
require 'spec_helper'

describe Unbundler::KeepList do
  subject { lambda { |gem_list| Unbundler::KeepList.new(gem_list) } }

  it 'should check gem presence by gem name' do
    gem = Gem::Specification.new("gem")
    expect {subject.call(%w(gem gem2 gem3)).include?(gem)}.to be_true
  end

  it 'should check gem presence by gem name and version' do
    gem = Gem::Specification.new("gem", "1.0.0")
    gems = %(gem1 gem3 gem3)
    gems << "gem '1.0.0'"
    expect {subject.call(gems).include?(gem)}.to be_true
  end
end
