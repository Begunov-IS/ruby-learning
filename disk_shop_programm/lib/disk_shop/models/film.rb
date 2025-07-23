module DiskShop
  module Models
    class Film < Product
      attr_accessor :year, :director

      def initialize(id, title, year, director, price, quantity = 1)
        super(id, "film", title, price, quantity)
        @year = year
        @director = director
      end

      def to_s
        "Фильм: #{@title} (#{@year}), режиссер: #{@director} - #{@price} руб. (в наличии: #{@quantity})"
      end
    end
  end
end