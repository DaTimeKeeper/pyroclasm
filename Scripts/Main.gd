extends Node2D

@onready var pause_menu = $"Pause"
@onready var end = $"EndRound"
@onready var scoreboard = $"EndRound/VBoxContainer/FinalScoreTotalLable"

var gameOver = false
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.time_scale = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") && !gameOver:
		setPause()
	if Input.is_action_just_pressed("wind_north"):
		$"PlayerCamera2/wind/Arrow".rotation_degrees = 0
		$"PlayerCamera2/wind/WindText".text = "N"
		$"TileGameMap".windDir = Vector2i(-1,-1)
	if Input.is_action_just_pressed("wind_west"):
		$"PlayerCamera2/wind/Arrow".rotation_degrees = 90
		$"PlayerCamera2/wind/WindText".text = "W"
		$"TileGameMap".windDir = Vector2i(1,-1)
	if Input.is_action_just_pressed("wind_south"):
		$"PlayerCamera2/wind/Arrow".rotation_degrees = 180
		$"PlayerCamera2/wind/WindText".text = "S"
		$"TileGameMap".windDir = Vector2i(1, 1)
	if Input.is_action_just_pressed("wind_east"):
		$"PlayerCamera2/wind/Arrow".rotation_degrees = -90
		$"PlayerCamera2/wind/WindText".text = "E"
		$"TileGameMap".windDir = Vector2i(-1,1)



func setPause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0

	paused = !paused


func _on_tile_game_map_all_fire_out(finalScore):
	gameOver = true
	scoreboard.text = str(finalScore)
	end.show()
	Engine.time_scale = 0
