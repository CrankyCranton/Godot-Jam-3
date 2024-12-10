extends state_machine
class_name builderAvoid

@export var enemy_parent:CharacterBody2D
@export var timer:Timer

@export var spd:int

var player:CharacterBody2D

func Enter():
	timer.start()
	player = get_tree().get_first_node_in_group("player")

func physics_update(_delta:float):
	var distance = player.global_position - enemy_parent.global_position

	var direction = -distance.normalized()
	enemy_parent.velocity = direction * spd
	enemy_parent.move_and_slide()

func _on_player_detector_body_exited(body: Node2D) -> void:
	Transitioned.emit(self,"builderIdle")

func _on_avoid_timer_timeout() -> void:
	Transitioned.emit(self,"builderMove")
