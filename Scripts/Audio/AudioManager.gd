extends Node

# 🎵 MUSIC (BGM)
var bgm_player: AudioStreamPlayer

# 🔊 SFX
var sfx_player: AudioStreamPlayer


func _ready():
	# cria players
	bgm_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()

	add_child(bgm_player)
	add_child(sfx_player)

	# volumes padrão
	bgm_player.volume_db = -8
	sfx_player.volume_db = 0


# 🎵 TOCAR MÚSICA DE FUNDO
func play_bgm(stream: AudioStream, loop: bool = true):
	if stream == null:
		return

	if bgm_player.stream == stream and bgm_player.playing:
		return

	bgm_player.stream = stream
	bgm_player.loop = loop
	bgm_player.play()


# ⛔ PARAR MÚSICA (MENU OU RESET)
func stop_bgm():
	bgm_player.stop()


# ⏸️ PAUSAR MÚSICA (MENU)
func pause_bgm():
	if bgm_player.playing:
		bgm_player.stream_paused = true


# ▶️ RETOMAR MÚSICA (MENU)
func resume_bgm():
	if bgm_player.stream != null:
		bgm_player.stream_paused = false


# 🔊 TOCAR SFX
func play_sfx(stream: AudioStream):
	if stream == null:
		return

	sfx_player.stream = stream
	sfx_player.play()


# 🎚️ VOLUME (OPCIONAL)
func set_bgm_volume(db: float):
	bgm_player.volume_db = db


func set_sfx_volume(db: float):
	sfx_player.volume_db = db


# 🎮 FASES (MÚSICA AUTOMÁTICA)
func play_phase_music(phase: int):
	var path := ""

	match phase:
		1:
			path = "res://assets/audio/music/phases/phase_1_theme.ogg"
		2:
			path = "res://assets/audio/music/phases/phase_2_theme.ogg"
		3:
			path = "res://assets/audio/music/phases/phase_3_theme.ogg"
		4:
			path = "res://assets/audio/music/phases/phase_4_theme.ogg"
		_:
			path = "res://assets/audio/music/phases/final_scene_theme.ogg"

	play_bgm(load(path))


# 🌊 HORDA COMEÇA
func play_horde_start():
	play_sfx(load("res://assets/audio/sfx/world/horde_start.wav"))


# ☠️ HORDA DERROTADA (FIM DA FASE)
func play_horde_cleared():
	play_sfx(load("res://assets/audio/sfx/world/horde_complete.wav"))


# 👑 NOX APARECE (BOSS FINAL)
func play_nox_intro():
	play_sfx(load("res://assets/audio/sfx/enemies/nox/attack.wav"))


# 💀 NOX DERROTADO (FINAL DO JOGO)
func play_nox_defeat():
	play_sfx(load("res://assets/audio/sfx/enemies/nox/death.wav"))


# 🎮 LUMI (PLAYER)
func play_lumi_attack():
	play_sfx(load("res://assets/audio/sfx/lumi/attack.wav"))

func play_lumi_hurt():
	play_sfx(load("res://assets/audio/sfx/lumi/hurt.wav"))

func play_item_pickup():
	play_sfx(load("res://assets/audio/sfx/lumi/item_pickup.wav"))

func play_health_pickup():
	play_sfx(load("res://assets/audio/sfx/lumi/health_pickup.wav"))


# 🖱️ UI
func play_button_click():
	play_sfx(load("res://assets/audio/sfx/ui/button_click.wav"))

func play_dialogue_skip():
	play_sfx(load("res://assets/audio/sfx/ui/dialogue_skip.wav"))


# 🚪 MUNDO
func play_door_open():
	play_sfx(load("res://assets/audio/sfx/world/door_open.wav"))

func play_item_collect():
	play_sfx(load("res://assets/audio/sfx/world/item_collect.wav"))
