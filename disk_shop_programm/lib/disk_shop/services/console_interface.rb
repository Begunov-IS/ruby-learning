module DiskShop
  module Services
    class ConsoleInterface
      def initialize(store)
        @store = store
        @current_user = nil
        @users = {
          'admin' => Models::Admin.new(1, 'Администратор Иван', 'admin', 'admin123'),
          'user' => Models::Customer.new(2, 'Покупатель Иван', 'user', 'user123')
        }
      end

      def start
        puts "Добро пожаловать в магази дисков!"
        login
        main_menu
      end

      def login
        loop do
          puts "\nВход в систему:"
          print "Логин: "
          login = gets.chomp
          print "Пароль: "
          password = gets.chomp

          user = @users.values.find { |users| users.login == login && users.password == password }
          
          if user
            @current_user = user
            puts "\nДобро пожаловать, #{user.name}!"
            break
          else
            puts "Неверный логин или пароль. Попробуйте еще раз."
          end
        end
      end

      def main_menu
        loop do
          puts "\n=== Главное меню ==="
          puts "1. Просмотр товаров"
          
          if @current_user.is_a?(Models::Customer)
            puts "2. Добавить товар в корзину"
            puts "3. Просмотреть корзину"
            puts "4. Получить итоговую сумму заказа"
            puts "5. Очистить корзину"
          elsif @current_user.is_a?(Models::Admin)
            puts "2. Административные функции"
          end
          
          puts "0. Выйти"
          
          print "\nВведите номер действия: "
          choice = gets.chomp.to_i

          case choice
          when 1
            @store.display_items
          when 2
            if @current_user.is_a?(Models::Customer)
              add_to_cart_menu
            elsif @current_user.is_a?(Models::Admin)
              admin_menu
            end
          when 3
            @current_user.view_cart if @current_user.is_a?(Models::Customer)
          when 4
            if @current_user.is_a?(Models::Customer)
              sum = @current_user.get_total_sum
              puts "\nИтоговая сумма заказа: #{sum} руб."
            end
          when 5
            @current_user.clear_cart if @current_user.is_a?(Models::Customer)
          when 0
            save_and_exit
            break
          else
            puts "Неверный выбор. Попробуйте еще раз."
          end
        end
      end

      def add_to_cart_menu
        @store.display_items
        
        print "\nВведите номер товара: "
        product_id = gets.chomp.to_i
        
        product = @store.find_product_by_id(product_id)
        if product
          print "Введите количество: "
          quantity = gets.chomp.to_i
          
          if quantity > 0
            @current_user.add_to_cart(product, quantity, @store)
          else
            puts "Количество должно быть больше 0"
          end
        else
          puts "Товар не найден"
        end
      end

      def admin_menu
        loop do
          puts "\n=== Административные функции ==="
          puts "1. Добавить новый товар"
          puts "2. Вернуться назад"
          
          print "\nВведите номер действия: "
          choice = gets.chomp.to_i

          case choice
          when 1
            add_new_product
          when 2
            break
          else
            puts "Неверный выбор"
          end
        end
      end

      def add_new_product
        puts "\nДобавление нового товара"
        print "Тип товара (film/book): "
        type = gets.chomp.downcase

        print "Название: "
        title = gets.chomp

        if type == 'film'
          print "Год выпуска: "
          year = gets.chomp.to_i
          print "Режиссер: "
          director = gets.chomp
        elsif type == 'book'
          print "Автор: "
          author = gets.chomp
        else
          puts "Неверный тип товара"
          return
        end

        print "Цена: "
        price = gets.chomp.to_i
        print "Количество: "
        quantity = gets.chomp.to_i

        new_id = @store.products.size + 1

        product = if type == 'film'
          Models::Film.new(new_id, title, year, director, price, quantity)
        else
          Models::Book.new(new_id, title, author, price, quantity)
        end

        @current_user.add_item_to_store(@store, product)
        @store.save_items_to_json('products.json')
      end

      def save_and_exit
        @store.save_items_to_json('products.json')
        puts "\nСессия завершена, данные сохранены!"
      end
    end
  end
end