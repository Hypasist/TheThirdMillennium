tool
extends Node
var cons = preload("res://Data/Utils/Constants.gd") 
var fileName = "res://Data/TTMData.json"
var tileSceneSource = "res://Data/ShipInteractables/"

func readAndParseDatabase():
    var file = File.new()
    if !file.file_exists(fileName):
        print("File not found! ", fileName)
        breakpoint
    file.open(fileName, file.READ)
    var text = JSON.parse(file.get_as_text()).result
    file.close()
    return text
    

func parseTilemaps(input: Dictionary):
    for key in input.keys():
        var item = input[key]
        
        match item["TileType"]:
            "PILOT_PANEL":
                item["TileType"] = cons.PILOT_PANEL
            "GUNNER_PANEL":
                item["TileType"] = cons.GUNNER_PANEL
            "FLOOR":
                item["TileType"] = cons.FLOOR
            "WALL":
                item["TileType"] = cons.WALL
            _:
                print("Invalid TileType: ", item["TileType"])
                breakpoint
                
        match item["TileGroup"]:
            "PANEL_GROUP":
                item["TileGroup"] = cons.PANEL_GROUP
            "FLOOR_GROUP":
                item["TileGroup"] = cons.FLOOR_GROUP
            "WALL_GROUP":
                item["TileGroup"] = cons.WALL_GROUP
            _:
                print("Invalid TileGroup: ", item["TileGroup"])
                breakpoint
        
        if item["TileSizeX"] && item["TileSizeY"]:
            item["TileSize"] = Vector2(item["TileSizeX"], item["TileSizeY"])
            item.erase("TileSizeX")
            item.erase("TileSizeY")
        else:
            print("Invalid TileSize")
            breakpoint
        
        if item["TileScene"]:
            item["TileScene"] = tileSceneSource + item["TileScene"] + ".tscn"
        
    return input
        
func parseShips(input: Dictionary):
    pass    

var tilesetDatabase = null
func _ready():
    var database = readAndParseDatabase()
    tilesetDatabase = parseTilemaps(database["Tilesets"])
    var shipDatabase = parseShips(database["Ships"])
    
func getTilesetDatabase():
    return tilesetDatabase
