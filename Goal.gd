extends Node2D

signal streamling_reached_goal(streamling)

func _on_GoalArea_body_entered(body):
	if body is Streamling:
		var streamling = body as Streamling
		emit_signal("streamling_reached_goal", streamling)
