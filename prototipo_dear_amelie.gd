extends Control
## Protótipo narrativo autossuficiente de Dear Amelie (Godot 4.6).
## Não depende de imagens, sons ou cenas externas.

const BG := Color("#10131c")
const PANEL := Color("#202535")
const INK := Color("#e7e1db")
const MUTED := Color("#a7a6b3")
const ACCENT := Color("#bd9dc8")

var chapter := 0
var has_key := false
var has_flashlight := false
var found_photo := false
var found_notes := false
var found_diary := false
var choice_hide := ""
var story: Label
var heading: Label
var status: Label
var actions: VBoxContainer
var background: ColorRect

func _ready() -> void:
	_build_ui()
	_show_scene()

func _build_ui() -> void:
	background = ColorRect.new()
	background.color = BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var frame := MarginContainer.new()
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.add_theme_constant_override("margin_left", 42)
	frame.add_theme_constant_override("margin_right", 42)
	frame.add_theme_constant_override("margin_top", 32)
	frame.add_theme_constant_override("margin_bottom", 32)
	add_child(frame)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 18)
	frame.add_child(layout)

	var title := Label.new()
	title.text = "D E A R   A M E L I E"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 31)
	title.add_theme_color_override("font_color", ACCENT)
	layout.add_child(title)

	heading = Label.new()
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 24)
	heading.add_theme_color_override("font_color", INK)
	layout.add_child(heading)

	var divider := HSeparator.new()
	layout.add_child(divider)

	story = Label.new()
	story.size_flags_vertical = Control.SIZE_EXPAND_FILL
	story.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	story.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	story.add_theme_font_size_override("font_size", 21)
	story.add_theme_color_override("font_color", INK)
	layout.add_child(story)

	actions = VBoxContainer.new()
	actions.add_theme_constant_override("separation", 9)
	layout.add_child(actions)

	status = Label.new()
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_font_size_override("font_size", 14)
	status.add_theme_color_override("font_color", MUTED)
	layout.add_child(status)

func _button(caption: String, next: Callable) -> void:
	var b := Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(0, 46)
	b.add_theme_font_size_override("font_size", 18)
	b.pressed.connect(next)
	actions.add_child(b)

func _go(target: int) -> void:
	chapter = target
	_show_scene()

func _show_scene() -> void:
	for child in actions.get_children():
		child.queue_free()
	heading.text = ""
	story.text = ""
	match chapter:
		0:
			heading.text = "PRÓLOGO • A CASA"
			story.text = "A chuva cobre a estrada. À sua frente, a antiga casa de Amelie permanece em silêncio.\n\nCatherine: 'Precisamos entrar, Mave. Talvez ela tenha deixado alguma pista.'"
			_button("Procurar a chave entre os vasos", func(): has_key = true; _go(1))
			_button("Pedir que Catherine arrombe a porta", func(): _go(2))
		1:
			heading.text = "UMA CHAVE ENFERRUJADA"
			story.text = "Você encontra uma chave sob um vaso de flores murchas.\n\nCatherine: 'Você sempre foi boa em esconder as coisas, Mave.'\n\nPor que ela diria isso?"
			_button("Abrir a porta com cuidado", func(): _go(3))
		2:
			heading.text = "O ESTALO DA MADEIRA"
			story.text = "Catherine força a porta. O barulho ecoa pela casa vazia.\n\nPor um instante, parece que alguém se move no andar de cima."
			_button("Entrar na casa", func(): _go(3))
		3:
			heading.text = "CORREDOR"
			story.text = "O papel de parede descasca. Há marcas de passos na poeira.\n\nCatherine: 'O quarto dela fica no fim do corredor.'"
			_button("Ir até o quarto de Amelie", func(): _go(4))
		4:
			heading.text = "QUARTO DE AMELIE"
			story.text = "A cama está desfeita. Sobre a mesa há fotografias e recortes de notícias.\n\nUma lanterna foi esquecida ao lado da janela."
			if not has_flashlight:
				_button("Pegar a lanterna", func(): has_flashlight = true; _go(4))
			if has_flashlight and not found_photo:
				_button("Examinar a fotografia antiga", func(): found_photo = true; _go(5))
			if has_flashlight and not found_notes:
				_button("Investigar os recortes de notícias", func(): found_notes = true; _go(6))
			if found_photo and found_notes:
				_button("Examinar a cama e procurar o diário", func(): _go(7))
		5:
			heading.text = "DUAS IRMÃS"
			story.text = "Na foto, duas crianças sorriem entre flores brancas.\n\nNo verso, a letra de Amelie: 'Eu ainda sinto sua falta, Catherine.'\n\nCatherine fica em silêncio."
			_button("Voltar a investigar", func(): _go(4))
		6:
			heading.text = "RECORTES"
			story.text = "As páginas falam da morte do namorado de Amelie. Há datas circuladas e perguntas escritas à mão.\n\n'Eu queria estar errada. Se ela descobrir que eu sei...'\n\nO nome da suspeita foi arrancado."
			_button("Voltar a investigar", func(): _go(4))
		7:
			heading.text = "PASSOS NO CORREDOR"
			story.text = "Você encontra um diário debaixo do colchão.\n\nEntão, passos pesados se aproximam. A maçaneta começa a girar.\n\nCatherine: 'Mave, ESCONDE!'"
			_button("Esconder-se no guarda-roupa", func(): choice_hide = "guarda-roupa"; _go(8))
			_button("Esconder-se debaixo da cama", func(): choice_hide = "cama"; _go(8))
		8:
			heading.text = "NÃO FAÇA BARULHO"
			story.text = "Você prende a respiração no seu esconderijo: " + choice_hide + ".\n\nUma sombra atravessa o quarto. Algo arranha o chão.\n\nO silêncio parece durar uma eternidade."
			_button("Esperar até os passos desaparecerem", func(): found_diary = true; _go(9))
		9:
			heading.text = "O DIÁRIO"
			story.text = "Catherine segura seu braço e conduz você para fora da casa.\n\nJá no carro, você abre o diário. Entre as páginas, encontra uma frase escrita com força:\n\n'NÃO CONFIE NA CATHERINE.'"
			_button("Continuar", func(): _go(10))
		10:
			heading.text = "FIM DO CAPÍTULO 1"
			story.text = "Catherine: 'O que foi, Mave? Parece que viu um fantasma.'\n\nA estrada desaparece sob a chuva.\n\nDEAR AMELIE\nContinua..."
			_button("Jogar novamente", func(): _restart())
	status.text = "WASD: disponível nas fases 3D • Aqui: escolha as ações com o mouse   |   Pistas: %d/2" % [int(found_photo) + int(found_notes)]

func _restart() -> void:
	has_key = false
	has_flashlight = false
	found_photo = false
	found_notes = false
	found_diary = false
	choice_hide = ""
	_go(0)
