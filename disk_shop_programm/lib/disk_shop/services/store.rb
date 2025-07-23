module DiskShop
  module Services
    class Store
      attr_accessor :id, :name, :products

      def initialize(id, name, products = [])
        @id = id
        @name = name
        @products = products
      end

      def add_product(product)
        @products << product
      end

      def load_items_from_json(file_path)
        begin
          file_content = File.read(file_path)
          data = JSON.parse(file_content)
          @products = []
          
          data['items'].each_with_index do |item, index|
            if item['type'] == 'film'
              product = Models::Film.new(
                index + 1,
                item['title'],
                item['year'],
                item['director'],
                item['price'],
                item['quantity']
              )
            elsif item['type'] == 'book'
              product = Models::Book.new(
                index + 1,
                item['title'],
                item['author'],
                item['price'],
                item['quantity']
              )
            end
            @products << product if product
          end
        rescue => e
          puts "Ошибка при загрузке файла: #{e.message}"
        end
      end

      def save_items_to_json(file_path)
        items = @products.map do |product|
          if product.is_a?(Models::Film)
            {
              'type' => 'film',
              'title' => product.title,
              'year' => product.year,
              'director' => product.director,
              'price' => product.price,
              'quantity' => product.quantity
            }
          elsif product.is_a?(Models::Book)
            {
              'type' => 'book',
              'title' => product.title,
              'author' => product.author,
              'price' => product.price,
              'quantity' => product.quantity
            }
          end
        end

        data = { 'items' => items }
        File.write(file_path, JSON.pretty_generate(data))
      end

      def display_items
        if @products.empty?
          puts "В магазине нет товаров"
        else
          puts "\n=== Список товаров ==="
          @products.each_with_index do |product, index|
            puts "#{index + 1}. #{product}"
          end
        end
      end

      def find_product_by_id(id)
        @products.find { |p| p.id == id }
      end

      def decrease_quantity(product_id, quantity)
        product = find_product_by_id(product_id)
        if product && product.quantity >= quantity
          product.quantity -= quantity
          true
        else
          false
        end
      end
    end
  end
end