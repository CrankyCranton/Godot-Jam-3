extends state_machine
class_name builderMove

@export var enemy_parent:CharacterBody2D
@export var navigation:NavigationAgent2D
var navigation_region

@export var speed:int

var target:Vector2

func Enter():
	navigation_region = Global.floor_tiles.get_navigation_map()
	print(navigation_region)
	get_point()

func physics_update(_delta:float):
	var direction = Vector2()

	navigation.target_position = target
	direction = navigation.get_next_path_position() - enemy_parent.global_position
	direction = direction.normalized()

	enemy_parent.velocity = Vector2.ZERO
	enemy_parent.velocity = direction * speed

	if target.x - enemy_parent.global_position.x < 3:
		get_point()
	if target.y - enemy_parent.global_position.y < 3:
		get_point()

	enemy_parent.move_and_slide()

func get_point():
	print(NavigationServer2D)
	var random_point = NavigationServer2D.region_get_random_point(navigation_region,1,false)

	target.x = randf_range(-random_point.x,random_point.x)
	target.y = randf_range(-random_point.y,random_point.y)
