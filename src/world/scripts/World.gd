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


# nodes
onready var parent = $YSort/GeneratedObjects

onready var BigTreeScene    = preload("res://src/environment/trees/BigTree.tscn")
onready var MediumTreeScene = preload("res://src/environment/trees/MediumTree.tscn")
onready var SmallTreeScene  = preload("res://src/environment/trees/SmallTree.tscn")

onready var BushScene = preload("res://src/environment/bushes/Bush.tscn")

onready var BigRockScene = preload("res://src/environment/rocks/BigRock.tscn")
onready var SmallRockScene = preload("res://src/environment/rocks/SmallRock.tscn")


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
		
		print(scene, " ", count)
		
		for _i in range(count):
			spawnObject(scene)

func spawnObject(scene) -> void:
	var instance = scene.instance()
	
	var randX = rand_range(MinX, MaxX)
	var randY = rand_range(MinY, MaxY)
	instance.global_position = Vector2(randX, randY)
	
	parent.add_child(instance)


func createDict(scene, count):
	return {
		"scene": scene,
		"count": count
	}
