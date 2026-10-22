extends Control

@onready var imagem = $TextureRect
@onready var texto = $Label
@onready var video = $VideoStreamPlayer
@onready var teclas1 = $AudioStreamPlayer

var velocidade_texto = 0.09


func _ready():
	iniciar_intro()


func escrever_texto(frase):

	texto.text = frase
	texto.visible_characters = 0

	for i in frase.length():

		texto.visible_characters += 1

		var letra = frase[i]

		if letra != " ":
			teclas1.play()

		await get_tree().create_timer(velocidade_texto).timeout



func iniciar_intro():

	# PRIMEIRA CENA
	imagem.texture = preload("res://Textures/cidade.png")

	await escrever_texto(
		"Eu costumava achar minha cidade bem monótona, mas nos ultimos meses, o silencio ganhou um significado bem mais sinistro"
	)

	await get_tree().create_timer(2).timeout


	# SEGUNDA CENA
	imagem.texture = preload("res://Textures/muro.png")

	await escrever_texto(
		"Começou com boatos, depois cartases colados nos postes, um, dois, cinco desaparecimentos em duas semanas"
	)

	await get_tree().create_timer(2).timeout


	# TERCEIRA CENA
	imagem.texture = preload("res://Textures/amelie-e-maeve.jpeg")

	await escrever_texto(
		"Até que o chão sumiu dos meus pés, a estatistica ganhou um nome, um rosto e todas as minhas memorias de infancia, minha melhor amiga... desapareceu."
	)

	await get_tree().create_timer(3).timeout


	# ESCONDE IMAGEM E TEXTO
	imagem.visible = false
	texto.visible = false


	# TOCA O VIDEO
	video.visible = true
	video.play()

	await video.finished


	# MUDA PRA CENA DA CASA
	get_tree().change_scene_to_file("res://cutscenes/cutscene.tscn")
