class_name Pickup extends Node3D 

#-----------------------------------------
# SETTINGS
#-----------------------------------------

@export var rotation_speed: float = 2.0
@export var float_amplitude: float = 0.1
@export var float_speed: float = 2.0
@export var item_type: String = "item"
@export var trigger: Area3D = null

#-----------------------------------------
# PROPERTIES
#-----------------------------------------

var initial_position: Vector3
var time_passed: float = 0.0

#-----------------------------------------
# LIFECYCLE
#-----------------------------------------

func _ready() -> void:
	initial_position = global_transform.origin

	# Connect to trigger area directly.
	if (is_instance_valid(trigger)):
		trigger.connect("body_entered", Callable(self, "_on_trigger_body_entered"))

#-----------------------------------------

func _process(t_delta: float) -> void:
	# Rotate the item.
	rotate_y(rotation_speed * t_delta)

	# Float the item up and down.
	time_passed += t_delta
	var float_offset: float = sin(time_passed * float_speed) * float_amplitude
	global_transform.origin.y = initial_position.y + float_offset

#-----------------------------------------
# SIGNALS
#-----------------------------------------

func _on_trigger_body_entered(t_body: Node3D) -> void:
	if t_body is CharacterBody3D:
		visible = false;
		if t_body.has_method("add_to_inventory"):
			t_body.add_to_inventory(item_type)
			queue_free()

#-----------------------------------------
