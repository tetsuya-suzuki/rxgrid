#
# This is an example with ART scripts.
#

art "onMacmini" do |t|
  t.localPathName = "macmodel"
  t.arguments = ["^Mac mini"]
end

art "onOurMachines" do |t|
  t.localPathName = "hostname"
  t.arguments = ["^tslab"] # We assume that host names of our machines start with 'tslab'
end

art "onLeoardOrSnowLeopard" do |t|
  t.localPathName = "sysver"
  t.arguments = ["Mac OS X( Server)? 10.(5|6)"]
end

art "bcIsInstalled" do |t|
  t.localPathName = "exist"
  t.arguments = ["/usr/bin/bc"]
end

art "bcIsReadable" do |t|
  t.localPathName = "readable"
  t.arguments = ["/usr/bin/bc"]
end

art "bcIsExecutable" do |t|
  t.localPathName = "executable"
  t.arguments = ["/usr/bin/bc"]
end

art "cpuclock" do |t|
  t.localPathName = "cpuclock" # CPU clock in MHz
end

art "loadAvgOverTheLast5min" do |t|
  # The ART script 'loadavg' puts the value of the expression '<load_average>*100+1'. 
  t.localPathName = "loadavg"
  t.arguments = ["5"]  # 1 for the load average over the last 1 minute
               # 5 for the load average over the last 5 minutes
               # 15 for the load average over the last 15 minutes
end

art "memsize" do |t|
  t.localPathName = "memsize"
end

file "bc_exp1.txt" do |t|
  t.agentPathName = "bc_exp1.txt"
  t.localPathName = "bc_exp1.txt"
  t.isExecutable = false
end

task "bc" do |t|
  t.command = "/usr/bin/bc"
  t.arguments = ["-q", "bc_exp1.txt"]
  t.refersTo = ["bc_exp1.txt"]
end

job "job1" do  |t|
  t.tasks = ["bc"]

  t.arts = ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable", "loadAvgOverTheLast5min", "cpuclock", "memsize"]
  #
  # The above line can be divided as follows.
  #
  #  t.arts = ["onMacmini"] # run on Mac mini.
  #  t.arts = ["onOurMachines"] # run on our machines
  #  t.arts = ["onLeoardOrSnowLeopard"] # run on Leopard or Snow Leopard.
  #  t.arts = ["bcIsInstalled"]  # The command 'bc' must be installed.
  #  t.arts = ["bcIsReadable"]   # The command 'bc' must be readable.
  #  t.arts = ["bcIsExecutable"] # The command 'bc' must be executable.
  #  t.arts = ["loadAvgOverTheLast5min"] # The load average over the last 5 minutes.
  #  t.arts = ["cpuclock"] # The cpu clock in MHz
  #  t.arts = ["memsize"]   # The memory size in MB
  #

  t.artConds = {"loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}}
  #
  # The above line can be divided as follows.
  #
  #  t.artConds = {"loadAvgOverTheLast5min"=>{:max=>51}} # The load average over the 5 minutes must be at most 0.50.
  #  t.artConds = {"cpuclock"=>{:min=>2000}}  # CPU clock must be at least 2000 MHz (2 GHz).
  #  t.artConds = {"memsize"=>{:eq=>1024}}    # The memory size must be 1024 MB (1 GB).
  #

  #
  # More than 1 ART conditions for an ART id must be specified as follows.
  #
  #  t.artConds = {"cpuclock"=>{:min=>1000, :max=>2000}}
  #
  # If more than 1 ART conditions are specified separately, the former conditions will be ignored.
  #
  #  t.artConds = {"cpuclock"=>{:min=>1000}} # This condition will be ignored.
  #  t.artConds = {"cpuclock"=>{:max=>2000}}
  #

  #
  # The following two cases are equivalent because ART ids specified in arguments of 'artConds' 
  # can be omitted from arguments of 'arts',
  # 
  # case 1:
  #  t.arts = ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable", "loadAvgOverTheLast5min", "cpuclock", "memsize"]
  #  t.artConds = {"loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}}
  #
  # case 2:
  #  t.arts = ["onMacmini", "onOurMachines", "onLeoardOrSnowLeopard", "bcIsInstalled", "bcIsReadable", "bcIsExecutable"]
  #  t.artConds = {"loadAvgOverTheLast5min"=>{:max=>51}, "cpuclock"=>{:min=>2000}, "memsize"=>{:eq=>1024}}
  #
end
