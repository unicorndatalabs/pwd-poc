# Magic Makefile Help
.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Variables
# ---------
MAJOR=0
MINOR=1
APP_NAME = psql-sakilla

# Take variable from secrets, if empty use local user
DOCKER_REPO := $(shell echo $(DOCKER_USER))
ifeq ($(DOCKER_REPO),)
DOCKER_REPO := $(shell echo $(USER))
endif

IMAGE = $(DOCKER_REPO)/$(APP_NAME)
MAJOR_TAG = $(IMAGE):$(MAJOR)
MINOR_TAG = $(IMAGE):$(MAJOR).$(MINOR)

# Docker Tasks
# ------------
build: ## Build container
	docker build -t $(APP_NAME) .

build-nc: ## Build with no caching
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container
	docker run -i -t --rm --name="$(APP_NAME)" $(APP_NAME) $(task)

up: ## Spin up docker compose
	docker-compose -f docker-compose.debug.yml up --force-recreate -d

down: ## Shutdown docker compose
	docker-compose -f docker-compose.debug.yml down

# Tagging
# -------
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(IMAGE):latest

tag-version: ## Generate container `version` tags
	@echo 'create tags $(MAJOR_TAG) and $(MINOR_TAG)'
	docker tag $(APP_NAME) $(MAJOR_TAG)
	docker tag $(APP_NAME) $(MINOR_TAG)

# Publish
# -------
push:
	docker push $(IMAGE)

publish: build-nc tag push