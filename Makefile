.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, %%2}'

install:
	conda env update -f environment.yml

train-playground: preprocess
	python ddp_train_nerf.py --config configs/playground/playground.txt

preprocess: download
	sh +x bin/preprocess_data.sh data/playground

download:
	gsutil -m cp -r gs://lucas.netdron.es/data .
