tool
extends NinePatchRect

onready var SelectionButtons = $MainContainer/VBoxContainer/HBoxContainer/SelectionButtons

var shipDatabase = null
func setup(_shipDatabase):
    shipDatabase = _shipDatabase

    for key in shipDatabase:
        var record = shipDatabase[key]
        SelectionButtons.addSelectButton(key, record)
        
        
        
    
export var paddingLeft = 10
export var paddingRight = 10
export var paddingTop = 32
export var paddingBotton = 10

export var minButtonWidth = 160
export var minColumnCount = 2

func _on_Control_resized():
    var newSize = get_size()
    set_pivot_offset(newSize/2)
    
    $MainContainer.set_position(Vector2(paddingLeft, paddingTop))
    $MainContainer.set_size(newSize - Vector2(paddingLeft + paddingRight, paddingTop + paddingBotton))
    


func _on_SelectionButtons_newRecordSelected(record):
    pass # Replace with function body.
