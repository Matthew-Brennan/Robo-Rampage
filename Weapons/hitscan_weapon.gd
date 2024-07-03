extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: Node3D
@export var weapon_dmg := 12

@onready var cooldown: Timer = $Cooldown
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var shot: RayCast3D = $Shot



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cooldown.is_stopped():
			shoot()
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)

func shoot() -> void:
	cooldown.start(1.0/fire_rate)
	var collider = shot.get_collider()
	printt('pew', shot.get_collider())
	weapon_mesh.position.z += recoil
	if collider is Enemy:
		collider.hitpoints -= weapon_dmg
