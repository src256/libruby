# coding: utf-8
require 'bigdecimal'

module Libruby
  
  class UnitConverterUtils
    MM_PER_INCH = 25.4
    MM_PER_FEET = 304.8
    MM_PER_CM = 10
    MM_PER_M = 100
    
    def self.get_num(value)
      # 数値部分を取得してBigDecimalとして返す
      unless value =~ /(\d+(?:\.\d+)?)/
        raise ArgumentError, 'cannot get number string'
      end
      BigDecimal.new($1)
    end
    
    def self.to_s(num, limit = nil)
      #https://stackoverflow.com/questions/18533026/trim-a-trailing-0
      # 単なる数値として返す。ただし少数以下のゼロは削除。
      i, f = num.to_i, num.to_f
      result = nil
      if i == f
        result = i.to_s
      else
        if limit
          result = sprintf("%.#{limit}f", f).sub(/0+$/, '') 
        else
          result = f.to_s
        end
      end
      result
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

    def self.unit_str(str, column, units)
      numbers = []
      str.each_char {|num| numbers << num.to_i }
      # 1234567
      number_blocks = numbers.reverse.each_slice(column).to_a
      # [7, 6, 5, 4], [3, 2, 1], 
      result = ''
      number_blocks.each_with_index do |block, index|
        unit_index = index - 1
        u = unit_index >= 0 && unit_index < units.size ? units[unit_index] : '' 
        number_str = block.reverse.join
        unless number_str =~ /^0+$/
          result = number_str + u + result
        end
      end
      result      
    end

    def self.ja(str)
      units = %w(万 億 兆 京 垓 予 穣 溝 澗 正 裁 極 恒河沙 阿僧祇 那由多 不可思議 無量大数 洛叉 倶胝)
      unit_str(str, 4, units)
      
      # numbers = []
      # str.each_char {|num| numbers << num.to_i }
      # # 1234567
      # number_blocks = numbers.reverse.each_slice(4).to_a
      # # [7, 6, 5, 4], [3, 2, 1], 
      # result = ''
      # number_blocks.each_with_index do |block, index|
      #   unit_index = index - 1
      #   u = unit_index > 0 && unit_index < units.size ? units[unit_index] : ''        
      #   number_str = block.reverse.join
      #   unless number_str =~ /^0+$/
      #     result = number_str + u + result
      #   end
      # end
      # result 
    end

    def self.en(str)
      # https://phrase-phrase.me/ja/keyword/million-billion-trillion
      units = %w(thousand million billion trillion quadrillion quintillion)
      unit_str(str, 3, units)      
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

    def self.to_en_s(num)
      s = to_s(num)
      if s =~ /(\d+)(\.\d+)/
        result = en($1) + $2
      else
        result = en(s)
      end
      result
    end

    def self.inch_to_mm(num)
      num * MM_PER_INCH
    end
    
    def self.mm_to_inch(num)
      num / MM_PER_INCH
    end

    def self.feet_to_mm(num)
      num * MM_PER_FEET
    end

    def self.mm_to_feet(num)
      num / MM_PER_FEET      
    end

    def self.cm_to_mm(num)
      num * MM_PER_CM
    end

    def self.mm_to_cm(num)
      num / MM_PER_CM
    end

    def self.m_to_mm(num)
      num * MM_PER_M
    end

    def self.mm_to_m(num)
      num / MM_PER_M
    end
        
