extends TileMap

@onready var tileMap: TileMap = $"."

signal setScorce(points: int)
signal allFireOut(finalScore: int)

const north:     Vector2i = Vector2i(-1,-1)
const northWest: Vector2i = Vector2i(0,-1)
const west:      Vector2i = Vector2i(1,-1)
const southWest: Vector2i = Vector2i(1,0)
const south:     Vector2i = Vector2i(1,1)
const southEast: Vector2i = Vector2i(0,1)
const east:      Vector2i = Vector2i(-1,1)
const northEast: Vector2i = Vector2i(-1,0)
const dir:       Array[Vector2i] = [north,south,west,east,southWest,southEast,northWest,northEast]

var windDir: Vector2i = north

var startingFireTile = Vector2i(0,0)
var tilesOnFire      = [startingFireTile]
var score = 0


func _on_update_fire_timer_timeout():
	var futureTilesOnFire = []
	var tilesToErase = []

	if tilesOnFire.size() == 0: #Check End state
		allFireOut.emit(score)

	for t in tilesOnFire:
		var currentTile: TileData = tileMap.get_cell_tile_data(0, t)

		if !currentTile:
			continue

		var neighbors: Array[Vector2i] = getTileInWind(t)
		var isFirst: bool = true

		for n in neighbors:
			var neighborTile: TileData = tileMap.get_cell_tile_data(0, n)

			if !neighborTile || !neighborTile.get_custom_data("burnable") ||checkOnFire(n):
				continue
			if isFirst == true:
				doDamage(n)
				isFirst = false
			doDamage(n)
			if checkOnFire(n):
				futureTilesOnFire.append(n)


		doDamage(t)
		if checkOnFire(t) && tileMap.get_cell_tile_data(0, t).get_custom_data("status") == 2:
			tilesToErase.append(t)


	tilesOnFire = tilesOnFire + futureTilesOnFire
	for e in tilesToErase:
		tilesOnFire.erase(e)
		tileMap.erase_cell(1,e)
		score += 1

	setScorce.emit(score)

func doDamage(tilePos: Vector2i):
	var tile: TileData = tileMap.get_cell_tile_data(0, tilePos)
	var nextHealth =  tile.get_custom_data("health") - 1
	var type   = tile.get_custom_data("type")
	var status = tile.get_custom_data("status")

	#TDOD: add water overshield check
	# If waterShield >0 damage that then continue else run below

	if nextHealth >= 0 && status < 2:
		if (nextHealth <= 0):
			tileMap.set_cell(0, tilePos, 0, Vector2i(status+1, type))
			if (status + 1 == 1 || status == 1) && !checkOnFire(tilePos):
				setOnfire(tilePos)
		else:
			tileMap.set_cell(0, tilePos, 0, Vector2i(status, type), nextHealth)
			if status == 1 && !checkOnFire(tilePos):
				setOnfire(tilePos)


func checkOnFire(tilePos: Vector2i):

	if(tileMap.get_cell_tile_data(1, tilePos)):
		return true
	else:
		return false

func setOnfire(tilePos: Vector2i):

	tileMap.set_cell(1, tilePos, 1, Vector2i(0, 0))

func getAllAround(tilePos: Vector2i):
	var listTiles: Array[Vector2i] = []

	for i in dir:
		listTiles.append(tilePos + i)

	return listTiles

#north,south,west,east,southWest,southEast,northWest,northEast
func getTileInWind(tilePos: Vector2i):
	var dirList: Array[Vector2i] = []
	var listTiles: Array[Vector2i] = []

	if windDir == north:
		dirList = [north, northWest, northEast]
	if windDir == south:
		dirList = [south, southWest, southEast]
	if windDir == west:
		dirList = [west, southWest,  northWest]
	if windDir == east:
		dirList = [east, southEast, northEast]
	if windDir == southWest:
		dirList = [southWest, west, south]
	if windDir == southEast:
		dirList = [southEast, east, south]
	if windDir == northWest:
		dirList = [northWest, west, north]
	if windDir == northEast:
		dirList = [northEast, east, north]

	for x in dirList:
		listTiles.append( x + tilePos)

	return listTiles




