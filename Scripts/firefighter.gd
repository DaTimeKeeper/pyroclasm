extends CharacterBody2D


const SPEED = 600
var target = position

var tileTarget: Vector2i

@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var tileMap := $"../TileGameMap"

func _physics_process(delta: float):
	velocity = position.direction_to(target) * SPEED
	# look_at(target)
	if position.distance_to(target) > 20:
		move_and_slide()


func makePath():
	var playerPosition = global_position
	var nearestFire=tileMap.getNearestFire(playerPosition)
	target=nearestFire


func _on_tile_game_map_fire_updated():
	makePath()
