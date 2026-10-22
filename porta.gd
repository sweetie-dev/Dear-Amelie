extends Node3D

@onready var som_porta = $AudioStreamPlayer

var opened = false

func toggle_door():
	if $AnimationPlayer.current_animation != "open" and $AnimationPlayer.current_animation != "close":

		opened = !opened

		# Toca o som da porta
		som_porta.play()

		if !opened:
			$AnimationPlayer.play("close")

		if opened:
			$AnimationPlayer.play("open")
