extends Node3D
class_name Enemy

@onready var anim = $AnimationPlayer

enum STATE {
	RUN,
	ATTACK,
	DIE
}

var current_state = STATE.RUN
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("enemy_start_signal", start )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == STATE.RUN:
		look_at(Globals.player_pos)

func die():
	anim.play("dead")

func start():
	anim.play("run")
	anim.speed_scale = 3


func _on_area_3d_body_entered(body: Node3D) -> void:
	if current_state != STATE.DIE:
		die()
		current_state = STATE.DIE
