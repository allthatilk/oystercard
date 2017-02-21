require 'oyster'

describe Oystercard do
  let(:entry_station) {double(:entry_station)}
  let(:exit_station) {double(:exit_station)}
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

      # it "decreases the card balance" do
      #   expect { card.deduct 5 }.to change{ card.balance }.by -5
      # end
    end

    context "balance MAX_LIMIT" do
      it "checks that no more than £90 can be added" do
        maximum_balance = Oystercard::MAX_LIMIT
        message = "Maximum balance of £#{maximum_balance} exceeded"
        expect { card.top_up maximum_balance + 1 }.to raise_error message
      end
    end
  end

  describe "Touching in and out" do
    context "touching in" do

      it "allows the card to be touched-in" do
        card.top_up(5)
        expect{ card.touch_in(entry_station) }.to change{ card.in_journey? }.to true
      end

      it "raises an error unless the balance is £1" do
        message = "You do not have minimum balance to make this journey"
        expect{card.touch_in(entry_station)}.to raise_error message
      end

      it "remembers where I strated journey from" do
        card.top_up(5)
        card.touch_in(entry_station)
        expect(card.entry_station).to eq entry_station
      end
    end

    context "touching out" do

      before(:each) do
        card.top_up(5)
        card.touch_in(entry_station)
      end

      it "allows the card to be touched-out" do
        expect{ card.touch_out(exit_station) }.to change{ card.in_journey? }.to false
      end

      it "deducting fare" do
        expect{ card.touch_out(exit_station) }.to change{ card.balance }.by -Oystercard::MIN_LIMIT
      end

      it "forgets the entry station on touch out" do
        card.touch_out(exit_station)
        expect(card.entry_station).to eq nil
      end
    end

    context "Journeys" do
      let(:journey) {{entry_station: entry_station, exit_station: exit_station}}
      before(:each) do
        card.top_up(5)
        card.touch_in(entry_station)
      end

      it "shows my journeys" do
        expect(card.journeys).to respond_to(:keys)
      end

      it "initially an empty list of journey" do
        expect(card.journeys).to be_empty
      end

      it "creates a journey after each touch_in touch_out pair" do
        card.touch_out(exit_station)
        expect(card.journeys).to include journey
      end

    end
  end

    describe "journey state" do

      before(:each) do
        card.top_up(5)
      end
      it "returns true if the card is in a journey" do
        expect{ card.touch_in(entry_station) }.to change{ card.in_journey? }.to true
      end

      it "returns false if the card is not in a journey" do
        card.touch_in(entry_station)
        expect{ card.touch_out(exit_station) }.to change{ card.in_journey? }.to false
      end
    end

end
