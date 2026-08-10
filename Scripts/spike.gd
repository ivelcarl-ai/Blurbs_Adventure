extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_meta("Role") != "Player": return
	
	body.respawn()
