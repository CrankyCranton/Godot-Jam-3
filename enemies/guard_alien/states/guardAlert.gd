extends state_machine
class_name guardAlert

@export var navigation:NavigationAgent2D
@export var enemy_parent:CharacterBody2D


@export var spd:int

var target:CharacterBody2D

func Enter():
	target = get_tree().get_first_node_in_group("player")

func physics_update(_delta:float):
	if target:
		_move_to_taget(_delta)
	enemy_parent.move_and_slide()

func _move_to_taget(_delta):
	var direction = Vector2()

	navigation.target_position = target.global_position
	direction = navigation.get_next_path_position() - enemy_parent.global_position
	direction = direction.normalized()

	enemy_parent.velocity = Vector2.ZERO
	enemy_parent.velocity = direction * spd

func _on_shooting_range_body_entered(body: Node2D) -> void:
	Transitioned.emit(self,"guardShoot")

func _on_detect_area_body_exited(body: Node2D) -> void:
	Transitioned.emit(self,"guardIdle")
