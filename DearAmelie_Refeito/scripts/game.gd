extends Control
## Dear Amelie - vertical slice sem arquivos externos (Godot 4.6).
## Cenas: menu, jardim, corredor, quarto, carro, floresta, lirios, clinica.
const W := 1280.0
const H := 720.0
const C_BG := Color("#0c111b")
const C_FLOOR := Color("#252a36")
const C_WALL := Color("#414251")
const C_LIGHT := Color("#e7d7cb")
const C_ACCENT := Color("#d2a8c9")
const C_DANGER := Color("#ad5060")

var stage := -1
var player := Vector2(240, 440)
var shadow := Vector2(115, 360)
var dialogue := ""
var dialogue_title := ""
var choice := ""
var key_found := false
var flashlight := false
var photo := false
var notes := false
var diary := false
var hide_place := ""
var chase_time := 0.0
var scene_time := 0.0
var ending := false

func _ready() -> void:
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	scene_time += delta
	if dialogue != "" or choice != "" or stage == -1 or stage == 7:
		queue_redraw()
		return
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		dir.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		dir.y += 1.0
	var speed := 205.0
	if stage == 5 and Input.is_key_pressed(KEY_SHIFT):
		speed = 325.0
	player += dir.normalized() * speed * delta
	player.x = clampf(player.x, 68.0, W - 68.0)
	player.y = clampf(player.y, 165.0, H - 82.0)
	if stage == 5:
		chase_time += delta
		shadow = shadow.move_toward(player, 128.0 * delta)
		if shadow.distance_to(player) < 35.0:
			player = Vector2(240, 440)
			shadow = Vector2(115, 360)
			_say("Mave", "A sombra quase me alcançou... Preciso correr! Segure SHIFT.")
		elif player.x > 1110.0 and chase_time > 2.0:
			_enter(6)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return
	var k: int = event.keycode
	if stage == -1:
		if k == KEY_ENTER or k == KEY_SPACE:
			_enter(0)
			_say("Catherine", "A casa está logo adiante, Mave. Precisamos descobrir o que houve com Amelie.")
		return
	if stage == 7:
		if k == KEY_R:
			_restart()
		return
	if choice != "":
		if k == KEY_1 or k == KEY_2:
			_resolve_choice(1 if k == KEY_1 else 2)
		return
	if dialogue != "":
		if k == KEY_ENTER or k == KEY_SPACE or k == KEY_E:
			dialogue = ""
			dialogue_title = ""
		return
	if k == KEY_E:
		_interact()

func _enter(new_stage: int) -> void:
	stage = new_stage
	scene_time = 0.0
	dialogue = ""
	dialogue_title = ""
	choice = ""
	match stage:
		0: player = Vector2(235, 440)
		1: player = Vector2(190, 440)
		2: player = Vector2(190, 460)
		3: player = Vector2(220, 450)
		4: player = Vector2(220, 440)
		5:
			player = Vector2(230, 430)
			shadow = Vector2(100, 370)
			chase_time = 0.0
			_say("Mave", "O carro parou. Catherine sumiu... Algo está vindo atrás de mim! Preciso correr até o fim da trilha.")
		6:
			player = Vector2(210, 450)
			_say("Mave", "Lírios brancos... Amelie sempre gostou dessas flores.")
		7: ending = true
	queue_redraw()

func _say(who: String, words: String) -> void:
	dialogue_title = who
	dialogue = words
	queue_redraw()

func _near(point: Vector2, distance: float = 95.0) -> bool:
	return player.distance_to(point) <= distance

