extends Node

@onready var is_playble:bool=false
@onready var room_start:bool=false
@onready var player_pos : Vector3

var is_dash = false

signal enemy_start_signal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enemy_start():
	enemy_start_signal.emit()
	
func dash():
	is_dash = true
	await get_tree().create_timer(0.8).timeout
	is_dash = false
			
