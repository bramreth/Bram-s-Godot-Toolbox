extends MarginContainer

signal exit()

@export_category("FOV")
@export var min_fov: float = 60
@export var max_fov: float = 100
@export var default_fov: float = 75

@export_category("Mouse Sensitivity")

@export var very_low_sens: float = 0.00025
@export var low_sens: float = 0.0005
@export var medium_sens: float = 0.00075
@export var high_sens: float = 0.001
@export var very_high_sens: float = 0.00125

@onready var _player = get_tree().get_first_node_in_group("Player")

@onready var fov_slider: HSlider = %FOVSlider
@onready var fov_value: Label = %FOVValue

@onready var sensitivity_dropdown: OptionButton = %SensitivityDropdown
@onready var shadow_option_button: OptionButton = %ShadowOptionButton
@onready var ssaa_option_button: OptionButton = %SSAAOptionButton
@onready var msaa_option_button: OptionButton = %MSAAOptionButton

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var dialogue_slider: HSlider = %DialogueSlider
@onready var subtitles_check_button: CheckButton = %SubtitlesCheckButton

@onready var button: Button = $VBoxContainer/Button

func focus() -> void:
	button.grab_focus()

func _ready() -> void:
	fov_slider.min_value = min_fov
	fov_slider.max_value = max_fov
	fov_slider.value = default_fov
	_on_fov_slider_value_changed(fov_slider.value)
	
	# set sensitivity to medium
	sensitivity_dropdown.select(2)
	_on_option_button_item_selected(2)
	
	# set shadow quality to medium
	shadow_option_button.select(1)
	_on_shadow_option_button_item_selected(1)
	
	# enable SSAA
	ssaa_option_button.select(1)
	_on_ssaa_option_button_item_selected(1)
	
	# 4x AA
	msaa_option_button.select(2)
	_on_msaa_option_button_item_selected(2)
	
	# set all sliders to full volume
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	dialogue_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogue")))
	
	# enable subtitles
	subtitles_check_button.button_pressed = true
	
func _on_button_pressed() -> void:
	exit.emit()


func _on_fov_slider_value_changed(value: float) -> void:
	fov_value.text = str(value)
	var camera = get_viewport().get_camera_3d()
	if is_instance_valid(camera):
		camera.fov = value


func _on_option_button_item_selected(index: int) -> void:
	return
#	match index:
#		0:
#			_player.mouse_sensitivity = very_low_sens
#		1:
#			_player.mouse_sensitivity = low_sens
#		2:
#			_player.mouse_sensitivity = medium_sens
#		3:
#			_player.mouse_sensitivity = high_sens
#		4:
#			_player.mouse_sensitivity = very_high_sens

func _on_fullscreen_check_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_shadow_option_button_item_selected(index: int) -> void:
	match index:
		0:
			# low
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		1:
			# medium
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		2:
			# high
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)


func _on_msaa_option_button_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1:
			
			get_viewport().msaa_3d = Viewport.MSAA_2X
		2:
			
			get_viewport().msaa_3d = Viewport.MSAA_4X
		3:
			
			get_viewport().msaa_3d = Viewport.MSAA_8X


func _on_ssaa_option_button_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear_to_db(value)
		)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		linear_to_db(value)
		)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), 
		linear_to_db(value)
		)


func _on_reload_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_dialogue_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Dialogue"), 
		linear_to_db(value)
		)


func subtitles_enabled() -> bool:
	return subtitles_check_button.button_pressed == true
