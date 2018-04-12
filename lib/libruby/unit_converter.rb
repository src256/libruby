# coding: utf-8
require 'bigdecimal'

module Libruby
  
  class UnitConverterUtils
    def self.to_s(num)
      #https://stackoverflow.com/questions/18533026/trim-a-trailing-0
      # 単なる数値として返す。ただし少数以下のゼロは削除。
      i, f = num.to_i, num.to_f
      i == f ? i.to_s : f.to_s
    end

    def self.comma(str)
      #http://rubytips86.hatenablog.com/entry/2014/03/28/153843
      str.gsub(/(\d)(?=\d{3}+$)/, '\\1,') #=> "1,234,567,890"
    end

    def self.to_comma_s(num)
      s = to_s(num)
      result = nil
      if s =~ /(\d+)(\.\d+)/
        result = comma($1) + $2
      else
        result = comma(s)
      end
      result
    end

    def self.ja(str)
      units = %w(万 億 兆 京 垓 予 穣 溝 澗 正 裁 極 恒河沙 阿僧祇 那由多 不可思議 無量大数 洛叉 倶胝)
      
      numbers = []
      str.each_char {|num| numbers << num.to_i }
      # 1234567
      number_blocks = numbers.reverse.each_slice(4).to_a
      # [7, 6, 5, 4], [3, 2, 1], 
      result = ''
      number_blocks.each_with_index do |block, index|
        u = index > 0 ? units[index - 1] : ''
        result = block.reverse.join + u + result
      end
      result.sub!(/万0+/, '万')
      result 
    end

    def self.to_ja_s(num)
      s = to_s(num)      
      if s =~ /(\d+)(\.\d+)/
        result = ja($1) + $2
      else
        result = ja(s)
      end
      result
    end
  end

  
  class UnitConverterResult
    TYPE_ORIGINAL = 1
    TYPE_NUMBER = 2
    TYPE_EN = 3    
    TYPE_JA = 4

    TYPE_LABELS = {
      TYPE_ORIGINAL => 'オリジナル',
      TYPE_NUMBER => '数値表現',
      TYPE_JA => '日本語表現'
    }

    def self.find(results, type)
      results.find{|result| result.type == type}
    end

    def self.create_original(value)
      UnitConverterResult.new(TYPE_ORIGINAL, value)
    end

    def self.create_number(value)
      UnitConverterResult.new(TYPE_NUMBER, UnitConverterUtils.to_comma_s(value))
    end

    def self.create_ja(value)
      UnitConverterResult.new(TYPE_JA, UnitConverterUtils.to_ja_s(value))
    end    

    def initialize(type, value)
      @type = type
      @value = value
    end
    attr_reader :type, :value

    def type_label
      TYPE_LABELS[@type]
    end

    def to_s
      "#{@type}:#{type_label}:#{value}"
    end
  end

  
  class UnitConverter
    UNIT_NONE = 1
    UNIT_MILLION = 2
    
    def self.get_num(value)
      # 数値部分を取得してBigDecimalとして返す
      unless value =~ /(\d+(?:\.\d+)?)/
        raise ArgumentError, 'cannot get number string'
      end
      BigDecimal.new($1)
    end

    def self.get_unit(value)
      if value =~ /million/i
        return UNIT_MILLION
      end
      UNIT_NONE
    end

    def self.calc_num(original_num, unit)
      num = original_num
      if unit == UNIT_MILLION
        # 100万倍
        num = original_num * 1000000
      end
      num
    end

    def self.convert(value)
      results = []
      results << UnitConverterResult.create_original(value)
      begin
        original_num = get_num(value)
        unit = get_unit(value)
        num = calc_num(original_num, unit)
        results << UnitConverterResult.create_number(num)
        results << UnitConverterResult.create_ja(num)
      rescue ArgumentError => e
        puts e.to_s
      end
      results
    end
  end
end