func _interact() -> void:
	match stage:
		0:
			if _near(Vector2(400, 520)):
				key_found = true
				_say("Mave", "Encontrei uma chave enferrujada sob o vaso. Catherine: 'Você sempre foi boa em esconder as coisas.'")
			elif _near(Vector2(1000, 345)):
				if key_found:
					_enter(1)
					_say("Catherine", "A porta abriu... O quarto dela fica no fim do corredor.")
				else:
					choice = "A porta está trancada. 1: procurar a chave | 2: pedir que Catherine force a porta"
			else:
				_say("Mave", "Preciso procurar a chave nos vasos e depois entrar na casa.")
		1:
			if _near(Vector2(1060, 360)):
				_enter(2)
				_say("Mave", "O quarto de Amelie... Tudo está coberto de poeira.")
			else:
				_say("Catherine", "Não faça barulho. Siga até a porta iluminada.")
		2:
			if _near(Vector2(370, 520)) and not flashlight:
				flashlight = true
				_say("Mave", "Uma lanterna! Agora posso examinar os objetos do quarto.")
			elif not flashlight:
				_say("Mave", "Está escuro demais. Preciso da lanterna perto da janela.")
			elif _near(Vector2(450, 310)):
				photo = true
				_say("Amelie (verso da foto)", "Eu ainda sinto sua falta, Catherine. Nunca esqueci nossas tardes entre os lírios.")
			elif _near(Vector2(820, 315)):
				notes = true
				_say("Diário de investigação", "O caso do meu namorado não faz sentido. Uma pessoa próxima mentiu sobre aquela noite. Se ela souber que desconfio...")
			elif _near(Vector2(1050, 510)):
				if photo and notes:
					diary = true
					choice = "Passos se aproximam! 1: esconder no guarda-roupa | 2: esconder debaixo da cama"
				else:
					_say("Mave", "Há algo sob o colchão, mas primeiro preciso entender as pistas na mesa.")
			else:
				_say("Mave", "Preciso examinar a foto, as anotações e a cama.")
		3:
			if _near(Vector2(1050, 400)):
				_enter(4)
				_say("Mave", "No carro, abri o diário. Na última página, havia um aviso: NÃO CONFIE NA CATHERINE.")
			else:
				_say("Catherine", "A coisa foi embora. Saia da casa, depressa!")
		4:
			if _near(Vector2(1030, 370)):
				_enter(5)
			else:
				_say("Catherine", "Parece que você viu um fantasma, Mave. Vamos continuar pela estrada.")
		5:
			_say("Mave", "Corra para a direita! SHIFT aumenta a velocidade.")
		6:
			if _near(Vector2(980, 360)):
				_enter(7)
			else:
				_say("Catherine", "Eu não estava tentando encontrar minha irmã, Mave. Eu queria que você se lembrasse de onde a deixou.")

func _resolve_choice(n: int) -> void:
	var current := choice
	choice = ""
	if stage == 0:
		if n == 1:
			_say("Mave", "Vou procurar entre os vasos próximos ao portão.")
		else:
			_enter(1)
			_say("Catherine", "CRAC! A porta cedeu. O barulho ecoou pela casa inteira...")
	elif stage == 2:
		hide_place = "guarda-roupa" if n == 1 else "embaixo da cama"
		_enter(3)
		_say("Mave", "Me escondi " + hide_place + ". Uma sombra entrou, arrastando os pés. Não ouso respirar.")

func _restart() -> void:
	key_found = false
	flashlight = false
	photo = false
	notes = false
	diary = false
	hide_place = ""
	ending = false
	_enter(-1)

func _font() -> Font:
	return ThemeDB.fallback_font

