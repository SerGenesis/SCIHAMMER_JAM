extends Node

@onready var is_playble:bool=false
@onready var room_start:bool=false
@onready var player_pos : Vector3

signal enemy_start_signal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	enemy_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enemy_start():
	enemy_start_signal.emit()
			
