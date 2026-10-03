# myagv_sprayer_msgs

Antarmuka bersama untuk robot penyiram greenhouse myAGV. Repo ini sengaja berdiri
sendiri supaya Jetson Nano dan Raspberry Pi mem-build definisi pesan yang
**identik** — kalau definisinya berbeda sedikit saja, checksum tipe ROS 2 tidak
cocok dan kedua board berhenti saling mendengar tanpa pesan error yang jelas.

Repo terkait:

| repo | isi |
|---|---|
| [`myagv_sprayer_jetson`](../myagv_sprayer_jetson) | navigasi Layer-2 (VFH-QL, CQL, SARSA, A*, D* Lite), deteksi marker ArUco, vision, kendali pompa, misi |
| [`myagv_sprayer_raspi`](../myagv_sprayer_raspi) | basis myAGV, LiDAR, kamera, peta, watchdog, world Gazebo |

## Pemakaian

Kedua workspace menariknya lewat `vcs`:

```bash
cd ~/myagv_sprayer_jetson
vcs import src < myagv_sprayer.repos     # ganti URL CHANGEME lebih dulu
colcon build --packages-select sprayer_msgs
```

Nama paketnya `sprayer_msgs` (nama repo `myagv_sprayer_msgs`).

## Isi

### Pesan

| tipe | dipakai untuk |
|---|---|
| `TankLevel` | sisa cairan dari HC-SR04 di tutup tangki; `low`/`empty` memicu proteksi pompa kering |
| `SprayStatus` | keadaan relai/pompa, alasan penghambatan, total ml |
| `TrayObservation` | hasil pengamatan satu baki: identitas + bbox dari `tray_detector_node` (myagv_sprayer_jetson). Field `needs_spray`/`recommended_ml` masih ada di skema tapi belum diisi node manapun — disiapkan untuk sumber WSN nanti. **Jangan menggerbangi dosis padanya**: itu pernah dilakukan dan membuat misi tidak pernah menyemprot sama sekali (mendeteksi baki justru mencegahnya disiram). Sekarang `mission.yaml` memakai `default_dose_ml: 60.0`, dengan `recommended_ml` tetap menang kalau suatu saat terisi |
| `NavState` | **satu siklus keputusan navigasi**: 8 bit sektor, sudut target relatif, visibilitas, indeks state, aksi, reward, waktu keputusan, plus dua tambahan proyek ini — `momentum` dan `goal_id` |
| `NavMetrics` | satu rekaman metrik per percobaan navigasi, ditandai dengan *code key* skenario (lihat komentar di `NavMetrics.msg`; matriks A–E yang lama sudah disupersede). `emergency_events` menghitung pemicuan predikat jarak-aman, **bukan** kontak fisik — tidak sebanding dengan kolom Collisions tabel Skenario 1/2 yang berasal dari sapuan footprint sim2d |
| `ArucoMarker`, `ArucoMarkerArray` | identitas baki + pose 6-DOF dari satu frame. Tiap baki membawa id yang sama di tiga muka, jadi satu baki punya satu identitas dari sisi mana pun dibaca |

`NavState` sengaja memuat seluruh vektor state VFH-QL. Itu membuat kebijakan bisa
diaudit saat berjalan: Anda bisa merekam bag, memutar ulang, dan melihat persis
state apa yang menghasilkan aksi apa — tanpa itu, RL di robot nyata praktis tidak
bisa didebug.

### Layanan

| tipe | keterangan |
|---|---|
| `Spray` | minta semburan terukur (`duration_s` **atau** `volume_ml`) |
| `ObserveTray` | rata-ratakan N frame jadi satu observasi baki yang stabil |
| `SetNavAlgorithm` | ganti algoritma Layer-2 saat runtime tanpa restart |

### Aksi

`NavigateToTray` — menggantikan `nav2_msgs/NavigateToPose`. Tujuannya adalah
**identitas baki**, bukan pose peta:

```
string tray_id      # "baki_2_timur_laut"
uint8  goal_id      # 0..3, input goal-conditioning kebijakan
string algorithm    # "" = pakai yang sedang aktif
string scenario     # code key skenario, "" kalau bukan benchmark
uint32 trial
```

Field `dock` sudah **tidak ada**: lapisan docking/visual servoing dihapus. Satu leg
sekarang selesai pada penglihatan marker jarak-dekat (`sighting_radius`), bukan
diserahkan ke visual servo di akhir. Konsekuensinya `DockStatus` juga sudah tidak
ada di repo ini.

Ini yang membuat satu permintaan yang sama bisa dilayani oleh kebijakan RL
goal-conditioned maupun oleh A*/D* Lite. Kalau tujuannya berupa pose peta, hanya
planner yang bisa memakainya, dan perbandingan antar algoritma jadi tidak setara.

## Aturan mengubah pesan

Definisi ini dipakai dua board. Kalau Anda mengubahnya:

1. build ulang **kedua** workspace, jangan salah satu saja;
2. naikkan `version` di `package.xml`;
3. ingat bahwa menambah field pun mengubah checksum tipe — tidak ada
   kompatibilitas mundur di ROS 2.

## Lisensi

MIT — lihat `LICENSE`.
