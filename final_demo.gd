extends Control

@onready var moldura_imagem = $MolduraImagem
@onready var texto_legenda = $TextoLegenda
@onready var creditos_texto = $CreditosTexto
@onready var som_caneta = $SomCaneta
@onready var som_relogio = $Som_Relogio

# --- CARREGUE SUAS IMAGENS AQUI ---
var img_diario = preload("res://Textures/diario-final.png")
var img_assustada = preload("res://Textures/catherine-final.png")
var img_hospicio = preload("res://Textures/final-maeve.png")

func _ready() -> void:
	# Garante que começa tudo limpo e esconde os créditos
	moldura_imagem.texture = null
	texto_legenda.text = ""
	creditos_texto.modulate.a = 0
	
	# Inicia a história
	rodar_historia_final()

func rodar_historia_final() -> void:
	texto_legenda.text = "Maeve: Finalmente, cheguei em casa"
	await get_tree().create_timer(4.0).timeout
	texto_legenda.text = "Maeve: Mas antes de sair do carro eu resolvi dar mais uma olhada no diário e..."
	await get_tree().create_timer(4.0).timeout
	# ==========================================
	# PARTE 1: O Diário
	# ==========================================
	moldura_imagem.texture = img_diario
	texto_legenda.text = "Maeve: Como assim?"
	await get_tree().create_timer(4.0).timeout
	
	texto_legenda.text = "Maeve: ..."
	await get_tree().create_timer(3.0).timeout
	
	moldura_imagem.texture = img_assustada
	texto_legenda.text = "Catherine: O que foi Maeve? Parece que viu um fantasma."
	await get_tree().create_timer(4.5).timeout
	
	# ==========================================
	# PARTE 2: Maeve Assustada
	# ==========================================
	texto_legenda.text = "Maeve: Não, Nada não... só pensando em quem poderia estar fazendo tudo isso..."
	await get_tree().create_timer(8.0).timeout
	
	# Corta rápido para o preto antes do grande plot twist
	moldura_imagem.texture = null
	som_relogio.play()
	texto_legenda.text = "E foi exatamente assim..."
	await get_tree().create_timer(8.0).timeout
	
	# ==========================================
	# PARTE 3: O Hospício (A Revelação)
	# ==========================================
	moldura_imagem.texture = img_hospicio
	texto_legenda.text = "exatamente assim que eu me lembro que aconteceu..."
	await get_tree().create_timer(6.0).timeout
	texto_legenda.text = "na primeira parte..."
	await get_tree().create_timer(6.0).timeout
	som_caneta.play()
	texto_legenda.text = "DIA 01"
	som_relogio.stop()
	await get_tree().create_timer(5.0).timeout
	# ==========================================
	# PARTE 4: Créditos (Subindo na mesma cena)"res://musicas/clock.mp3"
	# ==========================================
	subir_creditos()

func subir_creditos() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Limpa as imagens e legendas da história
	moldura_imagem.texture = null
	texto_legenda.text = ""
	
	# Texto formatado com BBCode para o seu RichTextLabel
	creditos_texto.text = """[center]
[font_size=32][b]DEAR AMELIE[/b][/font_size]

[color=#888888]Desenvolvido por[/color]
[b]Emily Silva[/b]
[b]Milena Kamily[/b]

[color=#888888]História e Roteiro[/color]
[b]Lídia Tapajós[/b]
[b]Milena Aragão[/b]


[color=#888888]Efeitos e trilha sonora [/color]
[b]Lídia Tapajós[/b]
[b]Emily Silva[/b]

[b]OBRIGADO POR JOGAR! A Demonstração, ainda tem mais![/b]


[color=#888888]Quem está causando os desaparecimentos?[/color]
[b]Você tem alguma ideia?[/b]

---

[font_size=20]Quem você acha que 
sumiu com a Amelie?[/font_size]

[color=#ff4444]Siga as redes sociais 
para mais pistas![/color]


[/center]"""
	
	# Torna o RichTextLabel visível
	creditos_texto.modulate.a = 1 
	
	# Calcula a subida baseada no tamanho do texto
	var destino_y = -creditos_texto.size.y - 100
	var tempo_subida = 15.0 # Segundos que os créditos levam para subir
	
	# Animação suave com Tween
	var tween = create_tween()
	tween.tween_property(creditos_texto, "position:y", destino_y, tempo_subida)
	
	# Quando terminar de subir tudo, vai pro Menu
	await tween.finished
	ir_para_menu()

func _input(event: InputEvent) -> void:
	# Se o jogador clicar ou apertar algo enquanto os créditos sobem, pula pro menu
	if creditos_texto.modulate.a == 1 and event.is_pressed():
		ir_para_menu()

func ir_para_menu() -> void:
	set_process(false)
	get_tree().change_scene_to_file("res://Menu.tscn")
