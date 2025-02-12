extends CharacterBody3D
class_name Enemy
@onready var damage_area :Area3D=$DamageArea
@onready var anim:AnimationPlayer = $enemy_1/AnimationPlayer
@onready var nav_agent :NavigationAgent3D= $NavigationAgent3D
var gravity = 18
var gravity_scale = 1
var hp = 3


enum STATE {
	RUN,
	ATTACK,
	DIE
}
var speed = 5
var player : CharacterBody3D
var navigation : NavigationRegion3D
var player_in_damage :bool=false

var current_state = STATE.RUN
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("enemy_start_signal", start )
	
func _process(delta: float) -> void:
	if Globals.is_dash:
		damage_area.collision_mask = 1
	else:
		damage_area.collision_mask = 1

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
	current_state = STATE.DIE

func start():
	anim.play("run")
	anim.speed_scale = 3

func target_position(target):
	nav_agent.target_position = target


func _on_area_3d_body_entered(body: Node3D) -> void:
	$CPUParticles3D.global_position = body.global_position
	$CPUParticles3D.emitting = true
	body.queue_free()
	if current_state != STATE.DIE:
		take_damage()
		
func take_damage():
	hp -= 1
	if hp <= 0:
		current_state = STATE.DIE
		die()


func _on_damage_area_body_entered(body: Node3D) -> void:
	if body is Player and current_state == STATE.RUN:
		player_in_damage = true
		current_state = STATE.ATTACK
		anim.play("hit")
		await get_tree().create_timer(0.5).timeout
		if player_in_damage:
			body.get_damage()
		current_state = STATE.RUN
		anim.play("run")
	
		
		


func _on_damage_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_damage = false
