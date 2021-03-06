extends Node2D

export var weaponName = "Pistol"
export var damage = 50
export var mag = -1 #cuando mag es "-1", las balas son infinitas
export var timeBetweenShoots = 0.3
export var timeToReload = 2
var canShoot

# Called when the node enters the scene tree for the first time.
func _ready():
	canShoot = true
	setupGameController()
	
func _physics_process(delta):
	# "action_just_pressed" para semiautomatico. quitar el "just_" para automatico
	if(Input.is_action_just_pressed("event_leftclick") and $Timer.time_left <= 0 and canShoot):
		shoot()

# funcion para disparar
func shoot():
	# la pistola tiene municion infinita, asi que no tiene comando para restar balas
	# indicamos que escena se va a instanciar (la bala en este caso)
	var bullet = load("res://scenes/player/bullet.tscn")
	# instanciamos la escena (la bala)
	var bulletInstance = bullet.instance()
	# metemos la escena instanciada (la bala) en la escena actual (el nivel en el que estamos)
	get_parent().get_parent().add_child(bulletInstance)
	bulletInstance.damage = damage
	$shoot.play()
	
	# si queremos gastar balas:
	# gameController.bullets -= 1
	
	# ponemos un pequeño "delay" entre disparos
	waitBetweenShots(timeBetweenShoots)

# prepara "gameController.gd" para que la UI saque bien la información
func setupGameController():
	gameController.weapon = weaponName
	gameController.bullets = mag

# funcion para que haya un tiempo despera entre acciones
func waitBetweenShots(wait):
	canShoot = false
	$Timer.start()
	yield($Timer, "timeout")
	$Timer.wait_time = wait
	canShoot = true