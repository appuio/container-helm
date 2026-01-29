IMAGE_TAG ?= latest


.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "(: ).*?## "}; {gsub(/\\:/,":", $$1)}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: docker-build
docker-build: ## Build docker images with latest tag
	docker build -t "ghcr.io/appuio/helm:$(IMAGE_TAG)" .

.PHONY: docker-push
docker-push:
	docker push "ghcr.io/appuio/helm:$(IMAGE_TAG)"

.PHONY: docker-build-v4
docker-build-v4: ## Build docker images with latest tag
	docker build -t "ghcr.io/appuio/helm-v4:$(IMAGE_TAG)" . -f Dockerfile.v4

.PHONY: docker-push-v4
docker-push-v4:
	docker push "ghcr.io/appuio/helm-v4:$(IMAGE_TAG)"
