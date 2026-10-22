extends Node3D

# Criamos sinais para avisar o Level quando o player entra ou sai
signal jogador_chegou
signal jogador_saiu
signal jogador_interagiu

var player_perto : bool = false
var pergunta_aberta : bool = false

func _ready():
	pass

func _process(_delta):
	# Se o player estiver perto, apertar E e a pergunta ainda não estiver aberta
	if player_perto and not pergunta_aberta and Input.is_action_just_pressed("interact"):
		pergunta_aberta = true
		jogador_interagiu.emit() # Avisa o level para abrir a pergunta

func _on_area_3d_body_entered(body):
	if body.name == "player":
		player_perto = true
		if not pergunta_aberta:
			jogador_chegou.emit() # Avisa o level para mostrar o "Clique E"

func _on_area_3d_body_exited(body):
	if body.name == "player":
		player_perto = false
		pergunta_aberta = false
		jogador_saiu.emit() # Avisa o level para sumir com tudo
