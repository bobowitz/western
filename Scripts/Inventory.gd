extends Node

var items = [] # array of item counts. items[ID] = count

func add_item(item):
	items[item.ID] += 1
	print(str(item.ID) + ": " + str(items[item.ID]))

func _ready():
	items = []
	for i in range(ItemConstants.ITEMS):
		items.push_back(0)