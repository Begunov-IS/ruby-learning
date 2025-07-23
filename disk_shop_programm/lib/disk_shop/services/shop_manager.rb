module DiskShop
  module Services
    class ShopManager
      attr_accessor :id, :shop_name, :admins, :customers, :carts, :store

      def initialize(id, shop_name, admins, customers, carts, store)
        @id = id
        @shop_name = shop_name
        @admins = admins
        @customers = customers
        @carts = carts
        @store = store
      end

      def find_by_id(current_admin, ary_to_find, wanted_id)
        admin_validation(current_admin)
        ary_to_find.find { |item| item[:id] == wanted_id }
      end

      def add_user(current_admin, id, name, login, password, admin = 0)
        admin_validation(current_admin)
        user_validation(id, name, login, password)
        
        if admin == 1
          new_admin = Models::Admin.new(id, name, login, password)
          admins << new_admin
        elsif admin == 0
          new_customer = Models::Customer.new(id, name, login, password)
          customers << new_customer
        end
      end

      def remove_user(current_admin, user_id)
        admin_validation(current_admin)
        @customers = @customers.reject { |user| user[:id] == user_id }
      end

      def admin_validation(admin_id)
        found_admin = @admins.find { |admin| admin[:id] == admin_id }
        raise AuthenticationError, "Ошибка! Доступ запрещен!" if found_admin.nil?
      end

      def user_validation(id, name, login, password)
        raise ValidationError, "ID должен быть положительным числом" if id <= 0
        raise ValidationError, "Имя не может быть пустым" if name.nil? || name.empty?
        raise ValidationError, "Логин не может быть пустым" if login.nil? || login.empty?
        raise ValidationError, "Пароль должен быть не менее 6 символов" if password.nil? || password.length < 6
      end
    end
  end
end