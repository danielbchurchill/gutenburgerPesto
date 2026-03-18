extends Control


func _ready() -> void:
	_populate_chapters()


func _populate_chapters() -> void:
	var list := $ChapterList
	var dir := DirAccess.open("res://assets/script/")
	if not dir:
		return

	var files: Array[String] = []
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if fname.begins_with("chapter_") and fname.ends_with(".json"):
			files.append(fname)
		fname = dir.get_next()
	files.sort()

	for f in files:
		var file := FileAccess.open("res://assets/script/" + f, FileAccess.READ)
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		var chapter_num: int = data.get("chapter", 0)
		var title: String = data.get("title", "Chapter %d" % chapter_num)
		var btn := Button.new()
		btn.text = title
		btn.pressed.connect(_start_chapter.bind(chapter_num))
		list.add_child(btn)


func _start_chapter(chapter_num: int) -> void:
	GameState.current_chapter = chapter_num
	get_tree().change_scene_to_file("res://scenes/game.tscn")
