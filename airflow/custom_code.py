# Bad pattern with circular imports
from sqlalchemy import Table, MetaData, Column, Integer

# Delayed import to avoid circular import
def create_table():
    from sqlalchemy import Table, MetaData, Column, Integer
    metadata = MetaData()
    return Table(
        'xcom', metadata,
        Column('id', Integer, primary_key=True),
        extend_existing=True  # Avoids redefinition conflicts
    )