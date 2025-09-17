extends Node

const bg_mus = preload("res://audio/puzzle-game-background.mp3")
const pick_up = preload("res://audio/Wood Block1.ogg")
const place = preload("res://audio/Wood Block2.ogg")
const click = preload("res://audio/Minimalist7.ogg")
const win = preload("res://audio/African4.ogg")
const lose = preload("res://audio/Retro11.ogg")

enum SFX {
    PICK_UP,
    PLACE,
    CLICK,
    WIN,
    LOSE
}

var bg_music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
func _ready() -> void:
    bg_music_player = AudioStreamPlayer.new()
    bg_music_player.stream = bg_mus
    bg_music_player.stream.loop = true
    bg_music_player.autoplay = true
    bg_music_player.bus = "Music"
    var bg_fade_in = create_tween()
    bg_fade_in.tween_property(bg_music_player, "volume_db", 0, 2.0).from(-20)
    add_child(bg_music_player)

    sfx_player = AudioStreamPlayer.new()
    sfx_player.bus = "SFX"
    sfx_player.max_polyphony = 5
    add_child(sfx_player)

func play_sfx(sfx: SFX) -> void:
    match sfx:
        SFX.PICK_UP:
            sfx_player.stream = pick_up
            sfx_player.volume_db = 10
        SFX.PLACE:
            sfx_player.stream = place
            sfx_player.volume_db = 20
        SFX.CLICK:
            sfx_player.stream = click
            sfx_player.volume_db = 25
        SFX.WIN:
            sfx_player.stream = win
            sfx_player.volume_db = 25
        SFX.LOSE:
            sfx_player.stream = lose
            sfx_player.volume_db = 30
    sfx_player.play()