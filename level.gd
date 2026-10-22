extends Node3D

# Aqui no script do próprio Level, os caminhos locais funcionam perfeitamente
@onready var interagir_label = $CanvasLayer2/Label
@onready var confirm_panel = $CanvasLayer2/ConfirmPanel
@onready var carro = $carro
@onready var som = $"CanvasLayer2/ConfirmPanel/BotaoSim/porta-carro"
@onready var som_porta_carro = $som_porta_carro #Certifique-se de que o nome do nó do carro no seu level é 'carro'

func _ready():
	# Esconde a UI no começo
	interagir_label.visible = false
	confirm_panel.visible = false
	
	# Conectamos os sinais do carro a este script dinamicamente
	if carro:
		carro.jogador_chegou.connect(_on_carro_jogador_chegou)
		carro.jogador_saiu.connect(_on_carro_jogador_saiu)
		carro.jogador_interagiu.connect(_on_carro_jogador_interagiu)

# Funções que respondem aos sinais do carro
func _on_carro_jogador_chegou():
	interagir_label.text = "Clique E para Entrar"
	interagir_label.visible = true

func _on_carro_jogador_saiu():
	interagir_label.visible = false
	confirm_panel.visible = false

func _on_carro_jogador_interagiu():
	interagir_label.visible = false
	confirm_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# --- Conecte os botões SIM e NÃO a este script do LEVEL agora ---

func _on_botao_sim_pressed():
	if som_porta_carro:
		som_porta_carro.play()
		
		# 3. Faz o Godot esperar o som terminar antes de mudar de cena
		await som_porta_carro.finished
	
	# 4. Agora sim, muda para a próxima cena
	get_tree().change_scene_to_file("res://estrada.tscn") # Ou a sua próxima cena

func _on_botao_nao_pressed():
	confirm_panel.visible = false
	# Se o carro avisar que o player ainda tá perto, mostra o texto de novo
	if carro and carro.player_perto:
		interagir_label.visible = true
		carro.pergunta_aberta = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
