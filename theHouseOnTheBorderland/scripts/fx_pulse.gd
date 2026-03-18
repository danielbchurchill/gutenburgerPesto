extends RichTextEffect

var bbcode := "pulse"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed: float = char_fx.env.get("speed", 2.0)
	var target: Color = char_fx.env.get("color", Color(0.6, 0.0, 0.0, 1.0))
	var alpha: float = (sin(char_fx.elapsed_time * speed) + 1.0) * 0.5
	char_fx.color = char_fx.color.lerp(target, alpha * 0.75)
	return true
