from datetime import datetime

# from marshmallow import Schema, fields
from typing import Optional, List
from pydantic import BaseModel, Field


class Customer(BaseModel):
  id: Optional[int]
  name: Optional[str] = Field(
    None, title="The name of the customer"
  )
  created_at: datetime = datetime.now()

  def __repr__(self):
    return '<Customer(name={self.name!r},created={self.created_at!r})>'.format(self=self)


class CustomerList(BaseModel):
  __root__: List[Customer]

# class CustomerSchema(Schema):
#   name = fields.Str()
#   id = fields.Integer()
#   created_at = fields.Date()