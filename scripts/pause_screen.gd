class_name PauseScreen extends CanvasLayer

@export var guards:Node 

enum Mode {
	PAUSE,
	LOSE,
	WIN,
}

@export var time := 30:
	set(value):
		time = value
		if not is_node_ready():
			await ready
		timer.text = str(time)

var titles := {
	Mode.PAUSE: [
		"Game Paused",
		#"\"What, couldn't win without a pit stop?\"\n--President of Mars",
		],
	Mode.LOSE: [
		"Game Over",
		#"\"Oh my, did I step on an ant?\"\n--President of Martians",
		#"\"Hah! As expected, the earthling failed.\"\n--President of Mars",
	],
	Mode.WIN: [
		"You Win!",
		#"\"AHHHHHHHHHHHHHHHHHHHHHHHHHHHHH!!!\"\n--President of Mars",
	],
}

@onready var layout: Control = $Layout
@onready var title: Label = %Title
@onready var menu: VBoxContainer = %Menu
@onready var play_again_button: Button = %PlayAgainButton
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton
@onready var timer: Label = %Timer
@onready var tick: Timer = $Tick


func _ready() -> void:
	timer.text = str(time)
	for target: Target in get_tree().get_nodes_in_group(&"targets"):
		target.won.connect(_on_target_won)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		@warning_ignore("standalone_ternary")
		deactivate() if layout.visible else activate(Mode.PAUSE)


func activate(mode: Mode) -> void:
	guards.queue_free()
	get_tree().paused = true
	title.text = titles[mode].pick_random()
	match mode:
		Mode.PAUSE:
			resume_button.grab_focus()
		Mode.LOSE:
			#play_again_button.text = "Lose Again"
			#quit_button.text = "Rage Quit"
			resume_button.hide()
			play_again_button.text = "Play Again!"
			play_again_button.grab_focus()
		Mode.WIN:
			resume_button.hide()
			play_again_button.text = "Play Again!"
			play_again_button.grab_focus()
	layout.show()


func deactivate() -> void:
	for button: Button in menu.get_children():
		button.release_focus()
	layout.hide()
	get_tree().paused = false


func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/tile_stuff/level.tscn")


func _on_resume_button_pressed() -> void:
	deactivate()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_tick_timeout() -> void:
	time -= 1
	if time <= 0:
		tick.stop()
		activate(Mode.LOSE)


func _on_target_won() -> void:
	activate(Mode.WIN)
