# coding: utf-8
module Libruby
  require 'date'
  
  class DateUtils
    def self.beginning_of_year(date)
      # ydayは1から
      date - date.yday + 1
    end
    def self.end_of_year(date)
      rest = days_in_year(date) - date.yday
      date + rest      
    end        
    def self.beginning_of_month(date)
      date - date.day + 1
    end
    def self.end_of_month(date)
      rest = days_in_month(date) - date.day
      date + rest
    end
    def self.beginning_of_week(date)
      days_from_sunday = date.wday
      result = date - days_from_sunday
      result
    end
    def self.end_of_week(date)
      # wdayは0〜6
      days_to_sunday = 6 - date.wday
      result = date + days_to_sunday
      result      
    end

    def self.days_in_month(date)
      Date.new(date.year, date.month, -1).day
    end

    def self.days_in_year(date)
      Date.new(date.year, 12, 31).yday
    end
  end
end


