extends RichTextEffect

var bbcode := "wave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed: float = char_fx.env.get("speed", 3.0)
	var height: float = char_fx.env.get("height", 4.0)
	char_fx.offset.y = sin(char_fx.elapsed_time * speed + float(char_fx.range.x) * 0.35) * height
	return true
