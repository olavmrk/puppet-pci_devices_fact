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

  context 'Dell PowerEdge 860' do
    let(:sysfs_variant) { 'dell_poweredge_860' }
    it {
      is_expected.to eq(['1002:5159', '1028:0010', '1028:0012', '1028:0014',
                         '1095:0680', '14e4:1659', '3388:0022', '8086:032c',
                         '8086:244e', '8086:2778', '8086:2779', '8086:27b8',
                         '8086:27c0', '8086:27c8', '8086:27c9', '8086:27ca',
                         '8086:27cc', '8086:27d0', '8086:27da', '8086:27df',
                         '8086:27e0', '8086:27e2'])
    }
  end

  context 'Shuttle DS47' do
    let(:sysfs_variant) { 'shuttle_ds47' }
    it {
      is_expected.to eq(['10ec:8168', '10ec:8176', '1b21:1142', '8086:0154',
                         '8086:0156', '8086:1e03', '8086:1e10', '8086:1e12',
                         '8086:1e14', '8086:1e16', '8086:1e20', '8086:1e22',
                         '8086:1e26', '8086:1e2d', '8086:1e3a', '8086:1e5f'])
    }
  end

end
