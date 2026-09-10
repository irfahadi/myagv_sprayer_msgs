# ArUco visual-servoing state machine (precise stop in FRONT of the tray).
std_msgs/Header header

bool enabled
string phase                 # IDLE | SEARCH | ALIGN | APPROACH | DONE | FAILED
int32 marker_id              # -1 when no marker is being tracked
bool marker_visible

float32 err_lateral_m        # + = marker is to the robot's left
float32 err_range_m          # distance still to travel towards the stop pose
float32 err_yaw_rad          # + = robot must turn left to face the tray squarely

bool docked
string message
