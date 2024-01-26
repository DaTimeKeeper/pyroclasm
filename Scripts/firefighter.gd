extends CharacterBody2D


const SPEED = 100
var target = position
var targetTile =Vector2i(0,0)
var currentTile = Vector2i(0,0)


@onready var tileMap = $"../TileGameMap"
@onready var animation = $"fredArt"

func _process(delta):
	if velocity.is_zero_approx():
		animation.play("Idle")
	else:
		var angle=velocity.normalized().dot(Vector2.RIGHT)*90
		if angle < 45 &&  angle  > -45 && velocity.normalized().y>0:
			animation.play("Run_At_Camera")
		elif angle  > 45:
			animation.play("Run_Right")
		elif angle < 45 &&  angle  > -45 && velocity.normalized().y<0:
			animation.play("Run_Away")
		else:
			animation.play("Run_Left")


func _physics_process(delta: float):
	if !target:
		return
	velocity = position.direction_to(target).normalized() * SPEED
	currentTile=tileMap.local_to_map(global_position)
	$DebugLabel.set_text("Target: (%s,%s)\nCurrent: (%s,%s)\nVelocity: (%s, %s)\n" % [currentTile.x,currentTile.y,targetTile.x,targetTile.y,velocity.x,velocity.y])
	#look_at(target)
	if position.distance_to(target) > 20:
		move_and_slide()
	else:
		tileMap.eraseFire(targetTile)
		makePath()


func makePath():
	var playerPosition = global_position
	var nearestFire=tileMap.getNearestFire(playerPosition)
	target=nearestFire
	if target:
		targetTile=tileMap.local_to_map(target)




func _on_update_timer_timeout():
	makePath()
