extends Node
class_name Item

enum ITEM_TYPE {
	MELEE,
	RANGED,
	MAGIC,
	SHIELD,
	CHEST,
	LEGS,
	HANDS,
	FEET,
	BELT,
	HEAD,
	POTION,
	GOLD,
}

enum ITEM_SIZE {
	SMALL,
	MEDIUM,
	LARGE,
}

enum RARITY {
	NORMAL,
	MAGIC,
	UNIQUE,
}

const common_modulate : Color = Color(0.5, 0.5, 0.5, 0.5)
const magic_modulate : Color = Color(0.3, 0.3, 0.7, 0.5)
const unique_modulate : Color = Color(1, 0.843, 0.0, 0.5)
