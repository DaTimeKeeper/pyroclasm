extends Node2D

@onready var tilemap: TileMap = $".."
@onready var tileset: TileSet = tilemap.tile_set

const MAP_SIZE = Vector2(500, 500)

func _ready():
	generate_world()
	
func generate_world():
	var rng = RandomNumberGenerator.new()
	var x = -30
	
	for i in range(0, 12):
		var y = -30
		for j in range(0, 12):
			var rngNumb = rng.randf_range(0, 19)
			tilemap.set_pattern(0, Vector2i(x, y), tileset.get_pattern(rngNumb))
			y += 5
		x += 5
