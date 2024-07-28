################################################################
#
# Everything in here is for multi-platform support
# Handles differences between Windows, Intel Mac, AS Mac etc.
#
# Do not edit unless you _really_ know what you are doing!
#
################################################################

require "base64"

# Operating system detection
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.apple_silicon?
    RUBY_PLATFORM == "arm64-darwin"
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux_arm?
    RUBY_PLATFORM == "aarch64_linux"
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end

  def OS.arm?
    OS.apple_silicon? || OS.linux_arm?
  end
end

module Powershell
  def powershell(cmd)
    encoded_cmd = Base64.strict_encode64(cmd.encode("utf-16le"))
    return %x{powershell.exe -EncodedCommand #{encoded_cmd}}.chomp()
  end
end

# Hypervisor is an abstraction for the type of virtualization running on the host.
# - ARM machines = VMware
# - Intel machines = VirtualBox
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
      @@node.vm.network :public_network, bridge: self.bridge_adapter
    end
    self.provision_script network[:private_network], network[:network_type], script: "setup_host.sh"
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
      return "gyptazy/rocky9.3-arm64"
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
    false
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
    elsif OS.mac?
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

# Host is an abstraction for the host system we are building VMs on.
class Host
  CPU_NAME = 0
  CPU_COUNT = 1
  RAM = 2
  OS_NAME = 3
  HV_EXISTS = 4

  @@specs = nil

  def self.get()
    if OS.apple_silicon?
      return AppleSiliconHost.new
    elsif OS.mac?
      return IntelMacHost.new
    elsif OS.windows?
      return WindowsHost.new
    elsif OS.linux_arm?
      return ArmLinuxHost.new
    elsif OS.linux?
      return IntelLinuxHost.new
    else
      raise DetectionError.new "FATAL - Cannot determine your operating system"
    end
  end

  def get_system_name()
    return ""
  end
end

class WindowsHost < Host
  include Powershell

  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    if not @@specs
      self.get_sysinfo()
    end
    @@specs[HV_EXISTS] == "1"
  end

  private

  def get_sysinfo()
    ps = <<~PS
      $p = Get-CimInstance Win32_Processor | Select-Object NumberOfLogicalProcessors, Name
      $m = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
      $o = (Get-CimInstance Win32_OperatingSystem | select -ExpandProperty Name).split('|') | Select-Object -First 1
      $hv = 0
      try {
        $d = Get-ItemProperty hklm:Software/Oracle/VirtualBox -PSProperty InstallDir -ErrorAction Stop
        if (Test-Path (Join-Path $d.InstallDir vboxmanage.exe)) {
          $hv = 1
        }
      }
      catch {}
      Write-Host "$($p.Name)/$($p.NumberOfLogicalProcessors)/$m/$o/$hv"
    PS
    @@specs = self.powershell(ps).split("/")
  end
end

class MacHost < Host
  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i / 1073741824
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  def get_system_name()
    return "Mac"
  end

  private

  def get_sysinfo()
    sh = <<~SHEL
      pc=$(sysctl -n "hw.ncpu")
      m=$(sysctl -n "hw.memsize")
      pn=$(sysctl -n "machdep.cpu.brand_string")
      os_name=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'  | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
      os_ver=$(sw_vers | awk '/ProductVersion/ { print $2 }')
      echo "${pn}/${pc}/${m}/${os_name} ${os_ver}"
    SHEL
    @@specs = %x{ #{sh} }.chomp().split("/")
  end
end

class IntelMacHost < MacHost
  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    Dir.exists?("/Applications/VirtualBox.app")
  end
end

class AppleSiliconHost < MacHost
  def hypervisor_name()
    return "VMware Fusion"
  end

  def hypervisor_exists?
    Dir.exists?("/Applications/VMware Fusion.app")
  end
end

class LinuxHost < Host
  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i / 1048576
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  private

  def get_sysinfo
    sh = <<~SHEL
      m=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
      pc=$(nproc)
      pn=$(cat /proc/cpuinfo | grep "model name" | uniq | cut -d ':' -f 2 | sed "s/^[ ]*//")
      o=$(source /etc/os-release && echo -n "$NAME $VERSION")
      echo "${pn}/${pc}/${m}/${o}"
    SHEL
    @@specs = %x{ #{sh} }.chomp().split("/")
  end
end

class IntelLinuxHost < LinuxHost
  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    sh = <<~SHEL
      if command -v VBoxManage > /dev/null
      then
        echo -n "1"
      else
        echo -n "0"
      fi
    SHEL
    %x{ #{sh} }.chomp() == "1"
  end

  def get_system_name()
    return "Intel"
  end
end

class ArmLinuxHost < LinuxHost
  def hypervisor_name()
    return "VMware Workstation"
  end

  def hypervisor_exists?
    sh = <<~SHEL
      if command -v vmrun > /dev/null
      then
        echo -n "1"
      else
        echo -n "0"
      fi
    SHEL
    %x{ #{sh} }.chomp() == "1"
  end

  def get_system_name()
    return "ARM"
  end
end

def b_puts(str, width = 71)
  padding = width - 4 - str.length
  if padding < 1
    padding = 1
  end
  pad = " " * padding
  puts "# #{str}#{pad} #"
end

def show_system_info(trigger, host)
  begin
    puts "#######################################################################"
    b_puts("")
    b_puts("If raising a question on our forums, please PASTE (not screenshot)")
    b_puts("the content of this box with your question")
    b_puts("")
    b_puts("Detecting your hardware...")
    b_puts "- System: #{host.os_name()}"
    b_puts("- CPU:    #{host.cpu_name()} (#{host.cpu_count()} cores)")
    b_puts("- RAM:    #{host.physical_ram_gb()} GB")
    if !host.hypervisor_exists?
      raise DetectionError.new "FATAL - Missing #{host.hypervisor_name()}. Please install it first."
    end
  rescue DetectionError => e
    b_puts("#{e}")
    trigger.abort = true
    raise
  ensure
    b_puts("")
    puts "#######################################################################\n\n"
  end
end

def validate_configuration(trigger, host, vms)
  requested_ram = 0
  vms.each do |vm|
    requested_ram += vm[:memory]
  end
  if (requested_ram / 1024) > host.physical_ram_gb - 2
    puts <<~EOT
           Total RAM requested by VMs is more than your machine can provide!
           Either reduce the memory requirement of the VMs or have fewer VMs

         EOT
    trigger.abort = true
    raise Exception.new "Invalid configuration. See messages above\n\n"
  end
end

require "tmpdir"

def post_provision(env)
  # Build hosts file fragment
  puts "--> Harvesting machine IPs"
  hosts = ""
  env.active_machines.each do |active_machine|
    vm_name = active_machine[0].to_s
    ip = %x{ vagrant ssh -c primary-ip #{vm_name} }
    hosts << ip << " " << vm_name << "\n"
  end
  # Adjust hosts file
  hosts_tmp = File.join(File.dirname(__FILE__), "hosts.tmp")
  File.open(hosts_tmp, "w") { |file| file.write(hosts) }
  env.active_machines.each do |active_machine|
    vm_name = active_machine[0].to_s
    puts "--> Setting hosts file: #{vm_name}"
    %x{ vagrant ssh -c 'sudo /opt/vagrant/update-hosts.sh' #{vm_name}}
  end
  puts ""
  puts hosts
  File.delete hosts_tmp
end
