extends Area



func _on_Area_area_entered(area):
	
	var spawnPos = get_tree().get_root().get_node('Spatial/Dynamic/Spawn').translation
	
	if (area.is_in_group('KillZone')):
		self.get_parent().translation = spawnPos
