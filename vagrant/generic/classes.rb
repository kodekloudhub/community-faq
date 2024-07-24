################################################################
#
# Everything below here is for multi-platform support
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

# Hypervisor is an abstraction for the type of virtualization running on the host.
# - ARM machines = VMware
# - Intel machines = VirtualBox
class Hypervisor
  @@node = nil
  @@disto = nil
  @@workdir = File.dirname(__FILE__)

  # Create Hypervisor support for the current VM node
  def self.get(node:, distro:)
    @@node = node
    @@distro = distro.to_s

    if OS.arm?
      yield VMware.new
    end

    yield VirtualBox.new
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
    if File.exists?(File.join(@@workdir, @@distro, script))
      s = File.join(@@workdir, @@distro, script)
    elsif File.exists?(File.join(@@workdir, "linux", script))
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
      return {
               name: "gyptazy/rocky9.3-arm64",
               distro: :redhat,
             }
    end
    return {
             name: "boxomatic/centos-stream-9",
             distro: :redhat,
           }
  end

  def self.ubuntu()
    if OS.arm?
      return {
               name: "bento/ubuntu-22.04-arm64",
               distro: :debian,
             }
    end

    return {
             name: "ubuntu/jammy64",
             distro: :debian,
           }
  end
end

class VMware < Hypervisor
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
  @specs = []

  def initialize
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
    @specs = self.powershell(ps).split("/")
  end

  def physical_ram_gb()
    return @specs[RAM].to_i
  end

  def cpu_count()
    return @specs[CPU_COUNT].to_i
  end

  def cpu_name()
    return @specs[CPU_NAME]
  end

  def os_name()
    return @specs[OS_NAME]
  end

  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    @specs[HV_EXISTS] == "1"
  end

  private

  # Run a powershell command
  def powershell(cmd)
    encoded_cmd = Base64.strict_encode64(cmd.encode("utf-16le"))
    return %x{powershell.exe -EncodedCommand #{encoded_cmd}}.chomp()
  end
end

class MacHost < Host
  @specs = []

  def initialize
    sh = <<~SHEL
      pc=$(sysctl -n "hw.ncpu")
      m=$(sysctl -n "hw.memsize")
      pn=$(sysctl -n "machdep.cpu.brand_string")
      os_name=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'  | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
      os_ver=$(sw_vers | awk '/ProductVersion/ { print $2 }')
      echo "${pn}/${pc}/${m}/${os_name} ${os_ver}"
    SHEL
    @specs = %x{ #{sh} }.chomp().split("/")
  end

  def physical_ram_gb()
    return @specs[RAM].to_i / 1073741824
  end

  def cpu_count()
    return @specs[CPU_COUNT].to_i
  end

  def cpu_name()
    return @specs[CPU_NAME]
  end

  def os_name()
    return @specs[OS_NAME]
  end

  def get_system_name()
    return "Mac"
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
  @specs = []

  def initialize
    sh = <<~SHEL
      m=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
      pc=$(nproc)
      pn=$(cat /proc/cpuinfo | grep "model name" | uniq | cut -d ':' -f 2 | sed "s/^[ ]*//")
      o=$(source /etc/os-release && echo -n "$NAME $VERSION")
      echo "${pn}/${pc}/${m}/${o}"
    SHEL
    @specs = %x{ #{sh} }.chomp().split("/")
  end

  def physical_ram_gb()
    return @specs[RAM].to_i / 1048576
  end

  def cpu_count()
    return @specs[CPU_COUNT].to_i
  end

  def cpu_name()
    return @specs[CPU_NAME]
  end

  def os_name()
    return @specs[OS_NAME]
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
