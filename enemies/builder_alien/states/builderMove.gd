extends state_machine
class_name builderMove

@export var enemy_parent:CharacterBody2D
@export var navigation:NavigationAgent2D
var navigation_region:NavigationRegion2D

@export var speed:int

var target:Vector2

func Enter():
	navigation_region = get_tree().get_first_node_in_group("navigation")
	get_point()

func physics_update(_delta:float):
	var direction = Vector2()

	navigation.target_position = target
	direction = enemy_parent.global_position.direction_to(navigation.get_next_path_position())
	direction = direction.normalized()

	#enemy_parent.velocity = Vector2.ZERO
	enemy_parent.velocity = direction * speed

	if enemy_parent.global_position.distance_to(target) < 3:
		get_point()

	enemy_parent.move_and_slide()

func get_point():
	var random_point = NavigationServer2D.region_get_random_point(navigation_region.get_rid(),1,false)

	target = random_point
	#target.x = randf_range(-random_point.x,random_point.x)
	#target.y = randf_range(-random_point.y,random_point.y)
