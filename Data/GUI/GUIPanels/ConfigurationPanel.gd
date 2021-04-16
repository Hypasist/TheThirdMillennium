extends Control

var shipDatabase = null
func setup(_shipDatabase):
    shipDatabase = _shipDatabase
    $ModelSelect.setup(shipDatabase)

func getName():
    return $ShipName.get_text()

signal configurationNew(shipRecord)
func _on_NewButton_up():
    var shipRecord = shipDatabase["Jay"]
    emit_signal("configurationNew", shipRecord)

signal configurationClear
func _on_ClearButton_up():
    emit_signal("configurationClear")

signal configurationLoad(configurationName)
func _on_LoadButton_up():
    emit_signal("configurationLoad", "GreyJay")

signal configurationSave(configurationName, shipName)
func _on_SaveButton_up():
    emit_signal("configurationSave", "GreyJay", getName())

signal configurationSaveAs(configurationName, shipName)
func _on_SaveAsButton_up():
    emit_signal("configurationSaveAs", "GreyJay", getName())
