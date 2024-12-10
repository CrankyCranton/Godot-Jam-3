extends state_machine
class_name guardIdle


func _on_detect_area_body_entered(body: Node2D) -> void:
	Transitioned.emit(self,"guardAlert")
	print("habibi")
