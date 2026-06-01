extends Node

# =====================================================
# 🎵 CONFIG
# =====================================================

const SFX_POOL_SIZE := 8

const MUSIC_BASE := "res://Assets/Audio/Music/"
const SFX_BASE := "res://Assets/Audio/SFX/"

# =====================================================
# 🎵 PLAYERS
# =====================================================

var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []

# =====================================================
# 🎵 CACHE
# =====================================================

var audio_cache := {}

# =====================================================
# 🚀 INIT
# =====================================================

func _ready():
	_setup_bgm_player()
	_setup_sfx_pool()


func _setup_bgm_player():
	bgm_player = AudioStreamPlayer.new()

	bgm_player.bus = "Music"
	bgm_player.volume_db = -8

	add_child(bgm_player)


func _setup_sfx_pool():
	for i in range(SFX_POOL_SIZE):
		var player := AudioStreamPlayer.new()

		player.bus = "SFX"
		player.volume_db = 0

		add_child(player)
		sfx_players.append(player)

# =====================================================
# 📦 RESOURCE CACHE
# =====================================================

func get_audio(path: String) -> AudioStream:
	if audio_cache.has(path):
		return audio_cache[path]

	var stream := load(path)

	if stream == null:
		push_error("AudioManager: arquivo não encontrado -> " + path)
		return null

	audio_cache[path] = stream
	return stream

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


func play_bgm_path(path: String):
	play_bgm(get_audio(path))


func stop_bgm():
	bgm_player.stop()


func pause_bgm():
	if bgm_player.playing:
		bgm_player.stream_paused = true


func resume_bgm():
	if bgm_player.stream_paused:
		bgm_player.stream_paused = false

# =====================================================
# 🎬 INTRO
# =====================================================

func play_intro_music():
	play_bgm_path(
		MUSIC_BASE + "Intro/intro_theme.ogg"
	)

# =====================================================
# 🎮 FASES
# =====================================================

func play_phase_music(phase: int):
	var path := ""

	match phase:
		1:
			path = MUSIC_BASE + "Phases/phase_1_theme.ogg"
		2:
			path = MUSIC_BASE + "Phases/phase_2_theme.ogg"
		3:
			path = MUSIC_BASE + "Phases/phase_3_theme.ogg"
		4:
			path = MUSIC_BASE + "Phases/phase_4_theme.ogg"
		_:
			path = MUSIC_BASE + "Phases/phase_1_theme.ogg"

	play_bgm_path(path)

# =====================================================
# 🏁 CRÉDITOS / GAME OVER
# =====================================================

func play_credits_music():
	play_bgm_path(
		MUSIC_BASE + "Endings/credits_theme.ogg"
	)


func play_game_over_music():
	play_bgm_path(
		MUSIC_BASE + "Defeat/lumi_died_theme.ogg"
	)

# =====================================================
# 🔊 SFX CORE
# =====================================================

func get_free_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player

	return sfx_players[0]


func play_sfx(stream: AudioStream):
	if stream == null:
		return

	var player := get_free_sfx_player()

	player.stream = stream
	player.play()


func play_sfx_path(path: String):
	play_sfx(get_audio(path))

# =====================================================
# 🌎 WORLD
# =====================================================

func play_horde_complete():
	play_sfx_path(
		SFX_BASE + "World/horde_complete.ogg"
	)


func play_door_open():
	play_sfx_path(
		SFX_BASE + "World/door_open.ogg"
	)

# =====================================================
# 👾 MOB DINO
# =====================================================

func play_mob1_attack():
	play_sfx_path(
		SFX_BASE + "Enemies/mob1/attack.ogg"
	)


func play_mob1_death():
	play_sfx_path(
		SFX_BASE + "Enemies/mob1/death.ogg"
	)

# =====================================================
# 👾 MOB GOBLIN
# =====================================================

func play_mob2_attack():
	play_sfx_path(
		SFX_BASE + "Enemies/mob2/attack.ogg"
	)


func play_mob2_death():
	play_sfx_path(
		SFX_BASE + "Enemies/mob2/death.ogg"
	)

# =====================================================
# 👾 MOB INSETO
# =====================================================

func play_mob3_attack():
	play_sfx_path(
		SFX_BASE + "Enemies/mob3/attack.ogg"
	)


func play_mob3_death():
	play_sfx_path(
		SFX_BASE + "Enemies/mob3/death.ogg"
	)

# =====================================================
# 👑 NOX
# =====================================================

func play_nox_attack():
	play_sfx_path(
		SFX_BASE + "Enemies/nox/attack.ogg"
	)


func play_nox_defeat():
	play_sfx_path(
		SFX_BASE + "World/horde_complete.ogg"
	)

# =====================================================
# 🤖 LUMI
# =====================================================

func play_lumi_attack():
	play_sfx_path(
		SFX_BASE + "Lumi/attack.ogg"
	)


func play_lumi_hurt():
	play_sfx_path(
		SFX_BASE + "Lumi/hurt.ogg"
	)


func play_item_pickup():
	play_sfx_path(
		SFX_BASE + "Lumi/item_pickup.ogg"
	)


func play_health_pickup():
	play_sfx_path(
		SFX_BASE + "Lumi/health_pickup.ogg"
	)

# =====================================================
# 🖱️ UI
# =====================================================

func play_button_click():
	play_sfx_path(
		SFX_BASE + "UI/button_click.ogg"
	)


func play_dialogue_skip():
	play_sfx_path(
		SFX_BASE + "UI/dialogue_skip.ogg"
	)
