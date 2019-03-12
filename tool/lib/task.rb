
require_relative 'loggable'

module Paiza

  class Task

    include Paiza::Loggable

    attr_reader :input_specs, :ut_cases

    def initialize
      @input_specs = []
      @ut_cases = []
    end

    def loadfile file_name
      if File.exist? file_name
        @txt = File.read(file_name)
        get_input_specs
        get_ut_cases
      end
      if @ut_cases.empty?
        @ut_cases << ['', ['expect1'], ['input1']]
      end
      self
    end

    def summary
      "ut case count:#{@ut_cases.size}"
    end

    private

    def match_reg? reg, force = true
      if reg =~ @txt
        @txt = $'
        $~
      else
        errlog("not match (#{reg}) | #{@txt.split[0, 5].join ' '}") if force
        nil
      end
    end

    def split_lines s
      s.chomp.split(?\n).reject { |line| line.empty? }
    end

    def get_input_specs
      if match_reg?(/^入力される値$/)
        if m = match_reg?(/標準入力からの値取得方法はこちらをご確認ください$/)
          @input_specs = split_lines(m.pre_match)
        end
      end
      errlog '入力仕様がない' if @input_specs.empty?
    end

    def get_ut_cases
      reg_input = /^入力例(\d*)\n/
      reg_expect = /^出力例(\d*)\n/
      reg_end = /^(解答欄|値取得)/

      m1 = match_reg?(reg_input)
      while m1 do
        idx1 = m1[1]
        if m2 = match_reg?(reg_expect)
          idx2 = m2[1]
          input = m2.pre_match

          m1 = match_reg?(reg_input, false)
          m3 = m1 || match_reg?(reg_end)
          next unless m3
          if idx1 == idx2
            @ut_cases << [idx1, split_lines(m3.pre_match), split_lines(input)]
          else
            errlog "ut case index not match (#{idx1}/#{idx2}) #{input}"
          end
        end
      end
    end

  end

end

