extends Control

signal order_selected(order: Order)

@onready var cards_container: HBoxContainer = %CardsContainer

const ORDER_CARD = preload("uid://ddppw4m4cqbc8")
const OrderCard = preload("uid://bvv5fkcgk0k53")

func setup(orders: Array[Order]):
	for idx in orders.size():
		var child: OrderCard
		if cards_container.get_child_count() > idx:
			child = cards_container.get_child(idx)
		else:
			child = ORDER_CARD.instantiate()
			cards_container.add_child(child)
		child.setup(orders[idx])
		child.clicked.connect(on_order_selected)

	if cards_container.get_child_count() > orders.size():
		for idx in range(orders.size(), cards_container.get_child_count()):
			cards_container.get_child(idx).queue_free()


func on_order_selected(order: Order):
	order_selected.emit(order)