#    UNIT_LENGTH_INCH = 10
#    UNIT_LENGTH_I

  end

  
  class UnitConverterResult
    TYPE_ORIGINAL = 1
    TYPE_NUMBER = 2
    TYPE_EN = 3    
    TYPE_JA = 4

    TYPE_LENGTH_INCH = 101
    TYPE_LENGTH_FEET = 102
    TYPE_LENGTH_MM = 111
    TYPE_LENGTH_CM = 112
    TYPE_LENGTH_M = 113

    TYPE_LABELS = {
      TYPE_ORIGINAL => 'オリジナル',
      TYPE_NUMBER => '数値表現',
      TYPE_EN => '英語表現',
      TYPE_JA => '日本語表現',
      TYPE_LENGTH_INCH => 'インチ表現',
      TYPE_LENGTH_FEET => 'フィート表現',
      TYPE_LENGTH_MM => 'ミリメートル表現',
      TYPE_LENGTH_CM => 'センチメートル表現',
      TYPE_LENGTH_M => 'メートル表現', 
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

    def self.create_en(value)
      UnitConverterResult.new(TYPE_EN, UnitConverterUtils.to_en_s(value))
    end

    def self.create_inch(value)
      num = UnitConverterUtils.mm_to_inch(value)
      str = UnitConverterUtils.to_s(num, 2) + "inch"
      UnitConverterResult.new(TYPE_LENGTH_INCH, str)
    end            

    def self.create_feet(value)
      num= UnitConverterUtils.mm_to_feet(value)
      str = UnitConverterUtils.to_s(num, 2) + "feet"    
      UnitConverterResult.new(TYPE_LENGTH_FEET, str)
    end            

    def self.create_mm(value)
      str = UnitConverterUtils.to_s(value, 2) + "mm"       
      UnitConverterResult.new(TYPE_LENGTH_MM, str)
    end            

    def self.create_cm(value)
      num = UnitConverterUtils.mm_to_cm(value)
      str = UnitConverterUtils.to_s(num, 2) + "cm"
      UnitConverterResult.new(TYPE_LENGTH_CM, str)
    end            

    def self.create_m(value)
      num = UnitConverterUtils.mm_to_m(value)
      str = UnitConverterUtils.to_s(num, 2)+ "m"
      UnitConverterResult.new(TYPE_LENGTH_M, str)
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
  
  class TypeConverter
    def initialize(type, value)
      @value = value
      @type = type
    end    
  end
  
  class NumberConverter < TypeConverter
    def self.calc_num(original_num, type)
      num = original_num
      if type == UnitConverter::UNIT_MILLION
        # 100万倍
        num = original_num * 1000000
      elsif type == UnitConverter::UNIT_BILLION
        # 10億倍
        num = original_num * 1000000000
      end
      num
    end
    
    def convert
      original_num = UnitConverterUtils.get_num(@value)
      num = self.class.calc_num(original_num, @type)
      results = []
      results << UnitConverterResult.create_original(@value)
      results << UnitConverterResult.create_number(num)
      results << UnitConverterResult.create_en(num)
      results << UnitConverterResult.create_ja(num) 
      results
    end
  end

  class LengthConverter < TypeConverter
    def self.calc_length(original_num, type)
      num = original_num
      if type == UnitConverter::UNIT_LENGTH_INCH
        num = UnitConverterUtils.inch_to_mm(num)
      elsif type == UnitConverter::UNIT_LENGTH_FEET
        num = UnitConverterUtils.feet_to_mm(num)
      elsif type == UnitConverter::UNIT_LENGTH_MM
      elsif type == UnitConverter::UNIT_LENGTH_CM
        num = UnitConverterUtils.cm_to_mm(num)
      elsif type == UnitConverter::UNIT_LENGTH_M
        num = UnitConverterUtils.m_to_mm(num)
      end
      num
    end
    
    def convert
      original_num = UnitConverterUtils.get_num(@value)
      num = self.class.calc_length(original_num, @type)
      results = []
      results << UnitConverterResult.create_original(@value)
      results << UnitConverterResult.create_inch(num)
      results << UnitConverterResult.create_feet(num)
      results << UnitConverterResult.create_mm(num)
      results << UnitConverterResult.create_cm(num)
      results << UnitConverterResult.create_m(num)
      results      
    end
  end

  class UnitConverter
    # 数値コンバーター
    UNIT_NONE = 1    
    UNIT_MILLION = 2
    UNIT_BILLION = 3

    # 長さコンバーター
    UNIT_LENGTH = 100
    UNIT_LENGTH_INCH = 101
    UNIT_LENGTH_FEET = 102
    UNIT_LENGTH_MM = 111
    UNIT_LENGTH_CM = 112
    UNIT_LENGTH_M = 113
    
    def self.create_type_converter(value)
      converter = nil
      if value =~ /inch/i
        converter = LengthConverter.new(UNIT_LENGTH_INCH, value)
      elsif value =~ /feet/i
        converter = LengthConverter.new(UNIT_LENGTH_FEET, value)
      elsif value =~ /\d+\s*mm\b/
        converter = LengthConverter.new(UNIT_LENGTH_MM, value)
      elsif value =~ /\d+\s*cm\b/
        converter = LengthConverter.new(UNIT_LENGTH_CM, value)
      elsif value =~ /\d+\s*m\b/
        converter = LengthConverter.new(UNIT_LENGTH_M, value)
      elsif value =~ /million/i
        converter = NumberConverter.new(UNIT_MILLION, value)
      elsif value =~ /billion/i
        converter = NumberConverter.new(UNIT_BILLION, value)   
      else
        converter = NumberConverter.new(UNIT_NONE, value)           
      end
      converter
    end

    def self.convert(value)
      converter = UnitConverter.create_type_converter(value)
      results = []
      begin
        results = converter.convert
      rescue ArgumentError => e
        puts e.to_s
      end
      results
    end
  end
end
