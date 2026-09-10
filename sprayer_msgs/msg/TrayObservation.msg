# Result of looking at one seedling tray (vision node -> mission node)
std_msgs/Header header
string tray_name
bool tray_detected
float32 confidence          # detector confidence of the tray bbox
float32 bbox_cx             # normalised 0..1, image coordinates
float32 bbox_cy
float32 bbox_w
float32 bbox_h
float32 green_ratio         # fraction of bbox pixels that are green canopy
float32 dry_ratio           # fraction of bbox soil pixels classified as dry (pale)
float32 moisture_index      # 0 (dry) .. 1 (wet), derived from HSV of the soil
bool needs_spray            # moisture_index < threshold
float32 recommended_ml      # dose suggested for this tray
