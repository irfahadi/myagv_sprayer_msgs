# One decision cycle of the Layer-2 navigation controller (VFH-QL / DQN / A* / D* Lite).
# Mirrors the sensory state-space of Abdalmanan et al. (2023), IEEE Access:
#   8 binary open/blocked sectors + relative target angle + target visibility.
std_msgs/Header header

string algorithm            # vfh_ql | dqn | astar | dstar_lite
uint8[8] sector_blocked     # 1 = blocked, index 0 = robot heading, +45 deg per index
float32[8] sector_min_range # metres, min LiDAR return inside each 45 deg sector

float32 goal_bearing_rad    # target angle relative to robot heading, [-pi, pi]
bool goal_visible           # ArUco marker of the goal tray currently detected
uint8 goal_sector           # goal_bearing discretised into the same 8 sectors
uint8 goal_id               # tray index 0..3 (goal-conditioning input)

uint32 state_index          # tabular index: ((bits*8 + goal_sector)*2 + visible)*n_trays + goal_id
uint8 action                # chosen action, 0..7 (same sector convention)
float32 reward              # reward attributed to this transition (paper scale)
float32 decision_ms         # wall-clock cost of this decision cycle
bool bearing_from_memory    # true when goal_bearing is the last-known value (marker lost)
