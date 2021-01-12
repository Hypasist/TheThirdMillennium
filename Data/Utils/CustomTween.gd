extends Tween

var object = null
var property = null
var start_value:float = 0
var end_value:float = 0
var nominal_time:float = 0
var trans_type = 0
var ease_type = 0

func initialize(_object, _property, _start_value, _end_value, _nominal_time, _trans_type, _ease_type):
    object = _object
    property = _property
    start_value = _start_value
    end_value = _end_value
    nominal_time = _nominal_time
    trans_type = _trans_type
    ease_type = _ease_type
    
func start_normal(current_value):
    if(start_value == end_value): return
    stop(object, property)
    var time = (abs(current_value - end_value) / abs(start_value - end_value)) * nominal_time
#    print("start ", current_value, "  ", end_value, "  ", time)
    interpolate_property(object, property, current_value, end_value, time, trans_type, ease_type) 
    start()
        
    
func start_reverse(current_value):
    if(start_value == end_value): return
    stop(object, property)
    var time = (abs(current_value - start_value) / abs(start_value - end_value)) * nominal_time
#    print("back ", current_value, "  ", end_value, "  ", time)
    interpolate_property(object, property, current_value, start_value, time, trans_type, ease_type) 
    start()
