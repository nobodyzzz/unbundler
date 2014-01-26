require 'unbundler'
require 'spec_helper'

describe Unbundler::CLI do
  def replace_argv(new_argv)
    ::Object.send(:remove_const, :ARGV)  # suppress const redefinition warning
    ::Object.send(:const_set, :ARGV, Array(new_argv))
  end

  def run_cli(args=[])
    replace_argv(args)
    subject.run(subject.parse_args)
    return 0
  rescue SystemExit => e
    return e.status
  end

  shared_examples_for 'command line argument' do
    it 'short form' do
      replace_argv([short_name] | Array(value))
      subject.parse_args[key].should == expected_value
    end
    it 'long form' do
      replace_argv([long_name] | Array(value))
      subject.parse_args[key] == value
    end
    it 'short and long form should match' do
      replace_argv([short_name] | Array(value))
      opts = subject.parse_args
      replace_argv([long_name] | Array(value))
      opts[key].should == subject.parse_args[key]
    end
  end

  context 'keep option' do
    let(:short_name)    {'-k'}
    let(:long_name)     {'--keep'}
    let(:key)           {:keep}
    let(:value)         {%w(gem1 gem2 gem3)}
    let(:expected_value){%w(gem1 gem2 gem3)}
    it_should_behave_like 'command line argument'
  end

  context 'plain option' do
    let(:short_name)    {'-p'}
    let(:long_name)     {'--plain'}
    let(:key)           {:plain}
    let(:value)         {''}
    let(:expected_value){true}
    it_should_behave_like 'command line argument'
  end

  context 'interactive option' do
    let(:short_name)    {'-i'}
    let(:long_name)     {'--interactive'}
    let(:key)           {:interactive}
    let(:value)         {''}
    let(:expected_value){true}
    it_should_behave_like 'command line argument'
  end

  context 'quiet option' do
    let(:short_name)    {'-q'}
    let(:long_name)     {'--quiet'}
    let(:key)           {:quiet}
    let(:value)         {''}
    let(:expected_value){true}
    it_should_behave_like 'command line argument'
  end

  it 'should run action specified in command line' do
    ['show', 'edit_keep_list'].each do |action|
      subject.should_receive(action.to_sym).and_return(true)
      run_cli(action)
    end
  end

  it 'should run unbundle action by default(i.e. no action is specified)' do
    subject.should_receive(:unbundle).and_return(true)
    run_cli
  end

end
