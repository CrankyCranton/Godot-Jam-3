class_name Target extends StaticBody2D


signal destroyed

static var targets_left := 0

var is_destroyed := false

@onready var sprite: Sprite2D = $Sprite
@onready var light: PointLight2D = $Light
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	targets_left += 1
	print(targets_left)


func explode() -> void:
	if not is_destroyed:
		is_destroyed = true
		animation_player.play(&"destroy")
		destroyed.emit()
