# Runtime metrics of one navigation trial. Training cost is deliberately NOT here:
# RL and A*/D* are compared at inference time only (see docs/experiment_protocol.md).
std_msgs/Header header

string algorithm
string tray_id
# Code key of the scenario, NOT its number in the protocol document. The keys are
# hashed into each trial's seed by sim2d/benchmark.episode_seed(), so renaming one
# re-rolls every start pose, goal draw and obstacle placement and makes every
# recorded result unreproducible. They are frozen, which is why Scenario 3 in
# docs/experiment_protocol.md is run as `--scenario 4`:
#   1_ideal                                        Scenario 1
#   2_unmapped_persistent | 2_unmapped_transient   Scenario 2
#   4_visreward_uniform   | 4_visreward_wsn        Scenario 3
#   4_multileg                                     ablation sweeps only
# Scenario 4 (live Gazebo) has no code key. Live runs currently leave this field
# "" and `trial` 0 -- mission_node does not tag them -- so a live run produces no
# scenario-tagged CSV. Known gap, see RESULTS.md "Open items".
string scenario
uint32 trial

bool success                 # reached the correct tray dock zone
string failure_reason        # "" | timeout | collision | wrong_tray | aborted

float32 path_length_m
float32 optimal_length_m     # A* on the ground-truth map, same start/goal
float32 efficiency           # optimal_length_m / path_length_m, 1.0 = optimal
float32 duration_s
uint32 steps

# Times the emergency predicate fired: something closer than `emergency_distance`
# (0.22 m) in the front OR rear sector -- see nav_controller_node._emergency().
# This is NOT a contact count. The robot is never touched; it backs away or turns.
# Deliberately NOT named `collisions`, because the sim2d harness uses that name
# for a genuine swept-footprint overlap (room_env.py's `collisions`, distinct
# from its own `n_emergency`), and the two were being compared as if they were
# the same quantity. The Scenario 1/2 tables report contacts; this field does
# not, and the two columns must not be placed side by side.
uint32 emergency_events
uint32 replans               # planner invocations after the first (D* Lite / A*)
float32 mean_decision_ms
float32 max_decision_ms

# Live stack: how far the robot stopped from the tray's parking point, -1.0
# when there was no TF to measure it against. Used to be the visual servo's
# own report, which no longer exists. sim2d still fills both from
# sim2d/docking.run_docking, which is why the heading term stays.
float32 final_position_error_m
float32 final_heading_error_rad   # sim2d only; unpopulated on the robot
