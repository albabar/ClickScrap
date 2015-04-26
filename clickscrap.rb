require './clickbd'
require 'pp'

c = ClickBD.new
items = c.items

pp items[rand(items.length)]
