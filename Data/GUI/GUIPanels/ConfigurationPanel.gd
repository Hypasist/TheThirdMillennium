extends NinePatchRect


var shipDatabase = null
func setup(_shipDatabase):
    shipDatabase = _shipDatabase

signal clearShipConfiguration
signal newShipConfiguration
func _on_NewButton_up():
    #print(shipDatabase)
    pass


func _on_ClearButton_up():
    pass # Replace with function body.


func _on_LoadButton_up():
    pass # Replace with function body.


func _on_SaveButton_up():
    pass # Replace with function body.


func _on_SaveAsButton_up():
    pass # Replace with function body.
