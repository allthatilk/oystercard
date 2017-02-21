class Oystercard

MAX_LIMIT = 90
MIN_LIMIT = 1

  def initialize(balance = 0)
    @balance = balance
    @in_journey = false
  end

  def top_up(money)
    message = "Maximum balance of £#{MAX_LIMIT} exceeded"
    raise message if (balance + money > MAX_LIMIT )
    @balance += (money)
  end

  def touch_in
    message = "You do not have minimum balance to make this journey"
    raise message if balance < MIN_LIMIT
    @in_journey = true
  end

  def touch_out
    @in_journey = false
    deduct(MIN_LIMIT)
  end

  def in_journey?
    @in_journey
  end

attr_reader :balance

private

def deduct(money)
  @balance -= money
end

end
