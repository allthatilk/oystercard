class Oystercard

  MAX_LIMIT = 90
  MIN_LIMIT = 1

  attr_accessor :entry_station, :exit_station, :journeys

  def initialize(balance = 0, entry_station = nil, exit_station = nil)
    @balance = balance
    @entry_station = entry_station
    @exit_station = exit_station
    @journeys = []
  end

  def top_up(money)
    message = "Maximum balance of £#{MAX_LIMIT} exceeded"
    raise message if (balance + money > MAX_LIMIT )
    @balance += (money)
  end

  def touch_in(entry_station)
    message = "You do not have minimum balance to make this journey"
    raise message if balance < MIN_LIMIT
    self.entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(MIN_LIMIT)
    journeys << {entry_station: entry_station, exit_station: exit_station}
    self.entry_station = nil
    self.exit_station = nil
  end

  def in_journey?
    entry_station ? true : false
  end

attr_reader :balance

private

def deduct(money)
  @balance -= money
end

end
