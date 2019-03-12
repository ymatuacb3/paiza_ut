
require 'erb'
require_relative 'lib/task'

@opts = ARGV.select { |a| /\A-/ =~ a }

def generate_skelton name, task
  puts "generating #{name}.rb" unless @opts.include?('-q')
  tmpl = "#{ENV['PRJ_DIR']}/tmpl/#{name}.erb"
  erb = ERB.new(File.read(tmpl), nil, '%-')
  open("./#{name}.rb", 'wb') do |f|
    f.write erb.result(binding)
  end
end

task = Paiza::Task.new.loadfile('./task.txt')
%w! unittest answer !.each do |name|
  next if @opts.include?("--no-#{name}")
  generate_skelton name, task
end

