extends CharacterBody3D
class_name Enemy

@onready var anim = $enemy_1/AnimationPlayer
@onready var nav_agent :NavigationAgent3D= $NavigationAgent3D
var gravity = 18
var gravity_scale = 1


enum STATE {
	RUN,
	ATTACK,
	DIE
}
var speed = 5
var player : CharacterBody3D
var navigation : NavigationRegion3D

var current_state = STATE.RUN
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("enemy_start_signal", start )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * gravity_scale * delta
	if current_state == STATE.RUN:
		look_at(Globals.player_pos)
		var next_location = nav_agent.get_next_path_position()
		var current_location = global_transform.origin
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

func die():
	anim.play("dead")

func start():
	anim.play("run")
	anim.speed_scale = 3

func target_position(target):
	nav_agent.target_position = target


func _on_area_3d_body_entered(body: Node3D) -> void:
	if current_state != STATE.DIE:
		body.queue_free()
		die()
		current_state = STATE.DIE
