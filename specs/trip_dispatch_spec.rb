require_relative 'spec_helper'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver = dispatcher.drivers.first
      last_driver = dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end

    it 'stores start_time and end_time as instances of time' do
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.trips.first
      trip.start_time.must_be_instance_of Time
      dispatcher = RideShare::TripDispatcher.new
      trip = dispatcher.trips.first
      trip.end_time.must_be_instance_of Time
    end
  end

  describe "request trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      # 2,Emory Rosenbaum,1B9WEX2R92R12900E,AVAILABLE
      @new_ride = @dispatcher.request_trip(1)
    end
    it " creates a new trip" do
      @dispatcher.request_trip(1).must_be_instance_of RideShare::Trip
    end # it

    it "updates the passenger's trip list" do
      orig_number = @dispatcher.find_passenger(1).trips.length

      @dispatcher.request_trip(1)

      @dispatcher.find_passenger(1).trips.length.must_equal orig_number + 1
    end

    it "updates the driver's trip list" do
      orig_number = @dispatcher.available_drivers[0].trips.length
      driver_id = @dispatcher.available_drivers[0].id

      @dispatcher.request_trip(1)

      @dispatcher.find_driver(driver_id).trips.length.must_equal orig_number + 1
    end

    it "updates driver status" do
      @dispatcher.available_drivers[0].status.must_equal :AVAILABLE

      @dispatcher.request_trip(1)

      @dispatcher.request_trip(1).driver.status.must_equal :UNAVAILABLE
    end

    it "updates the trips for the dispatcher" do
      origin_number = @dispatcher.trips.length

      @dispatcher.request_trip(1)

      @dispatcher.trips.length.must_equal origin_number + 1
    end

  end

end
