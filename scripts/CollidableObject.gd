class_name CollidableObject
extends RigidBody2D

@export var base_color: Color = Color.RED
@export var health: int = 100
@export var bounciness: float = 1.0
@export var particle_play_duration: float = 0.25
@export var death_audio_config: AudioClipParams

@onready var particles: GPUParticles2D = $Particles
@onready var HealthLabel: RichTextLabel = $Label
@onready var sprite: Sprite2D = $Sprite
@onready var collisionShape2D = $CollisionShape2D
@onready var shake = $Shake

signal death(collidable_object: CollidableObject)

func _ready():
	sprite.modulate = base_color
	_update_health()
	await get_tree().create_timer(0.01).timeout
	if $Sprite/PointLight2D:
		$Sprite/PointLight2D.visible = true

func _update_sprite_color():
	var hue = health / 100.0
	var color = sprite.modulate
	color.h = hue
	sprite.modulate = color

func _update_text_color():
	var hue = 100.0 / max(health, 1.0) + 0.33
	var color = HealthLabel.modulate
	color.h = hue
	HealthLabel.modulate = color

func _update_health():
	HealthLabel.text = "[center]" + str(health) + "[/center]"
	_update_sprite_color()
	_update_text_color()

func _shake():
	shake.shake()

func _do_particles():
	particles.emitting = true
	await get_tree().create_timer(particle_play_duration).timeout
	particles.emitting = false
		
func _do_death():
	AudioManager.play(death_audio_config.duplicate_random_pitch())
	emit_signal("death", self)
	queue_free()

func set_health(new_health: int):
	health = new_health
	_update_health()

func on_hit(strength: int = 1):
	health -= strength
	if health <= 0:
		_do_death()
	else:
		_update_health()
		_do_particles()
		_shake()

func random_rotation():
	sprite.rotation = randf_range(0.0, 2.0 * PI)
	collisionShape2D.rotation = sprite.rotation

func _on_body_entered(body):
	var ball = body as Projectile
	if !ball:
		return
	on_hit(ball.damage)
