require 'order'

describe Order do

  context "Order responds to" do

    it "show_menu" do
      expect(subject).to respond_to(:show_menu)
    end

    it "select_items" do
      expect(subject).to respond_to(:select_items).with(1).argument
    end

    it "order_total" do
      expect(subject).to respond_to(:total)
    end

    it "check_total" do
      expect(subject).to respond_to(:check_total)
    end

    it "check_out" do
      expect(subject).to respond_to(:checkout)
    end

  end

  context "show_menu" do 

    it "puts the menu and returns the menu hash" do
      expect(subject.show_menu).to eq({ "Biryani" => 9, "Korma" => 9, "Tikka Masala" => 7, "Set meal 1" => 25, "Naan" => 3, "Pilau rice" => 3, "Poppadom" => 2, "Cake" => 3, "Soft drinks" => 1 })
    end
  end

  context "select_items" do

    before(:each) do
      @order = Order.new
    end

    it "returns order total" do
      expect(@order.select_items(["Biryani", "Naan"])).to eq(12)
    end

    it "lets user add items multiple times" do
      @order.select_items(["Korma"])
      expect(@order.select_items(["Pilau rice", "Naan"])).to eq(15)
    end

    it "lets user add multiples of the same item" do
      expect(@order.select_items(["Korma", "Korma"])).to eq(18)
    end

  end

  context "check_total" do

    before(:each) do      
      @order = Order.new
      @order.select_items(["Korma"])
    end

    it "confirms correct total" do
      expect(@order.check_total).to eq("Your order total is 9")
    end

    it "raises error that total is incorrect" do
      @order.total = 12
      expect { @order.check_total }.to raise_error "Incorrect order total"
    end
  end

  context "checkout" do
    before(:each) do      
      @order = Order.new
      @order.select_items(["Korma"])
      @time = (Time.now + (60 * 60)).strftime("%k:%M")
    end

    it "returns order confirmation" do
      expect(@order.checkout).to eq("Thank you! Your order will be delivered by #{@time}")
    end

    it "sends a text with the delivery time" do
      expect(@order).to receive(:send_confirmation)
      @order.send_confirmation(@time)
    end
  end

end
