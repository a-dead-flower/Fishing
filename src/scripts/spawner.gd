extends Node

const game = preload("res://src/scenes/game.tscn")

const sturgeon_entity = preload("res://res/fishes/sturgeon/sturgeon_entity.tscn")
const bass_entity = preload("res://res/fishes/bass/bass_entity.tscn")
const minnow_entity = preload("res://res/fishes/minnow/minnow_entity.tscn")
const zebra_entity = preload("res://res/fishes/zebra/zebra_entity.tscn")
const ruby_entity = preload("res://res/fishes/ruby/ruby_entity.tscn")
const sapp_entity = preload("res://res/fishes/sapp/sapp_entity.tscn")
const chub_entity = preload("res://res/fishes/chub/chub_entity.tscn")
const perch_entity = preload("res://res/fishes/perch/perch_entity.tscn")
const neon_entity = preload("res://res/fishes/neon/neon_entity.tscn")

var rng = RandomNumberGenerator.new()
var new_best = false
var new_fish = false
var current_fish
var entity_fish

var fish_name
var fish_size
var fish_token
var fish_array

var rarities = {
	"Common"     : 4000,
	"Uncommon"   : 2000,
	"Rare"       : 800,
	"Epic"       : 300,
	"Legendary"  : 50,
	"Mythic"     : 10,
	}

#region LOGIC

## Function called to start minigame
func start_game():
	current_fish = generate()
	entity_fish = current_fish.instantiate()
	var child = game.instantiate()
	child.fish_name = entity_fish.name
	add_child(child)


## Function to create the fish after game
func create_fish():
	Globals.stop_cast = true
	entity_fish.position = get_node("/root/Scene/Player/Sprite/Cursor").position
	add_child(entity_fish)
	check_bestiary()
	if new_best: entity_fish.get_node("Box/Control/Panel/Best").visible = true
	if new_fish: entity_fish.get_node("Box/Control/Panel/Best/Label").text = "New Fish!"

## Weighted rarity finder
func get_rarity():
	return "Common"
	rng.randomize()
	var weighted = 0
	for n in rarities: weighted += rarities[n]
	var item = rng.randi_range(0,weighted)
	for n in rarities:
		if item <= rarities[n]:
			return n
		item -= rarities[n]

#endregion

#region GENERATE

## Generate new fish
func generate():
	var type = get_rarity()
	
	## Common fish
	if type == "Common":
		var fish = rng.randi_range(1, 6)
		if fish == 1: return minnow()
		elif fish == 2: return ruby()
		elif fish == 3: return sapp()
		elif fish == 4: return perch()
		elif fish == 5: return neon()
		elif fish == 6: return chub()
		
	## Uncommon fish
	if type == "Uncommon":
		var fish = rng.randi_range(1, 1)
		if fish == 1: return bass()
		
	## Rare fish
	if type == "Rare":
		var fish = rng.randi_range(1, 1)
		if fish == 1: return sturgeon()
		
	## Epic fish
	if type == "Epic":
		var fish = rng.randi_range(1, 1)
		if fish == 1: return zebra()
		
	## Legendary fish
	if type == "Legendary":
		var _fish = rng.randi_range(1, 1)
		return bass()
		
	## Mythic fish
	if type == "Mythic":
		var _fish = rng.randi_range(1, 1)
		return bass()


## Check if caught fish
func check_bestiary():
	new_best = false
	new_fish = false
	for i in fish_array:
		if i [0] == fish_name:
			i[2] = i[2] + 1
			var bsize = str(i[1]).split(fish_token)
			if float(bsize[0]) < snapped(fish_size,0.1):
				i[1] = str(snapped(fish_size,0.1),fish_token)
				new_best = true
			return
	fish_array.append([fish_name,str(snapped(fish_size,0.1),fish_token),1])
	new_fish = true
	new_best = true

#endregion

#region FISH

## Add minnow
func minnow():
	var base = 30
	fish_size = rng.randf_range(2.0, 8.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Minnow"; fish_token = "cm"
	Globals.fish.append([
		Globals.minnow,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.minnow_sell
	]); return minnow_entity


## Add ruby crayfish
func ruby():
	var base = 35
	fish_size = rng.randf_range(5.0, 12.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Ruby"; fish_token = "cm"
	Globals.fish.append([
		Globals.ruby,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.ruby_sell
	]); return ruby_entity


## Add sapphire crayfish
func sapp():
	var base = 35
	fish_size = rng.randf_range(5.0, 14.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Sapp"; fish_token = "cm"
	Globals.fish.append([
		Globals.sapp,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.sapp_sell
	]); return sapp_entity


## Add chub
func chub():
	var base = 35
	fish_size = rng.randf_range(30.0, 50.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Chub"; fish_token = "cm"
	Globals.fish.append([
		Globals.chub,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.chub_sell
	]); return chub_entity


## Add perch
func perch():
	var base = 40
	fish_size = rng.randf_range(30.0, 45.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Perch"; fish_token = "cm"
	Globals.fish.append([
		Globals.perch,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.perch_sell
	]); return perch_entity


## Add perch
func neon():
	var base = 50
	fish_size = rng.randf_range(2.0, 6.0)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Neon"; fish_token = "cm"
	Globals.fish.append([
		Globals.neon,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.neon_sell
	]); return neon_entity


## Add bass
func bass():
	var base = 100
	fish_size = rng.randi_range(30, 100)
	var value = base + (fish_size/2)
	fish_array = Globals.pond_caught
	fish_name = "Bass"; fish_token = "cm"
	Globals.fish.append([
		Globals.bass,
		snapped(value,1),
		str(snapped(fish_size,1),"cm"),
		Globals.bass_sell
	]); return bass_entity


## Add sturgeon
func sturgeon():
	var base = 200
	fish_size = rng.randf_range(0.5, 4.0)
	var value = base + (fish_size * 100)/2
	fish_array = Globals.pond_caught
	fish_name = "Sturgeon"; fish_token = "m"
	Globals.fish.append([
		Globals.sturgeon,
		snapped(value,1),
		str(snapped(fish_size,0.01),"m"),
		Globals.sturgeon_sell
	]); return sturgeon_entity


## Add zebra pleco
func zebra():
	var base = 400
	fish_size = rng.randf_range(2.0, 8.0)
	var value = base + (fish_size * 5)
	fish_array = Globals.pond_caught
	fish_name = "Zebra"; fish_token = "cm"
	Globals.fish.append([
		Globals.zebra,
		snapped(value,1),
		str(snapped(fish_size,0.1),"cm"),
		Globals.zebra_sell
	]); return zebra_entity




#endregion
