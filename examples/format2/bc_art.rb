art "memsize" do
  localPathName "memsize"
end

file "bc_exp1.txt" do
  localPathName "bc_exp1.txt"
  agentPathName "bc_exp1.txt"
  isExecutable false
end

task "bc" do
  command "/usr/bin/bc"
  arguments "-q", "bc_exp1.txt"
  refersTo "bc_exp1.txt"
end

job "job1" do 
  tasks "bc"
  artConds "memsize"=>{:min=>1024}
end
