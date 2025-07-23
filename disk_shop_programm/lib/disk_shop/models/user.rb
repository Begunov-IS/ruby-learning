module DiskShop
  module Models
    class User
      attr_accessor :id, :name, :login, :password

      def initialize(id, name, login, password)
        @id = id
        @name = name
        @login = login
        @password = password
      end

      def authenticate(login, password)
        @login == login && @password == password
      end
    end
  end
end