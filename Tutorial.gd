extends Control

func _ready():
	for child in get_children():
		child.modulate = Color8(255, 255, 255, 0)

	show_element($Step1, 0, 5)
	show_element($Step2, 5, 5)
	show_element($Step3, 10, 5)
	show_element($Step4, 15, 5)
	show_element($Step5, 20, 5)

func show_element(element, delay, duration):
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		element,
		"modulate",
		Color8(255, 255, 255, 0),
		Color8(255, 255, 255, 255),
		2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		delay
	)
	tween.start()
	tween.connect("tween_completed", self, "hide_element", [ duration ])

func hide_element(object, key, duration):
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(
		object,
		"modulate",
		Color8(255, 255, 255, 255),
		Color8(255, 255, 255, 0),
		2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		duration
	)
	tween.start()
