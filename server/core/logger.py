import logging

from server.core.config import get_settings

settings = get_settings()

gunicorn_logger = logging.getLogger("gunicorn.error")
logger = logging.getLogger(settings.SERVICE_NAME)
logger.handlers = gunicorn_logger.handlers
logger.setLevel(gunicorn_logger.level)
logger.propagate = False

formatter = logging.Formatter(
    "[%(asctime)s] [%(levelname)s] [%(module)s] %(message)s",
    "%d/%m/%Y %I:%M:%S %p",
)

for handler in logger.handlers:
    handler.setFormatter(formatter)
