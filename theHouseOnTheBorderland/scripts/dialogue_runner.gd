class_name DialogueRunner
extends Node

signal beat_started(beat: Dictionary)
signal beat_finished
signal chapter_finished

const CHARS_PER_SECOND := 30.0

## Assigned by game.gd before load_chapter is called.
var label: RichTextLabel

var _beats: Array = []
var _index: int = 0
var _typing: bool = false
var _tween: Tween


func load_chapter(path: String) -> void:
	label.custom_effects = [
		load("res://scripts/fx_shake.gd").new(),
		load("res://scripts/fx_wave.gd").new(),
		load("res://scripts/fx_pulse.gd").new(),
	]
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("DialogueRunner: could not open %s" % path)
		return
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	_beats = data.get("beats", [])
	_index = 0
	_show_beat(0)


## Call this on player input (click / tap).
func advance() -> void:
	if _typing:
		_skip_typewriter()
		return
	_index += 1
	if _index < _beats.size():
		_show_beat(_index)
	else:
		chapter_finished.emit()


func _show_beat(index: int) -> void:
	var beat: Dictionary = _beats[index]
	label.text = beat.get("text", "")
	label.visible_ratio = 0.0
	_typing = true
	beat_started.emit(beat)

	if _tween:
		_tween.kill()
	var char_count := label.get_total_character_count()
	var duration := maxf(float(char_count) / CHARS_PER_SECOND, 0.1)
	_tween = create_tween()
	_tween.tween_property(label, "visible_ratio", 1.0, duration)
	_tween.finished.connect(_on_typewriter_done, CONNECT_ONE_SHOT)


func _skip_typewriter() -> void:
	if _tween:
		_tween.kill()
	label.visible_ratio = 1.0
	_on_typewriter_done()


func _on_typewriter_done() -> void:
	_typing = false
	beat_finished.emit()
