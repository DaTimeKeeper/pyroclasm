extends Node2D


@export var fuel = 0
@export var greenery = 0
@export var wet = 0
@export var type = 0
@export var status = 0 
@export var burnRate = 0
@export var spot : Vector2i

signal OnFire

enum TILE_TYPES {DIRT, GRASS, BUSH, TRESS}
enum TILE_STATUS { GREEN, BURNING, BURNED, WET}


var wetMax = 0
var burnMax = 0

var maxLvl =[0, 5, 15, 30]
var burnMaxLvl = [0, 1, 3, 5]


func _init(setType):
	type     = setType
	status   = 1
	wet      = maxLvl[setType]
	wetMax   = maxLvl[setType]
	greenery = maxLvl[setType]
	fuel     = maxLvl[setType]
	burnMax  = burnMaxLvl[setType]
	spot     = Vector2(self.position)
	

func burn():
	onFire.emit()
	if(isWet()):
		return
	match status:
		0:
			greenery -= burnRate
		1:
			fuel -= burnRate
		2:
			burnRate = 0
	
	changeStatus()
	
	
func water():
	if(isBurning()):
		burnRate -= 1
	elif(wet < wetMax):
		wet += 1
	
	changeStatus()

func heatUp(amount):
	
	if(isWet()):
		wet -= amount
	elif(!isBurnedOut() && burnRate != burnMax):
		burnRate += amount
		
	changeStatus()

func isBurning():
	if(burnRate < 0 && fuel > 0):
		return true
	else:
		return false

func isWet():
	if(wet < 0):
		return true
	else:
		return false

func isGreen():
	if(greenery < 0):
		return true
	else:
		return false

func isBurnedOut():
	if(fuel <= 0):
		return true
	else:
		return false

func changeStatus():
	if(isWet()):
		status = 3
	elif(isGreen()):
		status = 0
	elif(isBurning()):
		status = 1
	elif(isBurnedOut()):
		status = 2
		burnRate = 0

func findNeigbor():
	
	var tile = 0
	
		
func getNeigbors():

	pass


		
func _process(delta):
	if (Input.is_action_pressed("TestFrie")):
		findNeigbor()
		#set_cell(0, spot, get_cell_source_id(0, spot), Vector2i(0, 0))

