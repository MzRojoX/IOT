# Mako template file. Note that the variables available here are not the same
# as those available to the main config file.

<%!
import re
%>

"""${message}"""

from alembic import op
import sqlalchemy as sa
${imports if imports else ""}

# revision identifiers
revision = "${up_revision}"
down_revision = "${down_revision}"
branch_labels = ${repr(branch_labels)}
depends_on = ${repr(depends_on)}

def upgrade():
    ${upgrades if upgrades else "pass"}

def downgrade():
    ${downgrades if downgrades else "pass"}
