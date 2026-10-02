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

# Robot-frame (base_footprint) bearing to the detected marker's bbox centre,
# from the camera intrinsics and the same optical->base transform
# aruco_detector_node uses (sprayer_docking/camera_geometry.py). This is what
# lets the navigation goal signal fall back on the CNN detector when cv2.aruco
# fails to DECODE a marker it can still SEE -- see
# nav_controller_node._update_tracker and docs/vfh_ql.md sec.5.
#
# There is deliberately NO range field here. Range from a bbox is
# fx*marker_len/width, biased by 1/cos(incidence): +15% at 30 deg, +41% at
# 45 deg -- worst exactly where this fallback is meant to earn its keep, and
# biased in the dangerous direction (an over-estimated range means a leg never
# crosses dock_radius and burns nav_timeout_s). Bearing has no such problem:
# it is invariant to the ray's scale except through the 0.15 m camera offset,
# so a +/-50% range error moves it ~2 deg against a 45 deg sector width.
float32 bearing_rad
bool bearing_valid          # false unless tray_detected AND intrinsics are known
