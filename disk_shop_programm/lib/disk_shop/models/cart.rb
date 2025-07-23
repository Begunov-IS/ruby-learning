module DiskShop
  module Models
    class Cart
      attr_accessor :id, :owner_id, :items

      def initialize(id, owner_id)
        @id = id
        @owner_id = owner_id
        @items = []
      end

      def add_item(product, quantity)
        existing_item = @items.find { |item| item[:product].id == product.id }
        
        if existing_item
          existing_item[:quantity] += quantity
        else
          @items << { product: product, quantity: quantity }
        end
      end

      def remove_item(product_id)
        @items.reject! { |item| item[:product].id == product_id }
      end

      def total_sum
        @items.sum { |item| item[:product].price * item[:quantity] }
      end

      def display_cart
        if @items.empty?
          puts "Корзина пуста"
        else
          puts "\n=== Содержимое корзины ==="
          @items.each_with_index do |item, index|
            product = item[:product]
            quantity = item[:quantity]
            puts "#{index + 1}. #{product.title} - #{quantity} шт. x #{product.price} руб. = #{product.price * quantity} руб."
          end
          puts "\nИтого: #{total_sum} руб."
        end
      end

      def clear
        @items = []
      end

      def empty?
        @items.empty?
      end
    end
  end
end