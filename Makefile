include include.mk

.DEFAULT_GOAL := help

install:
	conda env update -f environment.yml

train-playground: preprocess
	python ddp_train_nerf.py --config configs/playground/playground.txt

preprocess: download
	sh +x bin/preprocess_data.sh data/playground

download:
	gsutil -m cp -r gs://lucas.netdron.es/data .
