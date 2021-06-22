###
# -------------
#  Base make commands for NetDrones mip-NeRF repo
#  @lucas
#  -----------
###

.DEFAULT_GOAL := help
TIME = "$$(date +'%Y%m%d-%H%M%S')"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, %%2}'

gcp:
	gcloud beta compute instances create ubuntu-cuda-110-${TIME} \
	  --project netdrones \
	  --zone us-central1-c \
	  --custom-cpu 16 \
	  --custom-memory 64 \
	  --accelerator type=nvidia-tesla-v100,count=4 \
	  --maintenance-policy TERMINATE --restart-on-failure \
	  --source-machine-image ubuntu-cuda110

connect:
	gcloud compute ssh "$$(gcloud compute instances list --filter="name~'110'" | head -n 1 | awk '{print $$2}')" \
	  --project netdrones \
	  --zone us-central1-c

gcp-lite:
	gcloud beta compute instances create ubuntu-eval-${TIME} \
	  --project netdrones \
	  --zone us-central1-c \
	  --custom-cpu 8 \
	  --custom-memory 32 \
	  --accelerator type=nvidia-tesla-v100,count=2 \
	  --maintenance-policy TERMINATE --restart-on-failure \
	  --source-machine-image ubuntu-cuda110

connect-lite:
	gcloud compute ssh "$$(gcloud compute instances list --filter="name~'eval'" | head -n 1 | awk '{print $$2}')" \
	  --project netdrones \
	  --zone us-central1-c
