class_name Ship
extends Entity

var EngineType = preload("res://Engine.gd")
var KinematicType = preload("res://Kinematic.gd")

var currentPassengers = []
var engines = []
var weapons = []
var kinematic = null

# -- to be outsourced ---
# silniki glowne/napedowe
# silniki pozycjonujace/manewrowe
# silniki stabilizujace/obrotowe
export var engineMainForward = 5000
export var enginePositionBackward = 2000
export var enginePositionLeft = 3000
export var enginePositionRight = 3000
export var engineRotationalLeft = 30
export var engineRotationalRight = 30
export var engineDampingMultiplier = 0.95
# TO DO: zastanów się, czy nie chciałbyś, aby nie:
#            - każdy silnik jest dedykowany na którykolwiek z 6 ruchów, tylko
#            - każdy silnik może być podpięty pod guzik
# -- -- -- -- -- -- -- --


func _init():
    kinematic = KinematicType.new(10.0, 50.0, Vector2(0.0, 0.0), 0.8)

func processMovement(delta):
    var powerRelative = Vector2(0, 0)
    var powerRotational = 0
    var powerDamping = false
    
    while !gatheredInputs.empty():
        match gatheredInputs.front():
            cons.SHIP_MOVE_FORWARD:
                powerRelative.x += engineMainForward
            cons.SHIP_MOVE_BACKWARD:
                powerRelative.x -= enginePositionBackward
            cons.SHIP_MOVE_RIGHT:
                powerRelative.y += enginePositionRight
            cons.SHIP_MOVE_LEFT:
                powerRelative.y -= enginePositionLeft
            cons.SHIP_ROTATE_RIGHT:
                powerRotational += engineRotationalRight
            cons.SHIP_ROTATE_LEFT:
                powerRotational -= engineRotationalLeft
            cons.SHIP_DAMP_MOVEMENT:
                powerDamping = true
            cons.SHIP_SHOOT:
                $WeaponSlots.shootWeapons();
            _:
                print(gatheredInputs.front(), " !"); breakpoint
        gatheredInputs.pop_front()
            
            
    if powerDamping: kinematic.dampMomentum(engineDampingMultiplier, 0.5, 1)
    kinematic.setPowerRelative(powerRelative)
    kinematic.setPowerRotational(powerRotational)
    var objectMovement = kinematic.processMovement(delta)
    rotation_degrees = objectMovement[1]
    var collision = move_and_collide(objectMovement[0], true, true, false)
    # if collision: kinematic.collisionTest(self, instance_from_id(collision.collider_id), collision.position, collision.normal)
    
func custom_physics_process(delta):
    if (!movementPaused): processMovement(delta)    

func passengerEntered(passenger):
    if passenger: currentPassengers.append(passenger)
        
func passengerLeft(passenger):
    var position = currentPassengers.find(passenger)
    if position >= 0: currentPassengers.remove(position)
    
func showInternals():
    $TilemapManager.show()
    $Hull.get_material().set_shader_param("greyout", true)
    
func hideInternals():
    $TilemapManager.hide()
    $Hull.get_material().set_shader_param("greyout", false)

func setup(tilesetDatabase, _position, _rotation_degrees):
    position = _position
    rotation_degrees = _rotation_degrees
    $TilemapManager.setup(tilesetDatabase)
    kinematic.setPositionAll(position, rotation_degrees)
        
func getShipInfo():
    var velRel = kinematic.getVelocityAbsolute()
    var velRot = kinematic.getVelocityRotational()
    var momRel = kinematic.getMomentumAbsolute()
    var momRot = kinematic.getMomentumRotational()
    return "Pos: x:%4.2f  y:%4.2f  a:%4.2f\nVel: x:%4.2f  y:%4.2f  a:%4.2f\nMom: x:%4.2f  y:%4.2f  a:%4.2f\n" \
    % [position.x, position.y, rotation_degrees, velRel.x, velRel.y, velRot, momRel.x, momRel.y, momRot]
    
onready var tilemapManager = $TilemapManager
func getTilemapManager():
    return tilemapManager
