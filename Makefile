include include.mk

.DEFAULT_GOAL := help

install:
	conda env update -f environment.yml

train-picnic: preprocess-picnic
	python ddp_train_nerf.py --config configs/picnic_nerf_001/picnic_nerf_001.txt

preprocess-picnic: download-picnic
	sh +x bin/preprocess_data.sh data/picnic_nerf_001

download-picnic:
	if [ ! -d ./data/picnic ]; then gsutil -m cp -r gs://lucas.netdron.es/picnic_nerf_001 ./data/; fi

playground: train-playground

train-playground: preprocess-playground
	python ddp_train_nerf.py --config configs/playground/playground.txt

preprocess-playground: download-playground
	sh +x bin/preprocess_data.sh data/playground

download-playground:
	if [ ! -d ./data/playground ]; then gsutil -m cp -r gs://lucas.netdron.es/data .; fi
