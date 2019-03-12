
lst = Dir.glob('task/**/answer.rb').map do |f|
  dir = File.dirname(f)
  err = "#{dir}/errlog.txt"
  if File.exist?(err)
    raise "fix #{err} before create confirmed.list"
  end
  File.basename(dir).upcase
end

open('confirmed.list', 'wb') do |f|
  f.puts '確認済み問題一覧'
  f.puts lst.sort.join(?\n)
end

