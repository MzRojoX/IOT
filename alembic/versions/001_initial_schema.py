"""Initial migration

Revision ID: 001_initial
Revises: 
Create Date: 2025-12-01

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'zonas',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('nombre', sa.String(length=100), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('nombre')
    )
    op.create_index(op.f('ix_zonas_id'), 'zonas', ['id'], unique=False)

    op.create_table(
        'eventos_carros',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('zona_id', sa.Integer(), nullable=False),
        sa.Column('sensor_inicial', sa.Integer(), nullable=False),
        sa.Column('sensor_final', sa.Integer(), nullable=False),
        sa.Column('hora_inicio', sa.DateTime(), nullable=False),
        sa.Column('hora_fin', sa.DateTime(), nullable=True),
        sa.Column('estado', sa.Enum('activo', 'cerrado', name='estadoevento'), nullable=False),
        sa.ForeignKeyConstraint(['zona_id'], ['zonas.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_eventos_carros_id'), 'eventos_carros', ['id'], unique=False)

    op.create_table(
        'eventos_animales',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('zona_id', sa.Integer(), nullable=False),
        sa.Column('hora', sa.DateTime(), nullable=False),
        sa.Column('hora_fin', sa.DateTime(), nullable=True),
        sa.Column('estado', sa.Enum('activo', 'cerrado', name='estadoevento'), nullable=False),
        sa.ForeignKeyConstraint(['zona_id'], ['zonas.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_eventos_animales_id'), 'eventos_animales', ['id'], unique=False)

    op.create_table(
        'mediciones',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('zona_id', sa.Integer(), nullable=False),
        sa.Column('distancia_1', sa.Float(), nullable=False),
        sa.Column('distancia_2', sa.Float(), nullable=False),
        sa.Column('distancia_3', sa.Float(), nullable=False),
        sa.Column('distancia_4', sa.Float(), nullable=False),
        sa.Column('movimiento', sa.Boolean(), nullable=False),
        sa.Column('luz', sa.Integer(), nullable=False),
        sa.Column('humedad', sa.Float(), nullable=False),
        sa.Column('temperatura', sa.Float(), nullable=False),
        sa.Column('hora', sa.DateTime(), nullable=False),
        sa.Column('evento_carro_id', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['evento_carro_id'], ['eventos_carros.id'], ),
        sa.ForeignKeyConstraint(['zona_id'], ['zonas.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_mediciones_id'), 'mediciones', ['id'], unique=False)

    op.create_table(
        'alertas',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('evento_carro_id', sa.Integer(), nullable=False),
        sa.Column('evento_animal_id', sa.Integer(), nullable=False),
        sa.Column('hora', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['evento_animal_id'], ['eventos_animales.id'], ),
        sa.ForeignKeyConstraint(['evento_carro_id'], ['eventos_carros.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_alertas_id'), 'alertas', ['id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_alertas_id'), table_name='alertas')
    op.drop_table('alertas')
    op.drop_index(op.f('ix_mediciones_id'), table_name='mediciones')
    op.drop_table('mediciones')
    op.drop_index(op.f('ix_eventos_animales_id'), table_name='eventos_animales')
    op.drop_table('eventos_animales')
    op.drop_index(op.f('ix_eventos_carros_id'), table_name='eventos_carros')
    op.drop_table('eventos_carros')
    op.drop_index(op.f('ix_zonas_id'), table_name='zonas')
    op.drop_table('zonas')
