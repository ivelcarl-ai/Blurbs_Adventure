extends Node2D

@onready var camera: Camera2D = $Camera2D

var transitioning: bool = false
var transition_type = Tween.TRANS_QUINT
var transition_ease = Tween.EASE_IN_OUT

var tween: Tween

signal finished

func transition_camera(to: Camera2D, from: Camera2D, duration: float) -> void:
	if transitioning:
		return
	
	# Copy the parameters of the first camera
	camera.zoom = from.zoom
	camera.offset = from.offset
	camera.light_mask = from.light_mask
	
	# Move our transition camera to the first camera position
	camera.global_transform = from.global_transform
	
	# Make our transition camera current
	camera.enabled = true
	camera.make_current()
	from.enabled = false
	
	transitioning = true
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(transition_ease)
	tween.set_trans(transition_type)
	tween.tween_property(camera, "global_transform", to.global_transform, duration).from(camera.global_transform)
	tween.tween_property(camera, "zoom", to.zoom, duration).from(camera.zoom)
	
	await tween.finished
	
	tween.kill()
	
	if to == null:
		return
	
	to.enabled = true
	to.reset_smoothing()
	camera.enabled = false
	transitioning = false
	
	finished.emit()
