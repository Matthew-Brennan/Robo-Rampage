extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: Node3D
@export var weapon_dmg := 12
@export var muzzle_flash: GPUParticles3D
@export var sparks: PackedScene
@export var automatic : bool
@export var ammo_handler: AmmoHandler
@export var ammo_type: AmmoHandler.ammo_type

@onready var cooldown: Timer = $Cooldown
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var shot: RayCast3D = $Shot



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown.is_stopped():
				shoot()
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)

func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		muzzle_flash.restart()
		cooldown.start(1.0/fire_rate)
		var collider = shot.get_collider()
		printt('pew', shot.get_collider())
		weapon_mesh.position.z += recoil
		if collider is Enemy:
			collider.hitpoints -= weapon_dmg
		var spark = sparks.instantiate()
		add_child(spark)
		spark.global_position = shot.get_collision_point()
