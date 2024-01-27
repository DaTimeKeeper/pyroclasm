extends Node2D

const wind = {"north":     {"dir":Vector2i(-1,-1),"rota": 0,   "text":"N"  },
			  "northeast": {"dir":Vector2i(0,-1), "rota":45,   "text":"NE" },
			  "east":      {"dir":Vector2i(1,-1), "rota":90,   "text":"E"  },
			  "southeast": {"dir":Vector2i(1,0),  "rota":135,  "text":"SE" },
			  "south":     {"dir":Vector2i(1,1),  "rota":180,  "text":"S"  },
			  "southwest": {"dir":Vector2i(0,1),  "rota":-135, "text":"SW" },
			  "west":      {"dir":Vector2i(-1,1), "rota":-90,  "text":"W"  },
			  "northwest": {"dir":Vector2i(-1,0), "rota":-45,  "text":"NW" }}

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

	var newDir = ""

	if Input.is_action_just_pressed("pause") && !gameOver:
		setPause()

	if Input.is_action_pressed("wind_north") && !Input.is_action_pressed("wind_south"):
		newDir = "north"
	elif Input.is_action_pressed("wind_south")  && !Input.is_action_pressed("wind_north"):
		newDir = "south"

	if Input.is_action_pressed("wind_west")  && !Input.is_action_pressed("wind_east"):
		newDir += "west"
	elif Input.is_action_pressed("wind_east") && !Input.is_action_pressed("wind_west"):
		newDir += "east"

	if newDir != "":
			$"PlayerCamera2/wind/Arrow".rotation_degrees = wind[newDir].get("rota")
			$"PlayerCamera2/wind/WindText".text = wind[newDir].get("text")
			$"TileGameMap".windDir = wind[newDir].get("dir")


func setPause():
	if pause_menu.visible:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0



func _on_tile_game_map_all_fire_out(finalScore):
	gameOver = true
	scoreboard.text = str(finalScore)
	end.show()
	Engine.time_scale = 0


func spawn_fred():
	var new_mob=preload("res://Objects/firefighter.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_fred_spawner_timer_timeout():
	spawn_fred()
