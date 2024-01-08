extends Resource

class_name list_saving

@export var magic_resources:Array[magic_card]
@export var tower_resources:Array[card_resource]

var resources_dic:Dictionary = {}

@export var owned_magic:Array[magic_card] = []
@export var owned_tower:Array[card_resource] = []


@export var moneys:=0
@export var check_index:int = 0


func collect_moneys(amount:int)->bool:
	if moneys + amount < 0:
		return false
	
	moneys += amount
	ResourceSaver.save(self)
	return true


func update_check_index(index:int):
	check_index = index
	ResourceSaver.save(self)


func update_dic() -> void:
	for magic in magic_resources:
		resources_dic[magic.name] = magic
	for tower in tower_resources:
		resources_dic[tower.name] = tower


func add(name:String)->void:
	update_dic()
	var new = resources_dic.get(name,null)
	
	if new == null:
		return
	
	if new is magic_card:
		if owned_magic.has(new):
			return
		owned_magic.append(new)
	else:
		if owned_tower.has(new):
			return
		owned_tower.append(new)
	ResourceSaver.save(self)


func reset()->void:
	owned_magic.clear()
	owned_tower.clear()
	moneys = 0
	check_index = 0
	ResourceSaver.save(self)
