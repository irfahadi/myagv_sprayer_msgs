# One decision cycle of the Layer-2 navigation controller
# (VFH-QL / CQL / SARSA / A* / D* Lite).
# Mirrors the sensory state-space of Abdalmanan et al. (2023), IEEE Access:
#   8 binary open/blocked sectors + relative target angle + target visibility,
# plus this project's two additions -- momentum and goal_id (see the Jetson
# repo's docs/vfh_ql.md sec.1).
std_msgs/Header header

string algorithm            # vfh_ql | cql | sarsa | astar | dstar_lite
                            # DQN was dropped; CQL and SARSA replaced it as the
                            # absolute-cell-state comparison.
uint8[8] sector_blocked     # 1 = blocked, index 0 = robot heading, +45 deg per index
float32[8] sector_min_range # metres, min LiDAR return inside each 45 deg sector

float32 goal_bearing_rad    # target angle relative to robot heading, [-pi, pi]
bool goal_visible           # goal tray's ArUco marker DECODED this cycle (cv2.aruco).
                            # A YOLO sighting does NOT set this: every Q-table was
                            # trained with this bit meaning "decoded inside the 20 deg
                            # incidence gate", and flipping it on a state the robot is
                            # genuinely in lands on an untrained table row ~41% of the
                            # time (VFH-QL, visit-weighted), where the greedy policy
                            # degenerates to a uniform random action. See
                            # goal_bearing_source below for what YOLO does contribute.
uint8 goal_sector           # goal_bearing discretised into the same 8 sectors
uint8 goal_id               # tray index 0..3 (goal-conditioning input)

uint32 state_index          # tabular index: ((bits*8 + goal_sector)*2 + visible)*n_trays + goal_id
uint8 action                # chosen action, 0..7 (same sector convention)
float32 reward              # reward attributed to this transition (paper scale)
float32 decision_ms         # wall-clock cost of this decision cycle
bool bearing_from_memory    # true when goal_bearing is the last-known value (marker lost)

# Where goal_bearing_rad came from THIS cycle. The number the live run
# (Scenario 4, formerly 3.2) needs in order to say anything honest about the
# vision model's role in navigation: the fraction of ticks with source == YOLO
# is exactly "how often the CNN supplied a direction cv2.aruco could not".
# A YOLO count of zero is a real result about the detector's envelope, not a bug.
uint8 GOAL_BEARING_NONE = 0     # no estimate at all
uint8 GOAL_BEARING_ARUCO = 1    # cv2.aruco decode, solvePnP pose (also sets goal_visible)
uint8 GOAL_BEARING_YOLO = 2     # CNN detection re-anchored the direction; goal_visible stays false
uint8 GOAL_BEARING_MEMORY = 3   # dead-reckoned through odometry, or the TF prior
uint8 goal_bearing_source
