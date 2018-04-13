# coding: utf-8
require 'test_helper'

class UnitConvertesrTest < Minitest::Test
  include Libruby
  
#  def test_get_unit
#    result = UnitConverter.get_unit(" 123 aaa")
#    assert_equal(UnitConverter::UNIT_NONE, result)
#
#    result = UnitConverter.get_unit(" 123 million")
#    assert_equal(UnitConverter::UNIT_MILLION, result)
  #  end
  
  def test_create_type_converter
    converter = UnitConverter.create_type_converter("10m")
    assert_instance_of(LengthConverter, converter)

    converter = UnitConverter.create_type_converter("10 m.")
    assert_instance_of(LengthConverter, converter)    
  end
  
  def test_calc_num
    result = NumberConverter.calc_num(BigDecimal.new("1"), UnitConverter::UNIT_MILLION)
    assert_equal("1000000", UnitConverterUtils.to_s(result))
  end

  def test_number_convert
    results = UnitConverter.convert("750 million")
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_ORIGINAL)
    assert_equal("1:オリジナル:750 million", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_NUMBER)
    assert_equal("2:数値表現:750,000,000", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_JA)
    assert_equal("4:日本語表現:7億5000万", result.to_s)
  end

  def test_length_convert
    results = UnitConverter.convert("750 inch")
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_ORIGINAL)
    assert_equal("1:オリジナル:750 inch", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_INCH)
    assert_equal("101:インチ表現:750inch", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_FEET)
    assert_equal("102:フィート表現:62.5feet", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_MM)
    assert_equal("111:ミリメートル表現:19050mm", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_CM)
    assert_equal("112:センチメートル表現:1905cm", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_M)
    assert_equal("113:メートル表現:190.5m", result.to_s)


    results = UnitConverter.convert("5.44 inch")
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_ORIGINAL)
    assert_equal("1:オリジナル:5.44 inch", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_INCH)
    assert_equal("101:インチ表現:5.44inch", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_FEET)
    assert_equal("102:フィート表現:0.45feet", result.to_s)   
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_MM)
    assert_equal("111:ミリメートル表現:138.18mm", result.to_s)  
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_CM)
    assert_equal("112:センチメートル表現:13.82cm", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_M)
    assert_equal("113:メートル表現:1.38m", result.to_s)    
    
#    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_LENGTH_M)
#    assert_equal("113:メートル表現:190.5m", result.to_s)    
    

  end
end

class UnitConverterUtilsTest < Minitest::Test
  include Libruby

  def test_get_num
    result = UnitConverterUtils.get_num(" 123 aaa")
    assert_equal("123", UnitConverterUtils.to_s(result))

    result = UnitConverterUtils.get_num(" 123.45 aaa")
    assert_equal("123.45", UnitConverterUtils.to_s(result))
  end
  
  def test_to_s
    result = UnitConverterUtils.to_s(12)
    assert_equal("12", result)

    result = UnitConverterUtils.to_s(12.5)
    assert_equal("12.5", result)    
  end

  def test_ja
    result = UnitConverterUtils.ja("1234567")
    assert_equal("123万4567", result)

    result = UnitConverterUtils.ja("1400000") # 1.4 million
    assert_equal("140万", result)

    result = UnitConverterUtils.ja("750000000") # 750million
    assert_equal("7億5000万", result)

    result = UnitConverterUtils.ja("20000000") # 20 million
    assert_equal("2000万", result)

    result = UnitConverterUtils.ja("1000000000") # 1000 million
    assert_equal("10億", result)    
  end

  def test_en
    result = UnitConverterUtils.en("1234567")
    assert_equal("1million234thousand567", result)

    result = UnitConverterUtils.en("1400000") # 1.4 million
    assert_equal("1million400thousand", result)

    result = UnitConverterUtils.en("750000000") # 750million
    assert_equal("750million", result)

    result = UnitConverterUtils.en("7520000000") # 7billion520million
    assert_equal("7billion520million", result)    

#    result = UnitConverterUtils.ja("20000000") # 20 million
#    assert_equal("2000万", result)

#    result = UnitConverterUtils.ja("1000000000") # 1000 million
#    assert_equal("10億", result)    
  end  
  
  def test_to_comma_s
    result = UnitConverterUtils.to_comma_s(1234)
    assert_equal("1,234", result)

    result = UnitConverterUtils.to_comma_s(1234567)
    assert_equal("1,234,567", result)

    result = UnitConverterUtils.to_comma_s(123)
    assert_equal("123", result)

    result = UnitConverterUtils.to_comma_s(123.4)
    assert_equal("123.4", result)

    result = UnitConverterUtils.to_comma_s(123.4567)
    assert_equal("123.4567", result)    
  end
end


