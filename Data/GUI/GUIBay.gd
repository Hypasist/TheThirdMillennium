extends CanvasLayer
var cons = preload("res://Data/Utils/Constants.gd")

var followedShip:Ship = null
var followedPerson:Person = null

func assignShip(ship:Ship):
    followedShip = ship
    $GUIShip.assign2Entity(ship)
    $GUIBuilder.assign2Entity(ship)
    
func assignPerson(person:Person):
    followedPerson = person

func resolve_GUI_physics_process(viewMode):
    match viewMode:
        cons.SHIP_VIEW:
            $GUIShip.custom_gui_physics_process()
            
        cons.PERSONAL_VIEW:
            pass
            
        cons.BUILDER_VIEW:
            $GUIBuilder.custom_gui_physics_process()
            


func changeDisplayedGUI(viewMode):
    $GUIPerson.hideGUI()
    $GUIShip.hideGUI()
    $GUIBuilder.hideGUI()
    followedShip.hideInterior()
    
    match viewMode:
        cons.SHIP_VIEW:
            $GUIShip.showGUI()
            
        cons.PERSONAL_VIEW:
            $GUIPerson.showGUI()
            followedShip.showInterior()
            
        cons.BUILDER_VIEW:
            $GUIBuilder.showGUI()
            followedShip.showInterior()
            
            
func setup(tilesetDatabase, shipDatabase):
    $GUIBuilder.setup(tilesetDatabase, shipDatabase)
