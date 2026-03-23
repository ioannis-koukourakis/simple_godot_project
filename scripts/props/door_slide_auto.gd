extends Node3D

#-----------------------------------------
# PROPERTIES
#-----------------------------------------

@onready var animation_player: AnimationPlayer = $animation_player
var is_open: bool = false

#-----------------------------------------
# SIGNALS
#-----------------------------------------

func _on_trigger_body_entered(t_body: Node3D) -> void:
	if t_body.get("has_key") == false:
		return;

	if t_body is CharacterBody3D:
		animation_player.play("door_open")
		is_open = true

#-----------------------------------------

func _on_trigger_body_exited(t_body: Node3D) -> void:
	if is_open and t_body is CharacterBody3D:
		animation_player.play_backwards("door_open")
		is_open = false

#-----------------------------------------
