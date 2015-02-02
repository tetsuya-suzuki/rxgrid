art "memsize" do |t|
  t.localPathName = "memsize"
end

file "bc_exp1.txt" do |t|
  t.localPathName = "bc_exp1.txt"
  t.agentPathName = "bc_exp1.txt"
  t.isExecutable = false
end

task "bc" do |t|
  t.command = "/usr/bin/bc"
  t.arguments = ["-q", "bc_exp1.txt"]
  t.refersTo = ["bc_exp1.txt"]
end

job "job1" do |t|
  t.tasks = ["bc"]
  t.artConds = "memsize"=>{:min=>1024}
end
