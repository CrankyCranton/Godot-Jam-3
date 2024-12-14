extends RayCast2D

var player:CharacterBody2D
@onready var suck_in:AudioStreamPlayer2D = $suck
@onready var whoosh:AudioStreamPlayer2D = $whoosh

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	look_at(player.global_position)

	if is_colliding():
		var target = get_collider()
		if target.is_in_group("player"):
			whoosh.play()
			player.velocity = (global_position - player.global_position) * 5


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_process(false)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_process(true)
