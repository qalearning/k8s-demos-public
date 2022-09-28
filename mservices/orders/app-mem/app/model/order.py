from datetime import datetime

from typing import Optional, List
from pydantic import BaseModel, Field


class OrderItem(BaseModel):
  product_id: int
  product_name: str
  quantity: int
  unit_price: number
  
  def __repr__(self):
    return '<OrderItem(name={self.product_name!r},quantity={self.quantity!r})>'.format(self=self)


class OrderItemList(BaseModel):
  __root__: List[OrderItem]


class Order(BaseModel):
  id: Optional[int]
  customer_id: int # this should be a uri! ~/customers/1
  items: OrderItemList
  
  name: Optional[str] = Field(
    None, title="The name of the customer"
  )
  created_at: datetime = datetime.now()

  def __repr__(self):
    return '<Customer(name={self.name!r},created={self.created_at!r})>'.format(self=self)


class OrderList(BaseModel):
  __root__: List[Order]