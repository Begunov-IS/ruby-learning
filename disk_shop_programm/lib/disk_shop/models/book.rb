module DiskShop
  module Models
    class Book < Product
      attr_accessor :author

      def initialize(id, title, author, price, quantity = 1)
        super(id, "book", title, price, quantity)
        @author = author
      end

      def to_s
        "Книга: #{@title}, автор: #{@author} - #{@price} руб. (в наличии: #{@quantity})"
      end
    end
  end
end