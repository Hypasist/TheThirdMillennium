extends NinePatchRect

var shipDatabase = null
func setup(_shipDatabase):
    shipDatabase = _shipDatabase

func getName():
    return $ShipName.get_text()

signal configurationNew
func _on_NewButton_up():
    emit_signal("configurationNew")

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
