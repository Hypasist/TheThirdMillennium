extends ScrollContainer

var currentlySelected = null
signal newRecordSelected(record)
func _on_Button_objectSelected(button, button_pressed):
    if currentlySelected:
        currentlySelected.pressed = false
        
    if button_pressed:
        currentlySelected = button
    else:
        currentlySelected = null
    if currentlySelected:
        emit_signal("newRecordSelected", currentlySelected.getRecord())
    else:
        emit_signal("newRecordSelected", null)


const ObjectButtonType = preload("res://Data/GUI/GUIPanels/ObjectButton.tscn")
var buttonList = []
func addButton(record):
    var button = ObjectButtonType.instance()
    button.setName(record["TileName"])
    button.setTexture(record["TileSprite"])
    button.setRecord(record)
    button.connect("objectSelected", self, "_on_Button_objectSelected")
    $HBoxContainer/GridContainer.add_child(button)
