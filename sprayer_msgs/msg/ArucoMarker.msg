# One detected fiducial. Each tray carries three stands (DICT_4X4_50) that all
# SHARE the tray's single id -- ids 1..4, three instances each, on the dock face
# and both side faces (myagv_sprayer_gazebo's generate_aruco_markers.py). A tray
# has one identity whichever side you read it from. cv2.aruco only decodes within
# ~+-20 deg of a marker's normal, which is why one face per tray was not enough.
#
# Published only after solvePnP succeeds AND the reprojection error is within
# aruco_detector_node's max_reprojection_error. A decoded marker can therefore be
# absent here; the node logs when it drops one.
std_msgs/Header header       # frame_id = camera optical frame

int32 id
geometry_msgs/Pose pose      # marker pose in the camera optical frame (solvePnP)
float32 bearing_rad          # marker bearing in base_footprint, [-pi, pi]
float32 range_m              # marker distance in base_footprint
float32 yaw_to_marker_rad    # robot yaw error w.r.t. the marker's surface normal;
                             # 0 = squarely facing. Measured in the CAMERA frame,
                             # so it is stretched by 1/cos(camera_pitch) relative
                             # to a true base-frame yaw -- fine as a servoing
                             # error signal (visual_servo_node drives it to 0),
                             # wrong for reconstructing geometry.
float32 normal_yaw_base_rad  # yaw of the marker's OUTWARD normal in base_footprint
                             # -- the way the printed face looks, exactly, with the
                             # camera pitch already taken out. Lets a consumer turn
                             # "where the marker is" into "where the tray's dock
                             # pose is", which is what navigation actually steers
                             # at: a side-face marker sits 1.01 m from it, nearly
                             # 3x goal_radius. Computed from the same solvePnP
                             # rotation as yaw_to_marker_rad, not derived from it.
float32 reprojection_error   # px, solvePnP quality
