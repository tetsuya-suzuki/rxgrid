#
# This is an example with ART scripts.
#

art "onMacmini" do
  localPathName "macmodel"
  arguments ["^Mac mini"]
end

art "onOurMachines" do
  localPathName "hostname"
  arguments ["^tslab"] # We assume that host names of our machines start with 'tslab'
end

art "onLeoardOrSnowLeopard" do
  localPathName "sysver"
  arguments ["Mac OS X( Server)? 10.(5|6)"]
end

art "bcIsInstalled" do
  localPathName "exist"
  arguments ["/usr/bin/bc"]
end

art "bcIsReadable" do
  localPathName "readable"
  arguments ["/usr/bin/bc"]
end

art "bcIsExecutable" do
  localPathName "executable"
  arguments ["/usr/bin/bc"]
end

art "cpuclock" do
  localPathName "cpuclock" # CPU clock in MHz
end

art "loadAvgOverTheLast5min" do
  # The ART script 'loadavg' puts the value of the expression '<load_average>*100+1'. 
  localPathName "loadavg"
  arguments ["5"]  # 1 for the load average over the last 1 minute
               # 5 for the load average over the last 5 minutes
               # 15 for the load average over the last 15 minutes
end

art "memsize" do
  localPathName "memsize"
end

file "bc_exp1.txt" do
  agentPathName "bc_exp1.txt"
  localPathName "bc_exp1.txt"
  isExecutable false
end

task "bc" do
  command "/usr/bin/bc"
  arguments ["-q", "bc_exp1.txt"]
  refersTo ["bc_exp1.txt"]
end

job "job1" do 
  tasks ["bc"]

  arts ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable", "loadAvgOverTheLast5min", "cpuclock", "memsize"]
  #
  # The above line can be divided as follows.
  #
  #  arts ["onMacmini"] # run on Mac mini.
  #  arts ["onOurMachines"] # run on our machines
  #  arts ["onLeoardOrSnowLeopard"] # run on Leopard or Snow Leopard.
  #  arts ["bcIsInstalled"]  # The command 'bc' must be installed.
  #  arts ["bcIsReadable"]   # The command 'bc' must be readable.
  #  arts ["bcIsExecutable"] # The command 'bc' must be executable.
  #  arts ["loadAvgOverTheLast5min"] # The load average over the last 5 minutes.
  #  arts ["cpuclock"] # The cpu clock in MHz
  #  arts ["memsize"]   # The memory size in MB
  #

  artConds "loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}
  #
  # The above line can be divided as follows.
  #
  #  artConds "loadAvgOverTheLast5min"=>{:max=>51} # The load average over the 5 minutes must be at most 0.50.
  #  artConds "cpuclock"=>{:min=>2000}  # CPU clock must be at least 2000 MHz (2 GHz).
  #  artConds "memsize"=>{:eq=>1024}    # The memory size must be 1024 MB (1 GB).
  #

  #
  # More than 1 ART conditions for an ART id must be specified as follows.
  #
  #  artConds "cpuclock"=>{:min=>1000, :max=>2000}
  #
  # If more than 1 ART conditions are specified separately, the former conditions will be ignored.
  #
  #  artConds "cpuclock"=>{:min=>1000} # This condition will be ignored.
  #  artConds "cpuclock"=>{:max=>2000}
  #

  #
  # The following two cases are equivalent because ART ids specified in arguments of 'artConds' 
  # can be omitted from arguments of 'arts',
  # 
  # case 1:
  #  arts ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable", "loadAvgOverTheLast5min", "cpuclock", "memsize"]
  #  artConds "loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}
  #
  # case 2:
  #  arts ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable"]
  #  artConds "loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}
  #
end
