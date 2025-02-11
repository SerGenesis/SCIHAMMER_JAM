extends Area3D

var speed = 30
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	await get_tree().create_timer(4).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("shoot"):
		#shoot()
		#
#func shoot():
	#speed = 30
	#await get_tree().create_timer(4).timeout
	#queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body is not CharacterBody3D:
		speed = 0
