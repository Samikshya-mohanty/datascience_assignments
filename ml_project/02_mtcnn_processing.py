import os
import cv2
import numpy as np
from pathlib import Path
from mtcnn import MTCNN
from PIL import Image

# Paths
SOURCE_DIR = Path('/Users/admin/ds_course/data_science/datascience_assignments/ml_project/data/Indian_Face_Dataset/IMFDB FR dataset/IMFDB FR dataset')
OUTPUT_DIR = Path('/Users/admin/ds_course/data_science/datascience_assignments/ml_project/data/mtcnn_processed')
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

TARGET_SIZE = (160, 160)
detector    = MTCNN()

total_saved  = 0
total_failed = 0
no_face      = 0

actors = sorted([a for a in os.listdir(SOURCE_DIR) if (SOURCE_DIR / a).is_dir()])
print(f"Processing {len(actors)} actors...\n")

for i, actor in enumerate(actors):
    actor_dir     = SOURCE_DIR / actor
    out_actor_dir = OUTPUT_DIR / actor
    out_actor_dir.mkdir(exist_ok=True)

    actor_saved = 0

    for img_file in os.listdir(actor_dir):
        if not img_file.lower().endswith(('.jpg', '.jpeg', '.png')):
            continue

        img_path = actor_dir / img_file
        try:
            img = cv2.imread(str(img_path))
            if img is None:
                total_failed += 1
                continue

            img_rgb    = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            detections = detector.detect_faces(img_rgb)

            if len(detections) == 0:
                no_face += 1
                continue

            best = max(detections, key=lambda x: x['confidence'])

            if best['confidence'] < 0.90:
                no_face += 1
                continue

            x, y, w, h = best['box']
            margin = int(0.2 * max(w, h))
            x1 = max(0, x - margin)
            y1 = max(0, y - margin)
            x2 = min(img_rgb.shape[1], x + w + margin)
            y2 = min(img_rgb.shape[0], y + h + margin)

            face     = img_rgb[y1:y2, x1:x2]
            face_pil = Image.fromarray(face).resize(TARGET_SIZE, Image.BILINEAR)

            face_pil.save(str(out_actor_dir / img_file))
            actor_saved  += 1
            total_saved  += 1

        except Exception as e:
            total_failed += 1

    print(f"[{i+1:3d}/100] {actor:<30} → {actor_saved} faces saved")

print(f"\n{'='*50}")
print(f"Total saved      : {total_saved}")
print(f"No face found    : {no_face}")
print(f"Failed (error)   : {total_failed}")
print(f"Detection rate   : {total_saved/(total_saved+no_face+total_failed)*100:.1f}%")