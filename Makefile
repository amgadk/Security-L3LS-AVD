.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

########################################################
# DC1 1
########################################################

.PHONY: ping-site-1
ping-site-1: ## Ping Nodes
	ansible-playbook playbooks/ping.yml -i sites/site_1/inventory.yml -e "target_hosts=SITE1_FABRIC"

.PHONY: build
build: ## Build Configs
	ansible-playbook playbooks/build_fabric.yml -i inventory.yml

.PHONY: deploy
deploy: ## Deploy Configs via CloudVision
	ansible-playbook playbooks/deploy_cv.yml -i inventory.yml

.PHONY: validate-site-1
validate-site-1: ## Validate network state
	ansible-playbook playbooks/validate.yml -i sites/site_1/inventory.yml -e "target_hosts=SITE1_FABRIC"


########################################################
# Hosts - Lab Prep
########################################################

.PHONY: preplab
preplab: ## Deploy Configs via eAPI
	ansible-playbook playbooks/preplab.yml -i host_configs/inventory.yml -e "target_hosts=LAB"

########################################################
# Build and deploy all sites
########################################################

.PHONY: all
all: build-site-1 build-site-2 deploy-site-1 deploy-site-2
