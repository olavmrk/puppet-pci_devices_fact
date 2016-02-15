require 'set'

Facter.add(:pci_devices) do
  confine :kernel => :linux
  setcode do
    pci_devices = Set.new

    Dir['/sys/class/pci_bus/*/device/*'].each do |device_dir|
      unless File.directory?(device_dir) then
        next
      end
      vendor_file = File.join(device_dir, 'vendor')
      device_file = File.join(device_dir, 'device')
      unless File.file?(vendor_file) and File.file?(device_file) then
        next
      end
      vendor = Integer(IO.read(vendor_file))
      device = Integer(IO.read(device_file))
      pci_device = '%04x:%04x' % [ vendor, device ]
      pci_devices.add(pci_device)
    end

    pci_devices.to_a
  end
end
