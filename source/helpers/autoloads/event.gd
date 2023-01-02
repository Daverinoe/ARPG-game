extends Node

signal reload_main_menu # For forcing the main menu to check whether save games exist or not
# to display correct button schema


# Inventory signals
signal drop_loot(monster_level, position)
signal inventory_slot_hover(inventory_slot_ref)
signal picked_up_item(item_ref)
signal inventory_inactive(null_ref)
