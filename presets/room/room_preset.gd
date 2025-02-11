extends Node3D

@onready var anim :AnimationPlayer= $AnimationPlayer
@onready var trigger :Area3D= $enemy_trigger

var door_is_kicked = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.room_start = true
	$AudioStreamPlayer3D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and door_is_kicked:
		Globals.enemy_start()
		anim.play("door_kick")
		door_is_kicked = false
		await get_tree().create_timer(0.8).timeout
		Engine.time_scale = 0.1
		await get_tree().create_timer(0.5).timeout
		Engine.time_scale = 1
