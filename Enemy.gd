extends CharacterBody3D




@export var attack_range := 1.5
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var alert_sfx: AudioStreamPlayer = $AlertSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player
var provoked := false
var aggro_range := 12.0

var direction
var distance

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	if provoked == true:
		navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	
	var next_position = navigation_agent_3d.get_next_path_position()	
	distance = global_position.distance_to(player.global_position)
	direction - global_position.direction_to(next_position)
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if distance < aggro_range:
		provoked = true
		alert_sfx.play(0.0)

	else:
		provoked = false
		direction = global_position.direction_to(global_position)

	if provoked == true:
		if distance <= attack_range:
			animation_player.play("Attack")
			direction = global_position.direction_to(next_position)
	
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)
