# Published by spray_manager at 5 Hz
std_msgs/Header header
bool relay_on               # commanded relay / pump state
bool spraying               # relay_on and not inhibited
string inhibit_reason       # "" | "tank_empty" | "estop" | "max_duration" | "manual"
float32 elapsed_s           # seconds of the current spray burst
float32 total_sprayed_ml    # since node start
float32 last_burst_ml
