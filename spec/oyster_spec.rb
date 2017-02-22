require 'oyster'

describe Oystercard do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }
  let(:balance)  { 0 }
  subject(:card) { described_class.new(balance) }

  describe "Card balance" do
    context "balance state" do
      it "has a balance of zero" do
        expect(card.balance).to eq 0
      end
    end

    context "changing card balance" do
      it "increases the card balance" do
        expect { card.top_up 5 }.to change{ card.balance }.by 5
      end
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
    let(:balance) { 5 }
    context "touching in" do
      it "allows the card to be touched-in" do
        expect{ card.touch_in(entry_station) }.to change{ card.in_journey? }.to true
      end

      it "remembers where I started journey from" do
        card.touch_in(entry_station)
        expect(card.entry_station).to eq entry_station
      end
    end

    context "raising error when touching in" do
      let(:balance) {0}
      it "raises an error unless the balance is £1" do
        message = "You do not have minimum balance to make this journey"
        expect{card.touch_in(entry_station)}.to raise_error message
      end
    end

    context "touching out" do
      before(:each) do
        card.touch_in(entry_station)
      end

      it "allows the card to be touched-out" do
        expect{ card.touch_out(exit_station) }.to change{ card.in_journey? }.to false
      end

      it "deducts fare from balance on touch out" do
        expect{ card.touch_out(exit_station) }.to change{ card.balance }.by -Oystercard::MIN_LIMIT
      end

      it "forgets the entry station on touch out" do
        card.touch_out(exit_station)
        expect(card.entry_station).to eq nil
      end
    end
  end

  describe "Journeys" do
    let(:balance) { 5 }

    context "recording journeys" do
      let(:journey) {{entry_station: entry_station, exit_station: exit_station}}

        before(:each) do
          card.touch_in(entry_station)
        end
          it "initially an empty list of journey" do
            expect(card.journeys).to be_empty
          end

          it "creates a journey after each touch_in touch_out pair" do
            card.touch_out(exit_station)
            expect(card.journeys).to include journey
          end
        end

     context "journey state" do
      it "returns true if the card is in a journey" do
        expect{ card.touch_in(entry_station) }.to change{ card.in_journey? }.to true
      end

      it "returns false if the card is not in a journey" do
        card.touch_in(entry_station)
        expect{ card.touch_out(exit_station) }.to change{ card.in_journey? }.to false
      end
    end
  end
end
