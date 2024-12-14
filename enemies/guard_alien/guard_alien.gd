class_name Guard extends CharacterBody2D



func _die():
	call_deferred("queue_free")
