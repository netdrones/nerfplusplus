#!/bin/bash

WORKSPACE_PATH=$1
NUM_GPUS=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)

colmap feature_extractor --database_path $WORKSPACE_PATH/database.db \
  --image_path $WORKSPACE_PATH/images \
  --ImageReader.single_camera 1 \
  --ImageReader.camera_model SIMPLE_RADIAL \
  --SiftExtraction.max_image_size 5000 \
  --SiftExtraction.estimate_affine_shape 0 \
  --SiftExtraction.max_num_features 16384 \

colmap exhaustive_matcher --database_path $WORKSPACE_PATH/database.db \

mkdir -p $WORKSPACE_PATH/sparse

colmap mapper \
  --database_path $WORKSPACE_PATH/database.db \
  --image_path $WORKSPACE_PATH/images \
  --output_path $WORKSPACE_PATH/sparse \

mkdir -p $WORKSPACE_PATH/dense

colmap image_undistorter \
  --image_path $WORKSPACE_PATH/images \
  --input_path $WORKSPACE_PATH/sparse/0 \
  --output_path $WORKSPACE_PATH/dense \
  --output_type COLMAP \
  --max_image_size 2000

python data_utils/generate_poses.py $WORKSPACE_PATH
python data_utils/data_loader.py $WORKSPACE_PATH
rm -r $WORKSPACE_PATH/posed_images $WORKSPACE_PATH/dense $WORKSPACE_PATH/sparse $WORKSPACE_PATH/database.db
