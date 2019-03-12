
OutFileName = './task/utresult.all'

def pmsg msg
  puts msg
  $stdout.flush
end

def get_errlogs
  Dir.glob('task/**/errlog.txt')
end

start = "#{ENV['PRJ_DIR']}/tool/start_paiza.rb"
raise "no script (#{start})" unless File.exist?(start)

targets = Dir.glob('**/task.txt').map { |f| File.dirname f }
if targets.empty?
  pmsg "no task.txt exist"
else
  get_errlogs.each { |e| system 'rm ' + e }
  pmsg "#{targets.size} task.txt exist"
  open(OutFileName, 'wt') do |f|
    targets.each do |dir|
      pmsg "[#{dir}]"
      f.puts "[#{dir}]"
      Dir.chdir(dir) do
        system "ruby #{start} -q --no-answer"
        f.puts `ruby ./unittest.rb`
      end
    end
  end
  get_errlogs.each { |e| system 'cat ' + e }
  pmsg 'finished'
end

