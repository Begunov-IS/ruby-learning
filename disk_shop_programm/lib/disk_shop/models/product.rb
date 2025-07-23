module DiskShop
  module Models
    class Product
      attr_accessor :id, :type, :title, :price, :quantity

      def initialize(id, type, title, price, quantity = 1)
        @id = id
        @type = type
        @title = title
        @price = price
        @quantity = quantity
      end

      def to_s
        "#{@title} - #{@price} руб. (в наличии: #{@quantity})"
      end

      def available?
        @quantity > 0
      end
    end
  end
end