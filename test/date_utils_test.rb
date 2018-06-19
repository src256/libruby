# coding: utf-8
require 'test_helper'

class DateUtilsTest < Minitest::Test
  include Libruby
  def test_days_in_month
    #
    d = Date.new(2018, 4, 12)
    n = DateUtils.days_in_month(d)
    assert_equal(30, n)
    
    d = Date.new(2018, 2, 12)
    n = DateUtils.days_in_month(d)
    assert_equal(28, n)

    # うるう年
    d = Date.new(2004, 2, 2)
    n = DateUtils.days_in_month(d)
    assert_equal(29, n) 
  end

  def test_days_in_year
    d = Date.new(2018, 4, 12)
    n = DateUtils.days_in_year(d)
    assert_equal(365, n)

    # うるう年
    d = Date.new(2004, 2, 2)
    n = DateUtils.days_in_year(d)
    assert_equal(366, n)     
  end

  def to_str(date)
    date.strftime("%Y/%m/%d")
  end

  def test_beginning_of_year
    d = Date.new(2018, 4, 12)
    b = DateUtils.beginning_of_year(d)
    assert_equal("2018/01/01", to_str(b))

    #うるう年
    d = Date.new(2004, 4, 12)
    b = DateUtils.beginning_of_year(d)
    assert_equal("2004/01/01", to_str(b))    
  end

  def test_end_of_year
    d = Date.new(2018, 4, 12)
    b = DateUtils.end_of_year(d)
    assert_equal("2018/12/31", to_str(b))

    #うるう年
    d = Date.new(2004, 4, 12)
    b = DateUtils.end_of_year(d)
    assert_equal("2004/12/31", to_str(b))  
  end

  def test_beginning_of_month
    d = Date.new(2018, 4, 12)
    b = DateUtils.beginning_of_month(d)
    assert_equal("2018/04/01", to_str(b))

    # うるう年
    d = Date.new(2004, 4, 12)
    b = DateUtils.beginning_of_month(d)
    assert_equal("2004/04/01", to_str(b))      
  end


  def test_end_of_month
    d = Date.new(2018, 4, 12)
    b = DateUtils.end_of_month(d)
    assert_equal("2018/04/30", to_str(b))

    # うるう年
    d = Date.new(2004, 4, 12)
    b = DateUtils.end_of_month(d)
    assert_equal("2004/04/30", to_str(b))   
  end

  def test_beginning_of_week
    d = Date.new(2018, 6, 16)
    b = DateUtils.beginning_of_week(d)
    assert_equal("2018/06/10", to_str(b))    
  end

  def test_end_of_week
    d = Date.new(2018, 6, 16)
    b = DateUtils.end_of_week(d)
    assert_equal("2018/06/16", to_str(b))      
  end  
end
