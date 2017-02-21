class Oystercard

attr_accessor :entry_station
MAX_LIMIT = 90
MIN_LIMIT = 1

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
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

  def touch_out
    deduct(MIN_LIMIT)
    self.entry_station = nil
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
