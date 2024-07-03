extends CharacterBody3D


@export var speed = 5.0
@export var walk_speed = 5.0
@export var sprint_speed = 1.5
@export var jump_height = 1.0
@export var mouse_sensitivity = 0.002
@export var max_hitpoints := 100

@export var fall_multiplyer = 2.0

@onready var camera_pivot: Node3D = $CameraPivot



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			get_tree().quit()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		#if jumping up apply gravity as normal
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else: #if falling down increase the speed at which the player falls making jumping feel snappier
			velocity.y -= gravity * delta * fall_multiplyer

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_motion = -event.relative * mouse_sensitivity
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	#handle sprinting
	if event.is_action_pressed("sprint"):
		speed = speed * sprint_speed
	if event.is_action_released("sprint"):
		speed = walk_speed
	
func camera_rotation() -> void:
	#Roate the camera left and right
	rotate_y(mouse_motion.x)
	
	#roate the camera up and down
	camera_pivot.rotate_x(mouse_motion.y)
	#limit the camera rotation to feet and sky without going over so 180 degrees from forward
	#straight ahead is 0 degrees up is maxed at 90 bottom is maxed at -90
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	)
	mouse_motion = Vector2.ZERO
