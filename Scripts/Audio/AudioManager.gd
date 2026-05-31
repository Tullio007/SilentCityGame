extends Node

# =====================================================
# 🎵 PLAYERS
# =====================================================

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer


func _ready():
	bgm_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()

	add_child(bgm_player)
	add_child(sfx_player)

	bgm_player.volume_db = -8
	sfx_player.volume_db = 0


# =====================================================
# 🎵 BGM
# =====================================================

func play_bgm(stream: AudioStream):
	if stream == null:
		return

	if bgm_player.stream == stream and bgm_player.playing:
		return

	bgm_player.stream = stream
	bgm_player.play()


func stop_bgm():
	bgm_player.stop()


func pause_bgm():
	if bgm_player.playing:
		bgm_player.stream_paused = true


func resume_bgm():
	if bgm_player.stream != null:
		bgm_player.stream_paused = false


# =====================================================
# 🎬 INTRO
# =====================================================

func play_intro_music():
	play_bgm(load(
		"res://assets/audio/music/intro/intro_theme.ogg"
	))


# =====================================================
# 🎮 FASES
# =====================================================

func play_phase_music(phase: int):
	var path = ""

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
			path = "res://assets/audio/music/phases/phase_1_theme.ogg"

	play_bgm(load(path))


# =====================================================
# 🏁 CRÉDITOS / GAME OVER
# =====================================================

func play_credits_music():
	play_bgm(load(
		"res://assets/audio/music/endings/credits_theme.ogg"
	))


func play_game_over_music():
	play_bgm(load(
		"res://assets/audio/music/defeat/lumi_died_theme.ogg"
	))


# =====================================================
# 🔊 SFX BASE
# =====================================================

func play_sfx(stream: AudioStream):
	if stream == null:
		return

	sfx_player.stream = stream
	sfx_player.play()


# =====================================================
# 🌎 WORLD
# =====================================================

func play_horde_complete():
	play_sfx(load(
		"res://assets/audio/sfx/world/horde_complete.ogg"
	))


func play_door_open():
	play_sfx(load(
		"res://assets/audio/sfx/world/door_open.ogg"
	))


# =====================================================
# 👾 MOB DINO
# =====================================================

func play_mob1_attack():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob1/attack.ogg"
	))


func play_mob1_death():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob1/death.ogg"
	))


# =====================================================
# 👾 MOB GOBLIN
# =====================================================

func play_mob2_attack():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob2/attack.ogg"
	))


func play_mob2_death():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob2/death.ogg"
	))


# =====================================================
# 👾 MOB INSETO
# =====================================================

func play_mob3_attack():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob3/attack.ogg"
	))


func play_mob3_death():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/mob3/death.ogg"
	))


# =====================================================
# 👑 NOX
# =====================================================

func play_nox_attack():
	play_sfx(load(
		"res://assets/audio/sfx/enemies/nox/attack.ogg"
	))


func play_nox_defeat():
	play_sfx(load(
		"res://assets/audio/sfx/world/horde_complete.ogg"
	))


# =====================================================
# 🤖 LUMI
# =====================================================

func play_lumi_attack():
	play_sfx(load(
		"res://assets/audio/sfx/lumi/attack.ogg"
	))


func play_lumi_hurt():
	play_sfx(load(
		"res://assets/audio/sfx/lumi/hurt.ogg"
	))


func play_item_pickup():
	play_sfx(load(
		"res://assets/audio/sfx/lumi/item_pickup.ogg"
	))


func play_health_pickup():
	play_sfx(load(
		"res://assets/audio/sfx/lumi/health_pickup.ogg"
	))


# =====================================================
# 🖱️ UI
# =====================================================

func play_button_click():
	play_sfx(load(
		"res://assets/audio/sfx/ui/button_click.ogg"
	))


func play_dialogue_skip():
	play_sfx(load(
		"res://assets/audio/sfx/ui/dialogue_skip.ogg"
	))
