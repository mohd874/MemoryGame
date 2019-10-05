extends Node2D

signal pair_found
signal card_revealed2
signal back_to_level_select

var card_face
var card_back
var init
var number_of_matches
var default_image
var images: Array = []
var cards: Array = []

var last_try_was_pair
var card_one_checked_if_pairing
var card_two_checked_if_pairing
var card_one_string
var card_two_string

var random_card
var card_number

var cols
var rows
var number_of_pairs
var number_of_tries

var card_scene

var level: Dictionary

var sprites_base_dir = 'res://sprites/cards/'

var paired_cards = []

var sound_player

func _ready():
    self.connect("card_revealed", self, "card_revealed2")
    number_of_matches = 0
    card_one_string = "Card 1"
    card_two_string = "Card 2"
    last_try_was_pair = false
    default_image = preload("res://sprites/cards/box.png")
    card_scene = preload('res://scenes/CardScene2.tscn')
    
#    $ScoreBoard.position.x = ProjectSettings.get_setting("display/window/size/test_width")/2
#    $ScoreBoard.position.y = ProjectSettings.get_setting("display/window/size/test_height")/2
    
    print($ScoreBoard.position)
#	sound_scene = preload('res://scenes/SoundScene.tscn').instance()
#
#	add_child(sound_scene)

func reset_game():
    for c in cards:
        self.remove_child(c)
        get_tree().queue_delete(c)
    
    number_of_tries = 0
    images.clear()
    $ScoreBoard.reset()
    

func init_game(level: Dictionary):
    reset_game()
    self.level = level
    
#    _load_game_config()
    
    _load_images_config()
    
    randomize()
    init = false

    _shuffle_cards()
    _enable_all_cards_clicks()
    
func _load_images_config():
    cols = level.get('size').cols
    rows = level.get('size').rows
    number_of_pairs = cols * rows / 2
    for pair in level.pairs:
        var img_a_file = pair.a
        var img_b_file = pair.b
        var img_name = pair.name
#        print(sprites_base_dir+img_a_file)
        images.append([load(sprites_base_dir+img_a_file), img_name])
        images.append([load(sprites_base_dir+img_b_file), img_name])
        
#	var file = File.new()
#	file.open("res:///resources/images_names", File.READ) 
#	var content = file.get_as_text()
#	file.close()
#
#	for line in content.split('\n'):
#		if len(line) < 1:
#			continue
#
#		var img_file_name = line.split('<>')[0]
#		var img_desc = line.split('<>')[1]
#
#		images.append([load(img_file_name), img_desc])

#func _load_game_config():	
#   pass
#	var file = File.new()
#	file.open("res:///resources/config.cfg", File.READ) 
#	var content = file.get_as_text()
#	file.close()
#
#	for line in content.split('\n'):
#		if 'cols' in line:
#			cols = int(line.split('=')[1])
#		if 'rows' in line:
#			rows = int(line.split('=')[1])

#
# Game Process
#

#func _process(delta):


func _shuffle_cards():
    add_cards_to_scene()
    randomize()
    
    var cards_num = cols * rows
    var half_cards = int(cards_num / 2)
    var all_remaining_cards = range(1,cards_num+1)
    var assigned_cards = []
    
    all_remaining_cards.shuffle()
    images.shuffle()
    
    var img_i2 = 0
    for i in all_remaining_cards:
        if img_i2 >= images.size():
            img_i2 = 0
            images.shuffle()
        _assign_card('Card'+str(i), images[img_i2])
        img_i2 += 1
    
#	for i in all_remaining_cards:		
#		var img_i = randi() % half_cards
#		while(assigned_cards.count(img_i) >= 2):
#			img_i = randi() % half_cards
#
#		_assign_card('Card'+str(i), images[img_i])
#		assigned_cards.append(img_i)
        
    init = true

func add_card(id):
    var card_inst = card_scene.instance()
    card_inst.set_name('Card'+str(id))
    card_inst._ready()
    card_inst.connect("card_revealed", self, "card_revealed")
#    card_inst.sound_player = sound_player
    add_child(card_inst)
    cards.append(card_inst)
    return card_inst
    
func add_cards_to_scene():
    var i = 1
    var center = get_node("Center")
    var card_scale = 0.3
    var card_width = 512
    var scaled_width = card_width * 0.3
    var card_height = 512
    
    var start_pos_w =  center.position.x - ((scaled_width * 1.2) * cols / 2)
    var start_pos_h =  center.position.y - ((scaled_width * 1.2) * rows / 2)
    
    for r in range(1, rows+1):
        for c in range(1, cols+1):
            var card = add_card(i)
            card.connect('input_event', card, '_input_event')
            card.position.x = start_pos_w + (scaled_width * 1.2) * c
            card.position.y = start_pos_h + (scaled_width * 1.2) * r
            
            i += 1
            

func _assign_card(node_id, data):
    var n = get_node(node_id)
    
    n.card_face = data[0]
    n.card_name = data[1]

func _check_if_pair():
    number_of_tries += 1
    if get_node("CardOneName").text == get_node("CardTwoName").text:
        get_node("CheckBox").text = "="
        last_try_was_pair = true
        number_of_matches += 1
        get_node("NumberOfMatches").text = "Number of Matches: " + str(number_of_matches)
        yield(_wait_for(1), "timeout")
#        sound_player.play_sound('hit') # TODO: change sound
        emit_signal("pair_found")
        for card in paired_cards:
            card.hide()
        
    if get_node("CardOneName").text != "Card 1" && get_node("CardTwoName").text != "Card 2":
        if get_node("CardOneName").text != get_node("CardTwoName").text:
            _disable_all_cards_clicks()
            get_node("CheckBox").text = "!="
            yield(_wait_for(1), "timeout")
            _reset_card_name_strings_and_check_box()
            _turn_around_cards()
            _enable_all_cards_clicks()
            paired_cards = []
    
    if number_of_matches == number_of_pairs:
        $ScoreBoard.display_score(number_of_pairs, number_of_tries)

func card_revealed():
    emit_signal("card_revealed2")

func _wait_for(sec):
    var waiting_timer = Timer.new()
    waiting_timer.set_wait_time(sec)
    waiting_timer.set_one_shot(true)
    self.add_child(waiting_timer)
    waiting_timer.start()
    return waiting_timer
    
func _reset_card_name_strings_and_check_box():
    get_node("CardOneName").text = card_one_string
    get_node("CardTwoName").text = card_two_string
    get_node("CheckBox").text = "?"

func _turn_around_cards():
    get_node(card_one_checked_if_pairing).get_node("Sprite").texture = default_image
    get_node(card_two_checked_if_pairing).get_node("Sprite").texture = default_image

func _disable_all_cards_clicks():
    for i in range(1, cols*rows+1):
        get_node("Card"+str(i)).click_enabled = false
        
func _enable_all_cards_clicks():
    for i in range(1, cols*rows+1):
        var n = get_node("Card"+str(i))
        if n.get_node("Sprite").texture == default_image:
            n.click_enabled = true
            
#func _on_BackToMenuButton_button_down():
#	init = false
##	get_tree().reload_current_scene()
#	var root = get_node(".")
#	print(root.name)
#	root._on_StartButton_pressed()
    


func _on_BackToMenuButton_pressed():
    emit_signal("back_to_level_select")
