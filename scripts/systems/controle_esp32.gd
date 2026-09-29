extends Node
class_name ControleESP32

## Recebe comandos UDP do ESP32 na mesma rede local.
## Exemplos de mensagens: LEFT=1, LEFT=0, RIGHT=1, JUMP=1, JUMP=0.

@export var listen_port: int = 4242

var socket: PacketPeerUDP = PacketPeerUDP.new()
var states: Dictionary = {"left": false, "right": false, "jump": false}
var last_packet_time: float = 0.0


func _ready() -> void:
	var result := socket.bind(listen_port)
	if result != OK:
		push_warning("Não foi possível abrir a porta UDP %d para o ESP32." % listen_port)


func _process(_delta: float) -> void:
	while socket.get_available_packet_count() > 0:
		var message := socket.get_packet().get_string_from_utf8().strip_edges().to_upper()
		_parse_message(message)

	if last_packet_time > 0.0 and Time.get_ticks_msec() / 1000.0 - last_packet_time > 2.0:
		states["left"] = false
		states["right"] = false
		states["jump"] = false


func is_action_pressed(action_name: String) -> bool:
	return states.get(action_name, false)


func _parse_message(message: String) -> void:
	last_packet_time = Time.get_ticks_msec() / 1000.0

	if message == "L":
		states["left"] = true
		return
	if message == "R":
		states["right"] = true
		return
	if message == "J":
		states["jump"] = true
		return

	var normalized := message.replace(":", "=")
	var parts := normalized.split("=")
	if parts.is_empty():
		return

	var action := parts[0].to_lower()
	if action == "l":
		action = "left"
	elif action == "r":
		action = "right"
	elif action == "j":
		action = "jump"

	if not states.has(action):
		return

	var pressed := true
	if parts.size() > 1:
		pressed = parts[1] in ["1", "ON", "DOWN", "PRESS", "PRESSED"]
	states[action] = pressed
