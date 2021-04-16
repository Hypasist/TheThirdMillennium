extends ScrollContainer


const ButtonType = preload("res://Data/GUI/GUIPanels/BaseSimpleTextButton.tscn")
var buttonList = []
func addSelectButton(key, record):
    var button = ButtonType.instance()
    button.setID(key)
    button.setText(record["ShipName"])
    button.connect("objectSelected", self, "_on_Button_objectSelected")
    $VBoxContainer.add_child(button)


var currentlySelected = null
signal newModelSelected(record)
func _on_Button_objectSelected(button):
    if currentlySelected:
        currentlySelected.pressed = false
        
    currentlySelected = button
    emit_signal("newRecordSelected", currentlySelected.getRecord())
        
        
