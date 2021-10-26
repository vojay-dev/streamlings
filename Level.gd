extends StaticBody2D

signal streamling_reached_goal

export (int) var lemming_threshold = 5

export (int) var stones = 5
export (int) var umbrellas = 42

func _on_Goal_streamling_reached_goal(streamling):
	emit_signal("streamling_reached_goal", streamling)
