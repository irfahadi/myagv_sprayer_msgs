# Runtime metrics of one navigation trial. Training cost is deliberately NOT here:
# RL and A*/D* are compared at inference time only (see docs/experiment_protocol.md).
std_msgs/Header header

string algorithm
string tray_id
string scenario              # 1_ideal | 2_unmapped_persistent | 2_unmapped_transient
uint32 trial

bool success                 # reached the correct tray dock zone without collision
string failure_reason        # "" | timeout | collision | wrong_tray | aborted

float32 path_length_m
float32 optimal_length_m     # A* on the ground-truth map, same start/goal
float32 efficiency           # optimal_length_m / path_length_m, 1.0 = optimal
float32 duration_s
uint32 steps

uint32 collisions
uint32 replans               # planner invocations after the first (D* Lite / A*)
float32 mean_decision_ms
float32 max_decision_ms

float32 final_position_error_m    # docking accuracy after visual servoing
float32 final_heading_error_rad
