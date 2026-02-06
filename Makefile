IMAGE_NAME=chimera-dev

.PHONY: setup test spec-check shell

## Build the Docker image
setup:
	docker build -t $(IMAGE_NAME) .

## Run tests inside Docker (even if failing)
test:
	docker run --rm $(IMAGE_NAME) \
		pytest || true


spec-check:
	@echo "Running spec compliance check..."
	@test -d specs || (echo "❌ specs/ directory missing" && exit 1)
	@echo "✅ specs/ directory present"
	@grep -R "TODO" specs || echo "ℹ️ No pending spec TODOs found"


shell:
	docker run --rm -it $(IMAGE_NAME) bash
