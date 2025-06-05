extends Node2D

const CARD_DRAW_SPEED = 0.5
const CARD_SCENE_PATH = "res://Scenes/OpponentCard.tscn"
const STARTING_HAND_SIZE = 3

var opponent_deck = ["trallalleroTrallala", "trallalleroTrallala", "bombardiroCrocodilo", "brbrPatapim", "brbrPatapim", "scimpanziniBananini", "scimpanziniBananini", "trippiTroppi", "trippiTroppi", "tungtungSahur", "tungtungSahur", "vaccaSaturno"]
var card_database_reference

func _ready() -> void:
	opponent_deck.shuffle()
	$RichTextLabel.text = str(opponent_deck.size())

	var CardDatabase = load("res://Scripts/CardDatabase.gd")
	card_database_reference = CardDatabase.new()  

	for i in range(STARTING_HAND_SIZE):
		draw_card()

func draw_card():
	var card_drawn_name = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)  

	if opponent_deck.size() == 0:
		$Sprite2D.visible = false
		$RichTextLabel.visible = false

	$RichTextLabel.text = str(opponent_deck.size())

	var card_scene = preload(CARD_SCENE_PATH) 
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://carte/" + card_drawn_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.attack = card_database_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Attack").text = "%s ⚔️" % new_card.attack
	new_card.health = card_database_reference.CARDS[card_drawn_name][1]
	new_card.get_node("Health").text = "%s ❤️" % new_card.health
	new_card.card_type = card_database_reference.CARDS[card_drawn_name][2]

	$"../CardManager".add_child(new_card)
	new_card.name = "Card"

	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
