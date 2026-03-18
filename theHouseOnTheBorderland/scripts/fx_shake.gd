extends RichTextEffect

var bbcode := "shake"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed: float = char_fx.env.get("speed", 6.0)
	var strength: float = char_fx.env.get("strength", 2.5)
	char_fx.offset.y = sin(char_fx.elapsed_time * speed + float(char_fx.range.x) * 0.8) * strength
	char_fx.offset.x = cos(char_fx.elapsed_time * speed * 0.7 + float(char_fx.range.x) * 0.5) * strength * 0.4
	return true
