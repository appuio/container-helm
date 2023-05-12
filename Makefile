IMAGE_TAG ?= latest


.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "(: ).*?## "}; {gsub(/\\:/,":", $$1)}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: docker-build
docker-build: ## Build docker images with latest tag
	docker build -t "ghcr.io/appuio/helm:$(IMAGE_TAG)" -t "quay.io/appuio/helm:$(IMAGE_TAG)" .

.PHONY: docker-push
docker-push: ## Push docker images to quay.io (requires to be logged in)
	docker push "ghcr.io/appuio/helm:$(IMAGE_TAG)"
	docker push "quay.io/appuio/helm:$(IMAGE_TAG)"
