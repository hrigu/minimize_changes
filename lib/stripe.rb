class StripesBuilder
  attr_reader :stripes, :current_stripe

  def initialize
    @stripes = []
    @current_stripe = nil
  end

  def detect_product_stripes bedarf
    bedarf.each_with_index do |p, pi|
      p.each_with_index do |ts, ti|
        self.new_time_slot pi, ts, ti
      end
    end
    self.finish
  end

  def new_time_slot product, value, index
    if index == 0
      handle_value_change product, value, index
    else
      if current_stripe.value == value
        current_stripe.end_index = index
      else
        handle_value_change product, value, index
      end
    end
  end

  def finish
    save_stripe_if_good_enough
  end

  def save_stripe_if_good_enough
    if current_stripe && current_stripe.value && current_stripe.size > 1
      stripes << current_stripe
    end
  end

  def handle_value_change product, value, index
    save_stripe_if_good_enough
    @current_stripe = Stripe.new(product, value, index, index)
  end

  def inspect
    stripes.sort!.map { |s| s.inspect }.join("\n")
  end
end


class Stripe
  attr_accessor :product, :value, :start_index, :end_index

  def initialize product, value, start_index, end_index
    @product, @value, @start_index, @end_index = product, value, start_index, end_index
  end

  def inspect
    "product: #{product}, size: #{size}, value: #{value}, start_index: #{start_index}, end_index: #{end_index}"
  end

  def constraint
    #'(plan[m,5] == 1) /\ (plan[m,6] == 1) /\ (plan[m,8] == 1) /\ (plan[m,8] == 1)'
    (start_index..end_index).map { |index| "(plan[m,#{index+1}] == #{product+1})"}.join(' /\ ')
  end

  def size
    (end_index+1) - start_index
  end

  def <=>(another_stripe)
    if self.size < another_stripe.size
      -1
    elsif self.size > another_stripe.size
      1
    else
      0
    end
  end

end
