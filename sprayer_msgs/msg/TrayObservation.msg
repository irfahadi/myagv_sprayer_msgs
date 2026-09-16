# Result of looking at one seedling tray (vision node -> mission node)
std_msgs/Header header
string tray_name
bool tray_detected
float32 confidence          # detector confidence of the tray's ArUco marker bbox below
float32 bbox_cx             # marker bbox (tray identity), normalised 0..1, image coordinates
float32 bbox_cy
float32 bbox_w
float32 bbox_h
# Moisture fields below are NOT populated by tray_detector_node (identity
# only -- see its module docstring). Left here for a future WSN source
# (real or simulated, see myagv_sprayer_jetson's sim2d/wsn_mock.py) to fill;
# left at these defaults (0.0 / false) until then.
float32 green_ratio         # fraction of the tray's canopy that is green
float32 dry_ratio           # fraction of the tray's soil pixels classified as dry (pale)
float32 moisture_index      # 0 (dry) .. 1 (wet)
bool needs_spray            # moisture_index < threshold
float32 recommended_ml      # dose suggested for this tray
