require 'facter'
require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/facter/pci_devices.rb')

describe 'pci_devices_fact' do

  before :example do
    allow(Dir).to receive('[]').and_wrap_original do |original, *args|
      if args[0].start_with?('/sys/')
        variant_dir = File.dirname(__FILE__) + '/../sysfs_variants/' + sysfs_variant
        sysfs_path = args[0][5..-1]
        args[0] = variant_dir + '/' + sysfs_path
      end
      original.call(*args)
    end
    Facter.reset
  end

  subject { Facter.value(:pci_devices) }

  context 'with no PCI devices' do
    let(:sysfs_variant) { 'empty' }
    it { is_expected.to eq([]) }
  end

end
