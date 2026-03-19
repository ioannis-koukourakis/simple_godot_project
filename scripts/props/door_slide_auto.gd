extends Node3D

#-----------------------------------------
# PROPERTIES
#-----------------------------------------

@onready var animation_player: AnimationPlayer = $animation_player

#-----------------------------------------
# SIGNALS
#-----------------------------------------

func _on_trigger_body_entered(t_body: Node3D) -> void:
	if t_body.get("has_key") == false:
		return;

	if t_body is CharacterBody3D:
		animation_player.play("door_open")

#-----------------------------------------

func _on_trigger_body_exited(t_body: Node3D) -> void:
	if t_body is CharacterBody3D:
		animation_player.play_backwards("door_open")

#-----------------------------------------
