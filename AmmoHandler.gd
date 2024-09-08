extends Node
class_name AmmoHandler

enum ammo_type {
	RIFLE_BULLET,
	SMG_BULLET
}

var ammo_storage :={
	ammo_type.RIFLE_BULLET: 10,
	ammo_type.SMG_BULLET: 60
}

func has_ammo(type: ammo_type) -> bool:
	return ammo_storage[type] > 0 

func use_ammo(type: ammo_type) -> void:
	if (has_ammo(type)):
		ammo_storage[type] -= 1
		print(ammo_storage[type])
