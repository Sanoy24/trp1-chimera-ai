IMAGE_NAME=chimera-dev

.PHONY: setup test spec-check shell lint security

## Build the Docker image
setup:
	docker build -t $(IMAGE_NAME) .

## Run tests inside Docker (even if failing)
test:
	docker run --rm $(IMAGE_NAME) \
		pytest || true

lint:
	uv run ruff check src/
	uv run mypy src/

security:
	uv run bandit -r .

spec-check:
	@echo "Running spec compliance check..."
	@test -d specs || (echo "❌ specs/ directory missing" && exit 1)
	@echo "✅ specs/ directory present"
	@grep -R "TODO" specs || echo "ℹ️ No pending spec TODOs found"


shell:
	docker run --rm -it $(IMAGE_NAME) bash

clean:
	rm -rf .venv
	find . -name "__pycache__" -delete
