extends MarginContainer

@onready var dialogue_label: Label = $Subtitles/DialogueLabel
@onready var dialogue_player: AudioStreamPlayer = $Subtitles/DialoguePlayer

@onready var settings := get_tree().get_first_node_in_group("Settings")

var playing_payload := []

func _ready() -> void:
	visible = false
		
func play(payload_in: Array[DialogPacket]) -> void:
	visible = settings.subtitles_enabled()
	playing_payload = payload_in
	if not playing_payload.is_empty():
		var packet = playing_payload.pop_front()
		dialogue_player.stream = packet.audio
		dialogue_label.text = packet.text
		dialogue_player.play()
		
	# play each line one at a time, printing the subtitle


func _on_dialogue_player_finished() -> void:
	if not playing_payload.is_empty():
		play(playing_payload)
	else:
		dialogue_player.stream = null
		dialogue_label.text = ""
		visible = false
