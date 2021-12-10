extends Position3D

onready var spawns = self.get_parent().get_node("Spawns")
onready var spawnsList = [spawns.get_node("Spawn1"), spawns.get_node("Spawn2"), spawns.get_node("Spawn3")]
onready var moveTimer = $MoveTimer

func _ready():
	
	moveTimer.start(14)

func _MoveSpawn():
	moveTimer.start(3)
	randomize()
	var randomChoice = spawnsList[randi() % spawnsList.size()]
	self.translation = randomChoice.translation
