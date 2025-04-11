import typing as t
import sqlalchemy as sa
import sqlalchemy.orm as so


class TableBase(so.DeclarativeBase):
    pass


class Item(TableBase):
    __tablename__ = "items"
    id: so.Mapped[int] = so.mapped_column(primary_key=True)
    name: so.Mapped[str] = so.mapped_column(sa.String)
    description: so.Mapped[str] = so.mapped_column(sa.String)
    status: so.Mapped[str] = so.mapped_column(sa.String)