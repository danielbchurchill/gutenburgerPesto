extends Node

@onready var _runner: DialogueRunner = $DialogueRunner
@onready var _world: Node3D = $World

var _current_scene_key: String = ""


func _ready() -> void:
	_runner.label = $CanvasLayer/DialogueBox
	_runner.beat_started.connect(_on_beat_started)
	_runner.chapter_finished.connect(_on_chapter_finished)
	var path := "res://assets/script/chapter_%02d.json" % GameState.current_chapter
	_runner.load_chapter(path)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_runner.advance()
	elif event is InputEventScreenTouch and event.pressed:
		_runner.advance()


func _on_beat_started(beat: Dictionary) -> void:
	var scene_key: String = beat.get("scene", "")
	if scene_key != _current_scene_key:
		_load_environment(scene_key)
		_current_scene_key = scene_key


func _load_environment(scene_key: String) -> void:
	for child in _world.get_children():
		child.queue_free()
	var path := "res://scenes/environments/%s.tscn" % scene_key
	if ResourceLoader.exists(path):
		_world.add_child((load(path) as PackedScene).instantiate())


func _on_chapter_finished() -> void:
	GameState.current_chapter += 1
	get_tree().change_scene_to_file("res://scenes/chapter_select.tscn")