func _txt(value: String, x: float, y: float, size: int = 22, color: Color = C_LIGHT) -> void:
	draw_string(_font(), Vector2(x, y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func _rect(x: float, y: float, w: float, h: float, color: Color) -> void:
	draw_rect(Rect2(x, y, w, h), color)

func _object(pos: Vector2, color: Color, name: String) -> void:
	draw_circle(pos, 25.0, color)
	_txt(name, pos.x - 54.0, pos.y - 38.0, 16, C_LIGHT)
	if player.distance_to(pos) < 95.0:
		draw_arc(pos, 34.0, 0.0, TAU, 32, C_ACCENT, 3.0)
		_txt("[E]", pos.x - 14.0, pos.y + 55.0, 19, C_ACCENT)

func _draw() -> void:
	_rect(0, 0, W, H, C_BG)
	for i in range(26):
		var x := float(i) * 55.0
		draw_line(Vector2(x, 140), Vector2(x - 60, 690), Color("#202635"), 1.0)
	_txt("D E A R   A M E L I E", 45, 58, 32, C_ACCENT)
	draw_line(Vector2(42, 77), Vector2(1238, 77), C_WALL, 2.0)
	if stage == -1:
		_txt("UM MISTÉRIO SOBRE MEMÓRIA E AUSÊNCIA", 285, 280, 28)
		_txt("Uma amiga desaparecida. Uma casa abandonada. Um passado enterrado.", 200, 345, 22)
		_txt("PRESSIONE ENTER PARA COMEÇAR", 408, 480, 27, C_ACCENT)
		return
	if stage == 7:
		_txt("EPÍLOGO • A ÚLTIMA SESSÃO", 390, 180, 29, C_ACCENT)
		_txt("Psicóloga: 'Você disse que Catherine estava com você?'", 200, 275, 22)
		_txt("Mave: 'Ela me levou até Amelie. Ela viu tudo.'", 200, 320, 22)
		_txt("Psicóloga: 'Mave... Catherine morreu quando vocês eram crianças.'", 200, 365, 22)
		_txt("O silêncio toma a sala. Na cadeira ao lado, ninguém está sentado.", 200, 410, 21)
		_txt("FIM DA DEMONSTRAÇÃO  •  PRESSIONE R PARA RECOMEÇAR", 215, 575, 22, C_ACCENT)
		return
	_rect(50, 140, 1180, 510, C_FLOOR)
	draw_rect(Rect2(50, 140, 1180, 510), C_WALL, false, 8.0)
	var titles := ["JARDIM • A CHAVE", "CORREDOR", "QUARTO DE AMELIE", "FUGA DA CASA", "ESTRADA", "FLORESTA • PERSEGUIÇÃO", "JARDIM DE LÍRIOS"]
	_txt(titles[stage], 76, 185, 23, C_ACCENT)
	match stage:
		0:
			_rect(870, 230, 300, 290, Color("#393b46"))
			_rect(950, 290, 115, 200, Color("#171824"))
			_object(Vector2(400, 520), Color("#70805e"), "VASOS")
			_object(Vector2(1000, 345), Color("#aa9279"), "PORTA")
		1:
			for x in [330, 570, 810]:
				_rect(x, 240, 90, 240, Color("#363443"))
			_object(Vector2(1060, 360), Color("#c7ad83"), "QUARTO")
		2:
			_rect(280, 245, 220, 110, Color("#454153"))
			_rect(720, 235, 240, 120, Color("#55505b"))
			_rect(950, 450, 190, 135, Color("#363443"))
			if not flashlight:
				_object(Vector2(370, 520), Color("#e8d494"), "LANTERNA")
			_object(Vector2(450, 310), Color("#9b7b91"), "FOTOGRAFIA")
			_object(Vector2(820, 315), Color("#b9a187"), "RECORTES")
			_object(Vector2(1050, 510), Color("#8d6b83"), "CAMA")
		3:
			_object(Vector2(1050, 400), Color("#d1a28e"), "SAÍDA")
		4:
			_rect(750, 270, 340, 220, Color("#3b404d"))
			_object(Vector2(1030, 370), Color("#bd9fa1"), "ESTRADA")
		5:
			for x in [200, 390, 610, 850, 1050]:
				_rect(x, 205, 24, 350, Color("#303d3b"))
				draw_circle(Vector2(x + 12, 235), 58, Color("#31423d"))
			draw_circle(shadow, 29, C_DANGER)
			_txt("SOMBRA", shadow.x - 36, shadow.y - 45, 16, C_DANGER)
			_txt("FUJA PARA A DIREITA • SEGURE SHIFT", 705, 625, 20, C_ACCENT)
		6:
			for x in [350, 470, 590, 720, 845, 1050]:
				draw_circle(Vector2(x, 510), 16, Color("#f2e7dd"))
				draw_line(Vector2(x, 525), Vector2(x, 580), Color("#5c7960"), 3)
			_object(Vector2(980, 360), Color("#ded0d4"), "DESCOBERTA")
	draw_circle(player + Vector2(0, 10), 19.0, Color("#11131b"))
	draw_circle(player, 17.0, Color("#d5bac4"))
	draw_circle(player + Vector2(0, -14), 12.0, Color("#4b3b49"))
	_txt("MAVE", player.x - 24, player.y - 36, 15, C_LIGHT)
	_txt("WASD/SETAS: mover   E: interagir   ENTER: avançar   SHIFT: correr", 68, 687, 17, C_LIGHT)
	if dialogue != "" or choice != "":
		_rect(125, 452, 1030, 207, Color("#11131e"))
		draw_rect(Rect2(125, 452, 1030, 207), C_ACCENT, false, 2.0)
		if choice != "":
			_txt("ESCOLHA", 160, 495, 22, C_ACCENT)
			_draw_wrapped(choice, 160, 539, 60)
			_txt("PRESSIONE 1 OU 2", 160, 628, 18, C_ACCENT)
		else:
			_txt(dialogue_title.to_upper(), 160, 495, 22, C_ACCENT)
			_draw_wrapped(dialogue, 160, 533, 65)
			_txt("ENTER / E PARA CONTINUAR", 160, 628, 17, C_ACCENT)

func _draw_wrapped(value: String, x: float, y: float, limit: int) -> void:
	var words := value.split(" ")
	var line := ""
	var offset := 0
	for word in words:
		if line.length() + word.length() > limit:
			_txt(line, x, y + offset * 29, 19)
			line = ""
			offset += 1
		line += word + " "
	if line != "":
		_txt(line, x, y + offset * 29, 19)
