extends Node2D

@export var fuel = 0
@export var greenery = 0
@export var wet = 0
@export var type = 0
@export var status = 0 
@export var burnRate = 0

var wetMax = 0
var burnMax = 0

var maxLvl =[0, 5, 15, 30]
var burnMaxLvl = [0, 1, 3, 5]

enum TILE_TYPES {DIRT, GRASS, BUSH, TRESS}
enum TILE_STATUS { GREEN, BURNING, BURNED, WET}

func construct(setType):
	type     = setType
	status   = 1
	wet      = maxLvl[setType]
	wetMax   = maxLvl[setType]
	greenery = maxLvl[setType]
	fuel     = maxLvl[setType]
	burnMax  = burnMaxLvl[setType]

func burn():
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


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
