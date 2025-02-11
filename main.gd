extends Node3D

@onready var target = $player

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
func _process(delta: float) -> void:
	get_tree().call_group("enemy", "target_position", target.global_transform.origin)
