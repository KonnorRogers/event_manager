require 'time'
require_relative 'event_manager.rb'

# used to determine the best hours of the day
# for people to register
class TimeTargetting
  attr_accessor :times, :times_hash, :days

  def initialize
    @times = []
    @times_hash = Hash.new(0)
    @days = []
  end

  def read_csv
    EventManager.new.read_csv
  end

  def signup_times
    contents = read_csv

    contents.each do |row|
      time = row[:regdate]
      @times << parse_time(time).hour
      @days << parse_time(time)
    end
  end

  def parse_time(time)
    Time.strptime(time, '%m/%d/%y %H:%M')
  end

  def create_times_hash
    @times.each_with_object(@times_hash) { |o, h| h[o] += 1 }
  end

  # returns an array [day, number_of_signups]
  def find_best_day
    day_array = @days.map do |day|
      day.strftime('%A')
    end

    day_hash = day_array.each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
    day_hash.max_by { |_, v| v }
  end

  def determine_best_time
    @times_hash.max_by { |_, v| v }
  end

  def run
    puts 'Determining best time:'
    signup_times
    create_times_hash

    puts ''
    print "The best time to have people sign up is #{determine_best_time[0]}00."
    print " There were #{determine_best_time[1]} sign ups!\n\n"

    print "The best day for signups is #{find_best_day[0]}.\n"
  end
end

t = TimeTargetting.new
t.run
