require 'json'

module DiskShop
  
  class Error < StandardError; end
  class ValidationError < Error; end
  class AuthenticationError < Error; end
  class InsufficientQuantityError < Error; end
end

require_relative 'disk_shop/models/user'
require_relative 'disk_shop/models/product'
require_relative 'disk_shop/models/cart'

require_relative 'disk_shop/models/admin'
require_relative 'disk_shop/models/customer'
require_relative 'disk_shop/models/film'
require_relative 'disk_shop/models/book'

require_relative 'disk_shop/services/store'
require_relative 'disk_shop/services/shop_manager'
require_relative 'disk_shop/services/console_interface'