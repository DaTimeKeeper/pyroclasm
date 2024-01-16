extends Area2D

var pos = self.position

var searchpatter = [Vector2(-16 , 16), Vector2(-16 , 32), Vector2(16 , 32), Vector2(32 , 32), Vector2(32 , 16),  Vector2(32 , - 16), Vector2(16 , - 16), Vector2(-16 , -16),]


func search():
	
	for x in range(searchpatter.size()):
		self.position = searchpatter[x]
		print(self.position)

func _on_tile_object_on_fire():
	search()
	print("reciving")
