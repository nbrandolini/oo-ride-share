require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @end_time != nil && @start_time !=nil && @end_time < @start_time
        raise ArgumentError.new("Invalid times")
      end

      if @rating !=nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end #initialize

    def duration
      if end_time == nil
        raise ArgumentError.new ("Ride still in progress")
      else
        return duration = (@end_time - @start_time)
      end
    end  # duration

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

  end
end
