extends CustomGUI

# --- SETUP -------------------------------------------------------------------
func assign2Entity(entity:Ship):
    .assign2Entity(entity)
    $BuilderLogic.assignShip(entity)
    
func setup(_tilesetDatabase:Dictionary, _shipDatabase:Dictionary):
    $ConfigurationPanel.setup(_shipDatabase)
    $CollectionPanel.setup(_tilesetDatabase)
    $BuilderLogic.setup(_tilesetDatabase)
   

# --- PROCESS -----------------------------------------------------------------
var gatheredInputs = []
func passInputs(inputs:Array):
    gatheredInputs = inputs

var builderActive = false
func custom_gui_physics_process():
    if builderActive:
        var tilemapFocused = !$CollectionPanel.doesContainPoint(get_viewport().get_mouse_position())
        if tilemapFocused:
            $BuilderLogic.custom_physics_process()
        else:
            $BuilderLogic.clear()


# --- SWITCH ------------------------------------------------------------------
func showGUI():
    builderActive = true
    show()

func hideGUI():
    builderActive = false
    hide()
    $BuilderLogic.clear()
