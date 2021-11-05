extends Control

func _ready():
	update_highscores()

func _on_Button_pressed():
	visible = false

func update_highscores():
	var table = $Background/CenterContainer/HighscoreTable
	
	for children in table.get_children():
		children.queue_free()
		
	var level_times = Global.get_level_times()
	var levels = level_times.keys()
	levels.sort()
	
	for level in levels:
		var level_name = Label.new()
		level_name.text = level
		
		var level_time = Label.new()
		level_time.text = str(level_times[level]) + " Sekunden"
		
		table.add_child(level_name)
		table.add_child(level_time)
