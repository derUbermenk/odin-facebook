# Parse and format amount of time passed 
# after given time
class TimePassed

  # format the amount of time passed given
  #   the time argument
  #
  # @params last_update_time [Time]
  # @return [String] the formatted amount of 
  #   time passed
  def self.format(updated_at)
    # format the time based on the amount of time that has passed
    #   since update

    case @updated_at = updated_at
    when TimeAgo.year then year_format
    when TimeAgo.week then month_format
    when TimeAgo.day  then day_format
    when TimeAgo.hour then hour_format 
    when TimeAgo.minute then minute_format
    end
  end


  # define private class methods

  def self.year_format
    @updated_at.strftime '%b, %Y'
  end

  def self.month_format
    @updated_at.strftime '%b %d'
  end

  def self.day_format
    @updated_at.strftime '%A'
  end

  def self.hour_format
    hours_ago = TimeAgo.time_difference(@updated_at, :hour)
    "#{hours_ago} hr"
  end

  def self.minute_format
    minutes_ago = TimeAgo.time_difference(@updated_at, :minute)
    "#{minutes_ago} min"
  end

  private_class_method :year_format
end


# collection of modules used to calculate how
#   long ago a given time was all methods return
#   a boolean
#
# all methods return procs
# 
# see this article on use of test case for more explanation
#   https://www.rubyguides.com/2015/10/ruby-case/#:~:text=range.rb%23L178-,Procs%20%2B%20Case,-Another%20interesting%20class
#
module TimeAgo

  PRESENT = Time.now

  # returns a proc for checking check if 
  #   the argument 'time' is a year ago
  def self.year
    Proc.new do |time|
      PRESENT.year > time.year
    end
  end

  # returns a proc for checking check if 
  #   the argument 'time' is a week ago
  def self.week
    Proc.new do |time|
      days_since = time_difference(time, :day)
      
      days_since >= 7
    end
  end

  def self.day
    Proc.new do |time| 
      time.day != PRESENT.day
    end
  end

  def self.hour
    Proc.new do |time| 
      hours_since = time_difference(time, :hour)

      hours_since >= 1
    end
  end

  def self.minute
    Proc.new do |time|
      hours_since = time_difference(time, :hour)

      hours_since < 1
    end
  end

  
  # private module methods

  # returns the time between current time and a given time 
  #   in the past difference in the given time_unit
  # 
  # @params time_ago [Time]
  # @params time_unit [Symbol]
  # @return converted_time_in_unit [Integer] 
  def self.time_difference(time_ago, time_unit)
    # doing operations on kinds of Time returns it in seconds
    time_diff_in_second = PRESENT - time_ago

    # convert the difference to the time_unit given
    converted_time_in_unit = time_diff_in_second / 1.send(time_unit)

    converted_time_in_unit.floor
  end
end

