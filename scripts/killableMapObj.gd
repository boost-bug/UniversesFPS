extends StaticBody

var health = 3

func _process(delta):
	if (health <= 0):
		self.queue_free()
