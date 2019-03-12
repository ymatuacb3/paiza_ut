
module Paiza

  module Loggable

    @@loggable_errlog_output = false

    def errlog msg
      open('./errlog.txt', 'ab') do |f|
        unless @@loggable_errlog_output
          @@loggable_errlog_output = true
          f.puts "[#{Time.now}]"
        end
        f.puts "#{self.class}: #{msg}"
      end
    end

    def trace msg
      f.puts "#{self.class}: #{msg}"
    end

  end

end

