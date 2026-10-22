extends Node3D

var player_perto = false

@onready var interagir_label = $"../CanvasLayer/InteragirLabel"
@onready var fade = $"../CanvasLayer/Fade"
@onready var historia_imagem = $"../CanvasLayer/HistoriaImagem"
@onready var historia_texto = $"../CanvasLayer/HistoriaTexto"
@onready var escolha_panel = $"../CanvasLayer/EscolhaPanel"
@onready var audio = $"../CanvasLayer/AudioStreamPlayer"
@onready var animation = $"../CanvasLayer/AnimationPlayer"
@onready var passos = $"../CanvasLayer/passo-homem"
@onready var coracao = $"../CanvasLayer/coracao"
@onready var tela = $"../CanvasLayer"
@onready var fala = $"../CanvasLayer/som_fala"
@onready var ligacao = $"../CanvasLayer/som_ligacao"




func _process(_delta):

	if player_perto:
		interagir_label.visible = true

		if Input.is_action_just_pressed("interact"):

			iniciar_historia()
			audio.play()

	else:

		interagir_label.visible = false


func iniciar_historia():
	$diario.queue_free()
	interagir_label.text = ""

	# fade preto
	animation.play("fade_in")
	await animation.animation_finished
	

	# mostra imagem
	historia_imagem.visible = true
	historia_texto.visible = true

	historia_imagem.texture = preload("res://Textures/diario.png")
	fala.play()
	historia_texto.text = "Meve: Não é possível Catherine..."
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Catherine: Eai Oque achou?"
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Maeve: encontrei um diario com o nome de todas as pessoas que desapareceram... e..."
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Maeve: Também..."
	historia_imagem.texture = preload("res://Textures/quarto.png")
	passos.play()
	passos.play()
	await get_tree().create_timer(5).timeout
	passos.play()
	passos.play()
	historia_imagem.texture = preload("res://Textures/catherine.png")
	fala.play()
	historia_texto.text = "Catherine: Oque maeve fala logo!!"
	passos.play()
	passos.play()
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Catherine: MAEV---"
	ligacao.play()
	await get_tree().create_timer(4).timeout
	coracao.play()
	coracao.play()
	coracao.play()
	await get_tree().create_timer(4).timeout
	

	segunda_parte()


func segunda_parte():
	historia_imagem.texture = preload("res://Textures/quarto.png")
	fala.play()
	historia_texto.text = "Maeve: entrou alguem alguem aqui? PRECISEI ME ESCONDER RÁPIDO!"
	passos.play()
	coracao.play()
	escolha_panel.visible = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_botao_armario_pressed():

	escolha_panel.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	await get_tree().create_timer(1).timeout

	historia_imagem.texture = preload("res://Textures/guarda-roupa-esconder.jpeg")
	
	passos.play()
	coracao.play()
	passos.play()
	coracao.play()
	fala.play()
	historia_texto.text = "Meve: No guarda-roupa parecia seguro..."
	coracao.play()
	coracao.play()
	fala.play()
	historia_texto.text = "quem será? policiais?"
	coracao.play()
	coracao.play()
	await get_tree().create_timer(6).timeout
	historia_texto.text = "Maeve: parece que já saíra"
	await get_tree().create_timer(4).timeout
	coracao.play()	
	animation.play("fade_out")
	historia_imagem.visible = false	
	fala.play()
	historia_texto.text = "Maeve: Não sei porque a Catherine não me avisou que havia alguém perto da casa"
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Maeve:tive que voltar ao outro lado da rua e entrar no carro sem ser vista!"
	await get_tree().create_timer(4).timeout
	
	animation.play("fade_out")

func _on_botao_cama_pressed():

	escolha_panel.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	await get_tree().create_timer(1).timeout

	historia_imagem.texture = preload("res://Textures/olhando-cama.png")
	fala.play()
	historia_texto.text = "embaixo da cama parecia seguro..."
	coracao.play()
	coracao.play()
	fala.play()
	historia_texto.text = "Maeve: quem são? policiais?"
	await get_tree().create_timer(6).timeout
	historia_texto.text = "Maeve: parece que já saíra"
	await get_tree().create_timer(4).timeout
	coracao.play()	
	animation.play("fade_out")
	historia_imagem.visible = false	
	fala.play()
	historia_texto.text = "Maeve: não sei porque a Catherine não me avisou que havia alguém perto da casa"
	await get_tree().create_timer(4).timeout
	fala.play()
	historia_texto.text = "Maeve: Tive que chegar ao outro lado da rua e entrar no carro sem ser vista!"
	await get_tree().create_timer(4).timeout
	
	
func _on_area_3d_body_entered(body):

	if body.name == "player":

		player_perto = true


func _on_area_3d_body_exited(body):

	if body.name == "player":

		player_perto = false
