extends Node3D

var mouseMovementY
var mouseMovementX
var swayThreshold = 2
var swayLerp = 5

@export var swayLeft : Vector3
@export var swayRight : Vector3
@export var swayUp : Vector3
@export var swayDown : Vector3
@export var swayNormal : Vector3

func _input(event):
	if event is InputEventMouseMotion:
		mouseMovementY = -event.relative.x
		mouseMovementX = event.relative.y
		
func _process(delta):
	if mouseMovementY != null:
		if mouseMovementY > swayThreshold:
			rotation = rotation.lerp(swayLeft, swayLerp * delta)
		elif mouseMovementY < -swayThreshold:
			rotation = rotation.lerp(swayRight, swayLerp * delta)
		if mouseMovementX > swayThreshold:
			rotation = rotation.lerp(swayUp, swayLerp * delta)
		elif mouseMovementX < -swayThreshold:
			rotation = rotation.lerp(swayDown, swayLerp * delta)
		else:
			rotation = rotation.lerp(swayNormal, swayLerp * delta)
