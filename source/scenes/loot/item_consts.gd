extends Node
class_name Item

enum ITEM_TYPE {
	MELEE = 0,
	RANGED = 1,
	MAGIC = 2,
	SHIELD = 3,
	CHEST = 4,
	LEGS = 5,
	HANDS = 6,
	FEET = 7,
	BELT = 8,
	HEAD = 9,
	RING = 10,
	AMULET = 11,
	POTION = 12,
	GOLD = 13,
}

enum ITEM_SIZE {
	SMALL = 0,
	MEDIUM = 1,
	LARGE = 2,
}

enum RARITY {
	NORMAL = 0,
	MAGIC = 1,
	UNIQUE = 2,
}

const common_modulate : Color = Color(0.5, 0.5, 0.5, 0.5)
const magic_modulate : Color = Color(0.3, 0.3, 0.7, 0.5)
const unique_modulate : Color = Color(1, 0.843, 0.0, 0.5)

const PREFIXES : Dictionary = {
	# Fire resist
	"red": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "fire_res", 10, 20, 1.1, 4, false],
	"rose": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "fire_res", 10, 20, 1.1, 4, false],
	"crimson": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "fire_res", 10, 20, 1.1, 4, false],
	"garnet": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "fire_res", 10, 20, 1.1, 4, false],
	"ruby": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "fire_res", 10, 20, 1.1, 4, false],
}

const SUFFIXES : Dictionary = {
	# Modifying dexterity
	"paralysis": 	[[0, 1, 3, 4, 5, 6, 7, 8, 10, 11], "dex", -10, -6, 0.001, 3, true],
	"atrophy": 		[[0, 1, 3, 4, 5, 6, 7, 8, 10, 11], "dex", -5, -1, 0.001, 1, true],
	"dexterity": 	[[0, 1, 3, 4, 5, 6, 7, 8, 10, 11], "dex", 1, 5, 1.1, 1, true],
	"skill": 		[[0, 1, 3, 4, 5, 6, 7, 8, 10, 11], "dex", 6, 10, 1.2, 5, true],
	"accuracy":		[[0, 1, 3, 4, 5, 6, 7, 8, 10, 11], "dex", 11, 15, 1.3, 11, true],
	"precision": 	[[0, 1, 4, 5, 6, 7, 8, 10, 11], "dex", 16, 20, 1.4, 17, true],
	"perfection": 	[[1, 10, 11], "dex", 21, 30, 1.5, 23, true],
	# Modifying magic
	"the fool": 	[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "mag", -10, -6, 0.001, 3, true],
	"dyslexia": 	[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "mag", -5, -1, 0.001, 1, true],
	"magic": 		[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "mag", 1, 5, 1.1, 1, true],
	"the mind": 	[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "mag", 6, 10, 1.2, 5, true],
	"brilliance": 	[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "mag", 11, 15, 1.3, 11, true],
	"sorcery": 		[[0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11], "mag", 16, 20, 1.4, 17, true],
	"wizardry": 	[[2, 10, 11], "mag", 21, 30, 1.5, 23, true],
	# Modifying strength
	"frailty": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "str", -10, -6, 0.001, 3, true],
	"weakness": 	[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "str", -5, -1, 0.001, 1, true],
	"strength": 	[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "str", 1, 5, 1.1, 1, true],
	"might": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "str", 6, 10, 1.2, 5, true],
	"power": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "str", 11, 15, 1.3, 11, true],
	"giants": 		[[0, 1, 4, 5, 6, 7, 8, 9, 10, 11], "str", 16, 20, 1.4, 17, true],
	"titas": 		[[0, 10, 11], "str", 21, 30, 1.5, 23, true],
	# Modifying vitality
	"illness": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "vit", -10, -6, 0.001, 3, true],
	"disease": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "vit", -5, -1, 0.001, 1, true],
	"vitality": 	[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "vit", 1, 5, 1.1, 1, true],
	"zest": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "vit", 6, 10, 1.2, 5, true],
	"vim": 			[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "vit", 11, 15, 1.3, 11, true],
	"vigour": 		[[0, 1, 4, 5, 6, 7, 8, 9, 10, 11], "vit", 16, 20, 1.4, 17, true],
	"life": 		[[10, 11], "vit", 21, 30, 1.5, 23, true],
	# Modifying all attributes
	"trouble": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "all", -10, -6, 0.001, 12, true],
	"the pit": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "all", -5, -1, 0.001, 5, true],
	"the sky": 		[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "all", 1, 5, 1.1, 5, true],
	"the moon": 	[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "all", 6, 10, 1.2, 11, true],
	"the stars": 	[[0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11], "all", 11, 15, 1.3, 17, true],
	"the heavens": 	[[0, 1, 10, 11], "all", 16, 20, 1.4, 25, true],
	"the zodiac": 	[[10, 11], "all", 21, 30, 1.5, 30, true],
}
