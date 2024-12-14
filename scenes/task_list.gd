extends VBoxContainer


func _ready() -> void:
	for target: Target in get_tree().get_nodes_in_group(&"targets"):
		var label := Label.new()
		label.text = "Destroy " + target.name
		target.destroyed.connect(label.queue_free)
		add_child(label)


func remove_task(task:int):
	get_child(task).queue_free()
