extends Node2D

enum TILE_TYPES {DIRT, GRASS, BUSH, TRESS}
enum TILE_STATUS {GREEN, BURNING, BURNED, WET}

signal onFire()

func spreadFire():
	onFire.emit()
	print("spreading")

func _process(delta):
	if(Input.is_action_just_released("spread")):
		spreadFire()
 