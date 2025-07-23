#!/usr/bin/env ruby

require_relative 'lib/disk_shop'

store = DiskShop::Services::Store.new(1, "Магазин дисков")
store.load_items_from_json('products.json')

interface = DiskShop::Services::ConsoleInterface.new(store)
interface.start