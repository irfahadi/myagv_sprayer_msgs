# One detected fiducial. Trays carry markers 1..4 (DICT_4X4_50).
std_msgs/Header header       # frame_id = camera optical frame

int32 id
geometry_msgs/Pose pose      # marker pose in the camera optical frame (solvePnP)
float32 bearing_rad          # marker bearing in base_footprint, [-pi, pi]
float32 range_m              # marker distance in base_footprint
float32 yaw_to_marker_rad    # robot yaw error w.r.t. the marker's surface normal
float32 reprojection_error   # px, solvePnP quality
