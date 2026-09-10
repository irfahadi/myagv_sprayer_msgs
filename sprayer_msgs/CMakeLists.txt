cmake_minimum_required(VERSION 3.8)
project(sprayer_msgs)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/TankLevel.msg"
  "msg/SprayStatus.msg"
  "msg/TrayObservation.msg"
  "msg/NavState.msg"
  "msg/NavMetrics.msg"
  "msg/DockStatus.msg"
  "msg/ArucoMarker.msg"
  "msg/ArucoMarkerArray.msg"
  "srv/Spray.srv"
  "srv/ObserveTray.srv"
  "srv/SetNavAlgorithm.srv"
  "action/NavigateToTray.action"
  DEPENDENCIES std_msgs geometry_msgs
)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
