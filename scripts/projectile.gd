class_name Projectile
extends RigidBody2D

@export var bounciness: float = 1.0
@export var damage: int = 1
@export var bounce_away_count: int = 3
@export var max_velocity: float = 1000.0
@export var bounce_away_force: float = 100.0
@export var bounce_away_range_x: float = 15.0
@export var collidable_object_sound: String = "bounce"
@export var collidable_object_sound_pitch_min = 0.9
@export var collidable_object_sound_pitch_max = 1.1

var _last_collided: CollidableObject = null
var _last_collided_count: int = 0
var _gravity_scale: float = 2.0

signal hit

func _ready():
	_gravity_scale = gravity_scale
	gravity_scale = 0

func bounce_away():
	# Apply an impulse at the body's center
	var normal = linear_velocity.normalized()
	normal.x = max(1, normal.x) * randf_range(-bounce_away_range_x, bounce_away_range_x)
	var impulse = normal * bounce_away_force  # Adjust the force as needed
	apply_central_impulse(impulse)

func _physics_process(delta):
	if linear_velocity.length() > max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity

func reset():
	_last_collided = null
	_last_collided_count = 0
			
func _on_body_entered(body):
	gravity_scale = _gravity_scale
	var co = body as CollidableObject
	if co == null:
		reset()
		return

	emit_signal("hit")
	
	AudioManager.play(AudioManager.Params.new(collidable_object_sound, 0.05, 100, randf_range(collidable_object_sound_pitch_min, collidable_object_sound_pitch_max)))
		
	if _last_collided == null:
		reset()
		_last_collided = co
		return

	if co == _last_collided:
		_last_collided_count += 1
		if _last_collided_count >= bounce_away_count:
			bounce_away()
			reset()
