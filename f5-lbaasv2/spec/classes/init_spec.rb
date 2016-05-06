require 'spec_helper'
describe 'lbaasv2' do

  context 'with defaults for all parameters' do
    it { should contain_class('lbaasv2') }
  end
end
