extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 10.0


var mouse_sensitivity :float = 0.1
var yaw: float = 0.0
var pitch: float = 0.0
var gravity_scale = 1
var is_jumping = false
var shoot_position :Vector3= Vector3(0, 1.3, -1.5)

@onready var anim :AnimationPlayer= $AnimationPlayer
@onready var is_playble :bool= false
@onready var right_wall_cast: RayCast3D = $"RightWallСast"
@onready var left_wall_cast: RayCast3D = $LeftWallCast
@onready var taro_start : = $TaroStart
var bullet_scene :PackedScene= preload("res://presets/taro/taro.tscn")

@onready var camera : Camera3D = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().create_timer(0.05).timeout
	if Globals.room_start == true:
		anim.play("room_anim-start")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_scale * delta
	if Globals.is_playble:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
func _process(delta: float) -> void:
	Globals.player_pos = self.position
func check_wall_run():
	if right_wall_cast.is_colliding() and Input.is_action_pressed("right"):
		if is_jumping == false:
			velocity.y = 0
		gravity_scale = -0.1
	elif left_wall_cast.is_colliding() and Input.is_action_pressed("left"):
		gravity_scale = -0.1
		if is_jumping == false:
			velocity.y = 0
	else:
		gravity_scale = 1
		


	
func _input(event: InputEvent) -> void:
	check_wall_run()
	if Globals.is_playble:
		if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			await get_tree().create_timer(1).timeout
			is_jumping = false
		if event is InputEventMouseMotion:
			yaw -= event.relative.x * mouse_sensitivity
			pitch -= event.relative.y * mouse_sensitivity
			pitch = clamp(pitch, -90, 90)
			rotation_degrees.y = yaw
			camera.rotation_degrees.x = pitch
		if Input.is_action_just_pressed("shoot"):
			shoot()
		
func shoot() -> void:
	var camera = get_viewport().get_camera_3d()
	var direction = -camera.global_transform.basis.z  # Ось Z камеры указывает вперед
	var bullet = bullet_scene.instantiate()
	bullet.position = global_transform.origin + Vector3.UP * 1.5
	bullet.direction = direction
	bullet.rotation = camera.global_rotation
	get_parent().add_child(bullet)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "room_anim-start":
		Globals.is_playble = true
