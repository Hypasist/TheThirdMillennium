extends Node
var cons = preload("res://Data/Utils/Constants.gd")
var utils = preload("res://Data/Utils/Utils.gd")

onready var controlPerson = $ControlBay/ControlPerson
onready var controlBuilder = $ControlBay/ControlBuilder
onready var controlShip = $ControlBay/ControlShip

onready var cameraPerson = $CameraBay/CameraPerson
onready var cameraBuilder = $CameraBay/CameraBuilder
onready var cameraShip = $CameraBay/CameraShip

onready var GUIPerson = $GUIBay/GUIPerson
onready var GUIBuilder = $GUIBay/GUIBuilder
onready var GUIShip = $GUIBay/GUIShip

var gameMode = cons.PERSONAL_VIEW

var tilesetDatabase = null

func getDatabases():
    var database = get_tree().get_root().get_node("DataImport")
    tilesetDatabase = database.getTilesetDatabase()

func initializeBays():
    $ShipBay.setTilesetDatabase(tilesetDatabase)

func _ready():
    # to do:
    # make new script to change *EVERY* container member accroding to mode
    # then treat player nodes specially
    # maybe assigning players to ship inside player node?
    # PROBABLY MOVE VISUAL CHANGES INTO ENTITY CLASS?
    getDatabases()
    initializeBays()
    
    var SHIP = $ShipBay.addShip()
    
    controlShip.assignControlledObject(SHIP)
    controlShip.assignCamera(cameraShip)
    cameraShip.assign2Person(SHIP)
    
    controlPerson.assignControlledObject($People/PERSON)
    controlPerson.assignCamera(cameraPerson)
    cameraPerson.assign2Person($People/PERSON)
    
    controlBuilder.assignControlledObject(SHIP)
    controlBuilder.assignCamera(cameraBuilder)
    cameraBuilder.assign2Person(SHIP)
    
    $GUIBay.assignShip(SHIP)
    $GUIBay.assignPerson($People/PERSON)
    # place person in KESTREL
    ($People/PERSON).enterShip(SHIP)
    
    setGameState(gameMode)
    
    # setup GUI ???
    #$Builder.setup()
    

func setGameState(mode):
    gameMode = mode
    changeGameMode(mode)
                
func toggleGameMode():
    match gameMode:
        cons.SHIP_VIEW:
            setGameState(cons.PERSONAL_VIEW)
        cons.PERSONAL_VIEW:
            setGameState(cons.BUILDER_VIEW)
        cons.BUILDER_VIEW:
            setGameState(cons.SHIP_VIEW)
    
func changeControllerNode(controller: playerControl):
    controlShip.stopGatherInput()
    controlPerson.stopGatherInput()
    controlBuilder.stopGatherInput()
    controller.startGatherInput()

func changeGameMode(mode):
    var playerShip: Ship = controlShip.controlledObject
    var playerPerson = controlPerson.controlledObject
    match mode:
        cons.SHIP_VIEW:
            cameraShip.make_current()
            $GUIBay.changeDisplayedGUI(cons.SHIP_VIEW)
            changeControllerNode(controlShip)
            
        cons.PERSONAL_VIEW:
            cameraPerson.make_current()
            $GUIBay.changeDisplayedGUI(cons.PERSONAL_VIEW)
            changeControllerNode(controlPerson)
            
        cons.BUILDER_VIEW:
            cameraBuilder.make_current()
            $GUIBay.changeDisplayedGUI(cons.BUILDER_VIEW)
            changeControllerNode(controlBuilder)

func _process(text):
    if Input.is_action_just_pressed("ui_swap"):
        toggleGameMode()
    
    #if Input.is_mouse_button_pressed(BUTTON_LEFT):
        #print(get_viewport().get_mouse_position())
    
    
func _physics_process(delta):
    $ControlBay.resolve_control_process()
    $GUIBay.resolve_GUI_physics_process(gameMode)
    $People.resolve_people_physics_process(delta)
    $ShipBay.resolve_ships_physics_process(delta)
    $Projectiles.resolve_projectiles_physics_process(delta)
    $CameraBay.resolve_camera_process(delta)
    #$Celestials.custom_physics_process_content(delta)

