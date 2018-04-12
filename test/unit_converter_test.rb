# coding: utf-8
require 'test_helper'

class UnitConvertesrTest < Minitest::Test
  include Libruby
  
  def test_convert
#    UnitConverter.convert(
  end

  def test_get_num
    result = UnitConverter.get_num(" 123 aaa")
    #    expect = BigDecimal.new("123")
    assert_equal("123", UnitConverterUtils.to_s(result))

    result = UnitConverter.get_num(" 123.45 aaa")
    assert_equal("123.45", UnitConverterUtils.to_s(result))
    
#    expect = BigDecimal.new()
#   
  end

  def test_get_unit
    result = UnitConverter.get_unit(" 123 aaa")
    assert_equal(UnitConverter::UNIT_NONE, result)

    result = UnitConverter.get_unit(" 123 million")
    assert_equal(UnitConverter::UNIT_MILLION, result)    
  end

  def test_calc_num
    result = UnitConverter.calc_num(BigDecimal.new("1"), UnitConverter::UNIT_MILLION)
    assert_equal("1000000", UnitConverterUtils.to_s(result))
  end

  def test_convert
    results = UnitConverter.convert("750 million")
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_ORIGINAL)
    assert_equal("1:オリジナル:750 million", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_NUMBER)
    assert_equal("2:数値表現:750,000,000", result.to_s)
    result = UnitConverterResult.find(results, UnitConverterResult::TYPE_JA)
    assert_equal("4:日本語表現:7億5000万", result.to_s)
  end
end

class UnitConverterUtilsTest < Minitest::Test
  include Libruby
  
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


