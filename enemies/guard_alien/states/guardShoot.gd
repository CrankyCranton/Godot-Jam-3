extends state_machine
class_name guardShoot

@export var gun:Node2D
@export var timer:Timer

var player:CharacterBody2D

func Enter():
	timer.start()
	player = get_tree().get_first_node_in_group("player")

func physics_update(_delta:float):
	gun.look_at(player.global_position)

func _on_timer_timeout() -> void:
	gun.shoot(gun.global_rotation)
	timer.start()

func _on_shooting_range_body_exited(body: Node2D) -> void:
	timer.stop()
	Transitioned.emit(self,"guardAlert")
