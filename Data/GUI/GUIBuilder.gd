extends CustomGUI

var gatheredInputs = []

var tilemapManager = null

func assignTilemapManager(entity):
    tilemapManager = entity
func setup(_tilesetDatabase:Dictionary, _shipDatabase:Dictionary):
    $ConfigurationPanel.setup(_shipDatabase)
    $CollectionPanel.setup(_tilesetDatabase)
    
func passInputs(inputs:Array):
    gatheredInputs = inputs

func showGUI():
    show()
    if tilemapManager:
        tilemapManager.startBuilder()

func hideGUI():
    hide()
    if tilemapManager:
        tilemapManager.stopBuilder()


func custom_gui_physics_process():
    if tilemapManager:
        tilemapManager.setTilemapFocused(!$CollectionPanel.doesContainPoint(get_viewport().get_mouse_position()))
        tilemapManager.custom_physics_process()


func _on_SaveButton_up():
    tilemapManager.saveConfiguration($ConfigurationName.get_text())

func _on_LoadButton_up():
    tilemapManager.loadConfiguration($ConfigurationName.get_text())

var currentlySelectedRecord = null
func _on_CollectionPanel_newRecordSelected(record):
    currentlySelectedRecord = record
