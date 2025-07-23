module DiskShop
  module Models
    class Admin < User
      def add_item_to_store(store, product)
        store.add_product(product)
        puts "Товар '#{product.title}' добавлен в магазин"
      end
    end
  end
end