IMAGE_TAG ?= latest


.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "(: ).*?## "}; {gsub(/\\:/,":", $$1)}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: docker-build
docker-build: ## Build docker images with latest tag
	docker build -t "docker.io/appuio/helm:$(IMAGE_TAG)" -t "quay.io/appuio/helm:$(IMAGE_TAG)" .

.PHONY: docker-push
docker-push: ## Push docker images to docker.io and quay.io (requires to be logged in to both registries)
	docker push "docker.io/appuio/helm:$(IMAGE_TAG)"
	docker push   "quay.io/appuio/helm:$(IMAGE_TAG)"
