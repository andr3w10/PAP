extends Control


func _on_mouse_entered():
	AudioPlayer.play_menu_hover()


func _on_pressed():
	AudioPlayer.play_menu_click()


func _on_get_items_pressed():
	var _value = HttpConnection.connect("items_getted", self, "_items_getted")
	_value = HttpConnection.connect("coins_getted", self, "_on_coins_getted")
	HttpConnection._get_items(Globals.account_username)
	HttpConnection._get_coins()

func _items_getted(items):
	HttpConnection.disconnect("items_getted", self, "_items_getted")
	get_parent().close_menu()
	for item in items:
		PlayerInventory.add_item(item, 1)

func _on_coins_getted(coins):
	PlayerInventory.coins = coins
	HttpConnection.disconnect("coins_getted", self, "_on_coins_getted")
