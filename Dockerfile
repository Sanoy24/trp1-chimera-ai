FROM python:3.11-slim

# System Setup
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -Ls https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:${PATH}"


COPY pyproject.toml uv.lock* ./
RUN uv sync --frozen || uv sync


COPY . .

# Default Command
CMD ["bash"]
