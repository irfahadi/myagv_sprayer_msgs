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
                             # to a true base-frame yaw -- it was fine as a servoing
                             # error signal for visual_servo_node, which drove it to
                             # 0, but that node is gone and nothing consumes this
                             # now. Still wrong for reconstructing geometry: do not
                             # reach for it as a yaw just because it is here.
float32 normal_yaw_base_rad  # yaw of the marker's OUTWARD normal in base_footprint
                             # -- the way the printed face looks, exactly, with the
                             # camera pitch already taken out. Computed from the same
                             # solvePnP rotation as yaw_to_marker_rad, not derived
                             # from it.
                             #
                             # PUBLISHED BUT CURRENTLY UNCONSUMED. It existed to turn
                             # "where the marker is" into "where the tray's dock pose
                             # is". Anchoring the tracker on the dock pose was tried
                             # and ABANDONED: the dock pose is a point in free space
                             # the robot stands ON, so its bearing is ill-conditioned
                             # as range goes to zero and 1 cm of overshoot flips it
                             # 180 deg. The marker is the better anchor precisely
                             # because it is always BEHIND the stopping point, behind
                             # an impassable tray. Navigation now steers at the marker
                             # and ends a leg on a close-range sighting. Kept because
                             # it is cheap and geometrically correct; see the Jetson
                             # repo's docs/RESULTS.md ("Abandoned experiments").
float32 reprojection_error   # px, solvePnP quality
