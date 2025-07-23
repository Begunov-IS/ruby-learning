module DiskShop
  module Models
    class Customer < User
      attr_accessor :cart

      def initialize(id, name, login, password)
        super(id, name, login, password)
        @cart = Cart.new(id, id)
      end

      def add_to_cart(product, quantity, store)
        if product.quantity >= quantity
          @cart.add_item(product, quantity)
          store.decrease_quantity(product.id, quantity)
          puts "Товар '#{product.title}' добавлен в корзину (#{quantity} шт.)"
          true
        else
          puts "Недостаточно товара на складе. Доступно: #{product.quantity} шт."
          false
        end
      end

      def view_cart
        @cart.display_cart
      end

      def get_total_sum
        @cart.total_sum
      end

      def clear_cart
        @cart.clear
        puts "Корзина очищена"
      end
    end
  end
end