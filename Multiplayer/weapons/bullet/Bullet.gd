extends Area2D

export(float) var SPEED = 1500
export(float) var DAMAGE = 1


#---------------VARIAVEIS DO TIRO-------------------------
var direcao = Vector2(1,0)
var velocidade = 700 #Velocidade do Tiro
var tempo_vida = 5 # Tempo de vida do tiro
var tempo = 0 # Contador

#----------------------------------------------------------

var direction = 0

func _ready():
	set_as_toplevel(true)

func _process(delta):
	#-------------ALTERANDO POSIÇÃO DA SPRITE-------------
	
	if direcao == Vector2(1,0):
		$Sprite.flip_h = false
	elif direcao == Vector2(-1,0):
		$Sprite.flip_h = true
	elif direcao == Vector2(0,1):
		$Sprite.rotation_degrees = 90
	elif direcao == Vector2(0,-1):
		$Sprite.rotation_degrees = -90
	elif direcao == Vector2(1,-1):
		$Sprite.flip_h = false
		$Sprite.rotation_degrees = -45
	elif direcao == Vector2(1,1):
		$Sprite.flip_h = false
		$Sprite.rotation_degrees = 45
	elif direcao == Vector2(-1,-1):
		$Sprite.flip_h = true
		$Sprite.rotation_degrees = 45
	elif direcao == Vector2(-1,1):
		$Sprite.flip_h = true
		$Sprite.rotation_degrees = -45
	
	#-------------INICIANDO BALA E TEMPO DE VIDA-------------
		
	set_position(Vector2(get_position().x + velocidade*direcao.x*delta, get_position().y + velocidade*direcao.y*delta))
	
	tempo += delta
	if tempo > tempo_vida:
		queue_free()
		
	#---------------------TELEPORTE DO MAPA#---------------------

func _on_body_entered(body):
	if body.is_in_group('players'):
		body.damage(DAMAGE)
		queue_free()
	if body is TileMap:
		queue_free()
	if body is Area2D:
		queue_free()


func _on_Area2D_area_entered(area):
	if area is Area2D:
		queue_free()
