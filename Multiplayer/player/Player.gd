extends KinematicBody2D



var UP = Vector2(0, -1)
var GRAVITY = 30
var JUMP_HEIGHT = -600
var SPEED = 200
var tempoDash = 1.5
var tempo = tempoDash
var jump_cont = 0
var extra_jump = 1

var _on_wall = false
var in_dash = false

const MAX_HP = 3
var health_points = MAX_HP


#-----VARIAVEIS DE VIZUALIZAÇÃO
slave var slave_position = Vector2()
slave var direita_s
slave var esquerda_s
slave var cima_s
slave var baixo_s
slave var jump_s
slave var dash_s
slave var tiro_s

func _ready():
	_update_health_bar()

func _physics_process(delta):
	
	tempo += delta
	
	if is_network_master():
		
		#-------ENTRADAS DO USUARIO-------
		var direita = Input.is_action_pressed("right")
		var esquerda = Input.is_action_pressed("left")
		var cima = Input.is_action_pressed("up")
		var baixo = Input.is_action_pressed("down")
		var tiro = Input.is_action_pressed("shoot")
		var dash = Input.is_action_pressed("dash")
		
		var jump = Input.is_action_pressed("jump")
		var jump_j = Input.is_action_just_pressed("jump")
		
		#-------FUNCOES ATIVADAS-------
		rset_unreliable('slave_position', position)
		rset('direita_s', direita)
		rset('esquerda_s', esquerda)
		rset('cima_s', cima)
		rset('baixo_s', baixo)
		rset('jump_s', jump)
		rset('dash_s', dash)
		rset('tiro_s', tiro)
		
		_move(direita, esquerda, jump_j, dash, tiro)
		_rifle_diretion(direita, esquerda, cima, baixo)
	
	else:
		#-------VISAO DOS OPONENTES-------
		_move_s(direita_s, esquerda_s, jump_s, dash_s, tiro_s)
		position = slave_position
		_rifle_diretion(direita_s, esquerda_s, cima_s, baixo_s)
	
	if get_tree().is_network_server():
		Network.update_position(int(name), position)
		
func _move(direita, esquerda, jump, dash, tiro):
	
	#--------MOVIMENTO DO PLAYER--------
	
	#----GRAVIDADE----
	if !_on_wall:
		slave_position.y += GRAVITY
	
	#----------RUN----------
	if direita and !_on_wall:
		slave_position.x = SPEED
		$Sprite.play("Run")
		$Sprite.flip_h = false

	elif esquerda and !_on_wall:
		slave_position.x = -SPEED
		$Sprite.play("Run")
		$Sprite.flip_h = true
		
	else:
		slave_position.x = 0
		$Sprite.play("Idle")
		
	#----------JUMPs----------
	if jump and jump_cont < extra_jump:
		slave_position.y = JUMP_HEIGHT
		jump_cont += 1
		_on_wall = false

	if is_on_floor():
		jump_cont = 0
		
	elif _on_wall: 
		slave_position.y = 30
		jump_cont = -1
		$Sprite.play("Wall")
		if $Sprite.flip_h:
			if !esquerda:
				_on_wall = false
		else: 
			if !direita:
				_on_wall = false

		
	else:
		$Sprite.play("Jump")
		
	#----------ATACK----------
	if tiro and !_on_wall:
		$Sprite.play("Atack")
			
	#----------DASH----------
	if dash and tempo >= tempoDash and !_on_wall:
		SPEED = 600
		tempo = 0
		$DashTimer.start()
	
	if SPEED == 600:
		$Sprite.play("Dash")
		if $Sprite.flip_h:
			slave_position.x = -SPEED
		else:
			slave_position.x = SPEED
		
	#------------------------
		
	slave_position = move_and_slide(slave_position, UP)
		
	
func _move_s(direita, esquerda, jump, dash, tiro):
	
	#--------SPRITES DO PLAYER--------
	
	#----------RUN----------
	if jump:
		$Sprite.play("Jump")
	elif direita:
		$Sprite.play("Run")
		$Sprite.flip_h = false
	elif esquerda:
		$Sprite.play("Run")
		$Sprite.flip_h = true
	else:
		$Sprite.play("Idle")
		
	#----------ATACK----------
	if tiro:
		$Sprite.play("Atack")
	
	if _on_wall:
		$Sprite.play("Wall")
	
	if in_dash:
		$Sprite.play("Dash")
	
	
func _on_DashTimer_timeout():
	SPEED = 200

func _rifle_diretion(direita, esquerda, cima, baixo):
	
	#--------DIRECAO DO TIRO--------
	if direita:
		$Rifle.direcao = Vector2(1,0)
		$Rifle.set_position(Vector2(45,0))
	elif esquerda:
		$Rifle.direcao = Vector2(-1,0)
		$Rifle.set_position(Vector2(-45,0))
	elif cima:
		$Rifle.direcao = Vector2(0,-1)
		$Rifle.set_position(Vector2(0,-45))
	elif baixo:
		$Rifle.direcao = Vector2(0,1)
		$Rifle.set_position(Vector2(0,45))
	
func _update_health_bar():
	$GUI/HealthBar.value = health_points

func damage(value):
	health_points -= value
	if health_points <= 0:
		health_points = 0
		rpc('_die')
	_update_health_bar()

sync func _die():
	$RespawnTimer.start()
	set_physics_process(false)
	$Rifle.set_process(false)
	for child in get_children():
		if child.has_method('hide'):
			child.hide()
	$Shape.disabled = true

func _on_RespawnTimer_timeout():
	set_physics_process(true)
	$Rifle.set_process(true)
	for child in get_children():
		if child.has_method('show'):
			child.show()
	$Shape.disabled = false
	health_points = MAX_HP
	_update_health_bar()

func init(nickname, start_position, is_slave):
	global_position = start_position
	#if is_slave:
		#$Sprite.texture = load('res://player/player-alt.png')



