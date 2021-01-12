extends CustomGUI

func setInfo(info):
    $ShipInfo.text = info

func showGUI():
    $ShipInfo.show()
    if followedEntity:
        pass

func hideGUI():
    $ShipInfo.hide()
    if followedEntity:
        pass

func custom_gui_physics_process():
    pass
