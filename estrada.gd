extends Node3D

@onready var radio_chiado = $RadioChiado
@onready var radio_voz = $RadioVoz

func _ready():
	iniciar_radio()
	iniciar_tempo_limite()

func iniciar_radio():
	radio_chiado.play()

	await get_tree().create_timer(4.0).timeout
	
	radio_voz.play()
	await get_tree().create_timer(16.37).timeout
	
	radio_chiado.play()

func iniciar_tempo_limite():
	# O jogo vai esperar 50 segundos desde o começo da cena
	await get_tree().create_timer(50.0).timeout
	
	# Muda automaticamente para a cena final do hospício/cutscene
	# LEBRE-SE: Ajuste o caminho abaixo se o nome do seu arquivo for diferente!
	get_tree().change_scene_to_file("res://levels/final_demo.tscn")
