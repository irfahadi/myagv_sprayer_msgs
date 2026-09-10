# Liquid level of the sprayer tank (from the HC-SR04 in the lid, or simulated)
std_msgs/Header header
float32 distance_m      # sensor -> liquid surface (m)
float32 level_m         # liquid column height (m)
float32 volume_ml       # estimated remaining volume
float32 percent         # 0..100
bool low                # below low_percent -> refill needed
bool empty              # below empty_percent -> pump dry-run protection engaged
