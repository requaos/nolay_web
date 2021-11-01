.PHONY: build release build-docker yarn-docker-build

BUILD_HASH ?= $(shell git rev-parse --short=8 HEAD)
RAW_BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)
BRANCH_NAME := $(shell echo ${RAW_BRANCH_NAME} | sed 's/\//-/g' | sed 's/_/-/g')
VUE_APP_VERSION := $(BUILD_HASH)
DOCKER := docker
CONTAINER_NAME := nolay-web-$(BUILD_HASH)

deps:
	echo "Installing Vue CLI"
	yarn global add @vue/cli
	yarn install

lint: deps
	yarn lint:ci

test: deps lint
	yarn unit

build: deps
	@echo "Build hash to inject is $(BUILD_HASH)"
	@(VUE_APP_VERSION=$(VUE_APP_VERSION) yarn build)
	@echo "Finished building"

init_container:
	- @touch /app/dist
	@mkdir -p /app/node_modules/.cache
	@mkdir -p ${PACKAGE_DIR}/node_modules/.cache
	- @cp -R ${PACKAGE_DIR}/node_modules/.cache /app/node_modules
	- @cp -R ${PACKAGE_DIR}/tests/cache /app/tests

ci_test: init_container
	@yarn test:ci

build-docker:
	- @rm -rf ./dist
	- @mkdir -p node_modules/.cache
	- @$(DOCKER) rm $(CONTAINER_NAME)
	@$(DOCKER) build -t $(CONTAINER_NAME) .

yarn-docker-build: build-docker
	@$(DOCKER) run --name $(CONTAINER_NAME) $(CONTAINER_NAME) bash -c "yarn build"

yarn-docker-serve: build-docker
	@$(DOCKER) run --name $(CONTAINER_NAME) -p 8080:8080 $(CONTAINER_NAME) bash -c "yarn serve"
