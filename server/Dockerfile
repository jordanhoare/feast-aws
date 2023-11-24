FROM python:3.10-slim

WORKDIR /app

ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONDONTWRITEBYTEapp 1
ENV PYTHONUNBUFFERED True
ENV PYTHONBUFFERED 1

RUN apt-get update && \
    apt-get install -y libpq-dev gcc build-essential wkhtmltopdf curl libxrender1 libfontconfig1 libxext6 && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL -k https://install.python-poetry.org | python - && \
    poetry config virtualenvs.create false

COPY ../pyproject.toml ../poetry.lock* /app/
RUN poetry install --no-interaction --ansi --no-root

COPY ../repository /app/repository
COPY ../server /app/server

EXPOSE 8000
CMD ["poetry", "run", "python", "-m", "server"]