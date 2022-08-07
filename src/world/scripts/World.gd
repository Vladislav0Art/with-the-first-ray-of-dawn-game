extends Node2D


# consts
const BigTreesCount = 30
const SmallTreesCount = 30
const MediumTreesCount = 30

const BushesCount = 200

const BigRocksCount = 10
const SmallRocksCount = 30


const MinX : float = -1500.0
const MaxX : float = 1500.0

const MinY : float = -1500.0
const MaxY : float = 1500.0

const SpiritSpawnTimeInverval_s : int   = 1
const SpiritSpawnProbability    : float = 0.2 
const MinSpiritDistFromPlayer   : float = 20.0
const MaxSpiritDistFromPlayer   : float = 30.0

# nodes
onready var ObjectsParent = $YSort/GeneratedObjects
onready var ForestSpiritParent = $YSort

onready var BigTreeScene    = preload("res://src/environment/trees/BigTree.tscn")
onready var MediumTreeScene = preload("res://src/environment/trees/MediumTree.tscn")
onready var SmallTreeScene  = preload("res://src/environment/trees/SmallTree.tscn")

onready var BushScene = preload("res://src/environment/bushes/Bush.tscn")

onready var BigRockScene = preload("res://src/environment/rocks/BigRock.tscn")
onready var SmallRockScene = preload("res://src/environment/rocks/SmallRock.tscn")

# forest spirit
onready var ForestSripit = preload("res://src/forest-spirit/ForestSpirit.tscn")
onready var Player = $YSort/Player
onready var Flashlight = $YSort/Player/Flashlight

# members
var spiritSpawnElapsedTime_s : float = 0.0 
var spiritSpawned            : bool  = false
var spiritIntance                    = null
var queuedSpiritRemove       : bool = false


func _process(delta : float):
	if (Flashlight.isTurnedOn):
		spiritSpawnElapsedTime_s += delta
	else:
		spiritSpawnElapsedTime_s = 0.0
		if (is_instance_valid(spiritIntance) and !spiritIntance.is_queued_for_deletion()):
			spiritIntance.queue_free()
			spiritIntance = null

		spiritSpawned = false

	#print(spiritSpawnElapsedTime_s)

	if (spiritSpawnElapsedTime_s >= SpiritSpawnTimeInverval_s && !spiritSpawned):
		spiritSpawned = trySpawnForestSpirit()




func _ready():
	randomize()
	
	var objects = [
		createDict(BushScene, BushesCount),
		createDict(BigTreeScene, BigTreesCount),
		createDict(MediumTreeScene, MediumTreesCount),
		createDict(SmallTreeScene, SmallTreesCount),
		createDict(BigRockScene, BigRocksCount),
		createDict(SmallRockScene, SmallRocksCount)
	]
	
	for pair in objects:
		var scene = pair["scene"]
		var count = pair["count"]
		
		for _i in range(count):
			spawnObject(scene)

func spawnObject(scene) -> void:
	var instance = scene.instance()
	
	var randX = rand_range(MinX, MaxX)
	var randY = rand_range(MinY, MaxY)
	instance.global_position = Vector2(randX, randY)
	
	ObjectsParent.add_child(instance)


func createDict(scene, count):
	return {
		"scene": scene,
		"count": count
	}



func trySpawnForestSpirit() -> bool:
	if (not needToSpawnSpirit()):
		return false

	var x = Player.get_position().x
	var y = Player.get_position().y

	randomize()
	
	spiritIntance = ForestSripit.instance()

	var spiritX = rand_range(x + MinSpiritDistFromPlayer, x + MaxSpiritDistFromPlayer)
	var spiritY = rand_range(y + MinSpiritDistFromPlayer, y + MaxSpiritDistFromPlayer)
	
	spiritIntance.set_position(Vector2(spiritX, spiritY))
	
	ForestSpiritParent.add_child(spiritIntance)
	
	return true


func needToSpawnSpirit() -> bool:
	randomize()
	var value = rand_range(0, 1)
	print(value)
	return value <= SpiritSpawnProbability
