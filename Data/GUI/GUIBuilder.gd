extends CustomGUI

var gatheredInputs = []

var tilemapManager = null

func assignTilemapManager(entity):
    tilemapManager = entity
    
func passInputs(inputs:Array):
    gatheredInputs = inputs

func showGUI():
    $CollectionPanel.show()
    if tilemapManager:
        tilemapManager.startBuilder()

func hideGUI():
    $CollectionPanel.hide()
    if tilemapManager:
        tilemapManager.stopBuilder()


func custom_gui_physics_process():
    if tilemapManager:
        tilemapManager.setTilemapFocused(!$CollectionPanel.doesContainPoint(get_viewport().get_mouse_position()))
        tilemapManager.custom_physics_process()
