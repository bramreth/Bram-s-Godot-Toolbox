extends CanvasLayer

@onready var pause_screen: Control = $PauseScreen
@onready var pause_container: CenterContainer = %PauseContainer
@onready var settings_container: MarginContainer = %SettingsContainer
@onready var resume_button: Button = %ResumeButton

var paused := false:
	set(value):
		paused = value
		pause_screen.visible = paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			resume_button.grab_focus()
			get_tree().paused = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			get_tree().paused = false
		
func _ready() -> void:
	paused = false
	pause_container.visible = true
	settings_container.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		paused = true


func _on_resume_button_pressed() -> void:
	paused = false


func _on_settings_button_pressed() -> void:
	pause_container.visible = false
	settings_container.visible = true
	settings_container.focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_container_exit() -> void:
	pause_container.visible = true
	settings_container.visible = false
	resume_button.grab_focus()
