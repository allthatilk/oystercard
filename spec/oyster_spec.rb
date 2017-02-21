require 'oyster'

describe Oystercard do
  subject(:card) {described_class.new}
  # Write an RSpec test for the Oystercard class that will test that a freshly
  # initialized card has a balance of 0 by default, see it fail, then write an
  # implementation (Oystercard class code) that will make the test pass.
  describe "card balance" do
    context "balance state" do
      it "has a balance of zero" do
        expect(card.balance).to eq 0
      end
    end

    context "changing card balance" do
      it "increases the card balance" do
        expect { card.top_up 5 }.to change{ card.balance }.by 5
      end

      it "decreases the card balance" do
        expect { card.deduct 5 }.to change{ card.balance }.by -5
      end
    end

    context "balance limit" do
      it "checks that no more than £90 can be added" do
        maximum_balance = Oystercard::LIMIT
        message = "Maximum balance of £#{maximum_balance} exceeded"
        expect { card.top_up maximum_balance + 1 }.to raise_error message
      end
    end

  describe "Touching in and out" do
  # context "touch-in requires card to have a balance" do

    before :each do
      card.top_up(Oystercard::LIMIT)
     end

    context "touching in" do
      it "allows the card to be touched-in" do
        # expect(card.touch_in).to be true
        expect{ card.touch_in }.to change{ card.in_journey? }.to true
      end
    context "touching out" do
      it "raises an error if the card is already in a journey" do
        expect{ 2.times{card.touch_in} }.to raise_error("Card already in journey")
      end

      it "allows the card to be touched-out" do
        # expect(card.touch_out).to be false
        expect{ card.touch_in }.to change{ card.in_journey? }.to true
      end

      it "raises an error if the card is not in a journey" do
        expect{ 2.times{card.touch_out} }.to raise_error("Card is not in a journey")
      end
    end

    context "journey state" do
      it "returns true if the card is in a journey" do
        expect{ card.touch_in }.to change{ card.in_journey? }.to true
      end
      it "returns false if the card is not in a journey" do
        card.touch_in
        expect{ card.touch_out }.to change{ card.in_journey? }.to false
      end
    end

end
