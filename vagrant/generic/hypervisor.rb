######################################################################################
#
# Hypervisor is an abstraction for the type of virtualization running on the host.
# - ARM machines = VMware
# - Intel machines = VirtualBox
#
######################################################################################
class Hypervisor
  @@node = nil
  @@workdir = File.dirname(__FILE__)

  # Create Hypervisor support for the current VM node
  def self.get(node:)
    @@node = node

    if OS.arm?
      yield VMware.new
    end

    yield VirtualBox.new
  end

  # Deploy the VM with given index
  def deploy(vm:, network:, index:)
    self.set_spec cpu: vm[:cpu], memory: vm[:memory]
    self.network network: network, index: index
    self.set_hostname hostname: vm[:name]
    if vm.key?(:packages)
      # If there are packages to install in guest, install them
      self.provision_script vm[:packages].join(","), script: "package_install.sh"
    end
  end

  def network(network:, index:)
    typ = network[:network_type]
    if not(typ == "NAT" or typ == "BRIDGE")
      raise Exception.new "Invalid network type #{typ}. Must be NAT or BRIDGE"
    end
    if typ == "BRIDGE" and !self.can_bridge?
      puts "WARNING: Hypervisor does not support BRIDGE. Falling back to NAT"
      network[:network_type] = "NAT"
      typ = "NAT"
    end
    if typ == "NAT"
      @@node.vm.network :private_network, ip: network[:private_network] + "#{network[:ip_start] + index}"
    else
      b = self.bridge_adapter
      if b == ""
        @@node.vm.network :public_network
      else
        @@node.vm.network :public_network, bridge: self.bridge_adapter
      end
    end
    h = Host.get
    self.provision_script network[:private_network], network[:network_type], h.gateway_addresses, script: "setup_host.sh"
  end

  # Create an interface with given IP on hypervisor's private network
  def private_network(ip:)
    @@node.vm.network :private_network, ip: ip
  end

  # Port forward the given guest port to given port on host
  def port_forward(guest:, host:)
    @@node.vm.network "forwarded_port", guest: guest, host: host
  end

  # Run a shell script from distro specific directort
  def provision_script(*args, script:)
    s = ""
    if File.exists?(File.join(@@workdir, "linux", script))
      s = File.join(@@workdir, "linux", script)
    else
      raise Exception.new "Provisioner script not found: #{script}"
    end
    if args.length() > 0
      @@node.vm.provision script, type: "shell", path: s do |prov|
        prov.args = args
      end
    else
      @@node.vm.provision script, type: "shell", path: s
    end
  end

  # Return a working CentOS (or equivalent) box image for the current architecture
  def self.centos()
    if OS.arm?
      return "bento/centos-stream-9-arm64" #  "gyptazy/rocky9.3-arm64"
    end
    return "boxomatic/centos-stream-9"
  end

  def self.ubuntu()
    if OS.arm?
      return "bento/ubuntu-22.04-arm64"
    end
    return "ubuntu/jammy64"
  end

  def can_bridge?
    true
  end

  def bridge_adapter
    ""
  end
end

class VMware < Hypervisor
  # TODO - work out bridging
  def set_hostname(hostname:)
    @@node.vm.provision "set-hostname", type: "shell", inline: "sudo hostnamectl set-hostname #{hostname}"
  end

  def set_spec(cpu:, memory:)
    @@node.vm.provider "vmware_desktop" do |v|
      v.vmx["numvcpus"] = "#{cpu}"
      v.vmx["memsize"] = "#{memory}"
    end
  end
end

class VirtualBox < Hypervisor
  include Powershell

  def set_hostname(hostname:)
    @@node.vm.hostname = hostname
    # virtualbox UI name
    @@node.vm.provider "virtualbox" do |v|
      v.name = hostname
    end
  end

  def set_spec(cpu:, memory:)
    @@node.vm.provider "virtualbox" do |v|
      v.cpus = cpu
      v.memory = memory
    end
  end

  def can_bridge?
    # TODO linux one day
    not OS.linux?
  end

  def bridge_adapter
    if OS.windows?
      return self.powershell("Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Get-NetAdapter | Select-Object -ExpandProperty InterfaceDescription")
    elsif OS.intel_mac?
      sh = <<~SHEL
        iface=$(netstat -rn -f inet | grep '^default' | sort | head -1 | awk '{print $4}')
        interface=$(VBoxManage list bridgedifs | awk '/^Name:/ { print }' | sed -e 's/^Name:[ ]*\(.*\)/\1/' | grep $iface)
        echo -n $interface
      SHEL
      return %x{ #{sh} }.chomp()
    else
      return ""
    end
  end
end

class DetectionError < RuntimeError
end
