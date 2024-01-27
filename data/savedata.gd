class_name SaveData extends Resource

@export var high_score :int=0
const SAVE_PATH:String =  "user://highscore.tres"
# Called when the node enters the scene tree for the first time.
func save() -> void:
	ResourceSaver.save(self,SAVE_PATH)

static func load_or_create() -> SaveData:
	var res:SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res
