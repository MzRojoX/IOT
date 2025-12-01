"""
Alembic config module.
"""

import os
from alembic.config import Config

def get_alembic_config():
    """Obtener configuración de Alembic."""
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config = Config(os.path.join(base_dir, "alembic.ini"))
    config.set_main_option(
        "sqlalchemy.url",
        os.getenv("DATABASE_URL", "postgresql://postgres:toor@localhost:5432/iot")
    )
    return config
