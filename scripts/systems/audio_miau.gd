extends Node

const SAMPLE_RATE := 22050
const NOTE_DURATION := 0.30
const MUSIC_NOTES := [220.0, 262.0, 330.0, 392.0, 330.0, 294.0, 247.0, 330.0]

var music_player: AudioStreamPlayer
var sfx_streams: Dictionary = {}
var quitting := false


func _ready() -> void:
	get_tree().auto_accept_quit = false
	get_tree().root.close_requested.connect(quit_game)
	music_player = AudioStreamPlayer.new()
	music_player.stream = _make_music()
	add_child(music_player)

	sfx_streams = {
		"jump": _make_effect([Vector3(440.0, 0.16, 0.10), Vector3(660.0, 0.12, 0.07)]),
		"land": _make_effect([Vector3(180.0, 0.10, 0.12)]),
		"fall": _make_effect([Vector3(260.0, 0.18, 0.10), Vector3(130.0, 0.28, 0.10)]),
		"click": _make_effect([Vector3(520.0, 0.08, 0.08)]),
		"win": _make_effect([Vector3(392.0, 0.18, 0.10), Vector3(523.0, 0.18, 0.10), Vector3(659.0, 0.30, 0.10)]),
	}


func _exit_tree() -> void:
	_stop_all()
	music_player = null


func quit_game() -> void:
	if quitting:
		return
	quitting = true
	_stop_all()
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit()


func _stop_all() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null
	sfx_streams.clear()


func play_music() -> void:
	if quitting:
		return
	if not music_player.playing:
		music_player.play()


func stop_music() -> void:
	music_player.stop()


func play_sfx(event_name: String) -> void:
	if quitting:
		return
	var stream: AudioStreamWAV = sfx_streams.get(event_name)
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()


func _make_music() -> AudioStreamWAV:
	var samples_per_note := roundi(SAMPLE_RATE * NOTE_DURATION)
	var sample_count := samples_per_note * MUSIC_NOTES.size()
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var phase := 0.0

	for index in range(sample_count):
		var note_index := int(index / samples_per_note)
		var frequency: float = MUSIC_NOTES[note_index]
		var edge_fade := minf(1.0, minf(float(index) / 110.0, float(sample_count - index - 1) / 110.0))
		var sample := sin(phase) * 0.025 * edge_fade
		data.encode_s16(index * 2, roundi(sample * 32767.0))
		phase += TAU * frequency / float(SAMPLE_RATE)

	var stream := _make_wav(data)
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = sample_count
	return stream


func _make_effect(tones: Array) -> AudioStreamWAV:
	var duration := 0.0
	for tone: Vector3 in tones:
		duration = maxf(duration, tone.y)

	var sample_count := ceili(duration * SAMPLE_RATE)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for index in range(sample_count):
		var elapsed := float(index) / float(SAMPLE_RATE)
		var sample := 0.0
		for tone: Vector3 in tones:
			if elapsed < tone.y:
				var envelope := (tone.y - elapsed) / tone.y
				sample += sin(TAU * tone.x * elapsed) * tone.z * envelope
		data.encode_s16(index * 2, roundi(clampf(sample, -1.0, 1.0) * 32767.0))

	return _make_wav(data)


func _make_wav(data: PackedByteArray) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.data = data
	return stream
