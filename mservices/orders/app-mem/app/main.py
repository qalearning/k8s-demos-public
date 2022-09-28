from fastapi import FastAPI, HTTPException
from starlette.responses import Response, PlainTextResponse
from starlette_prometheus import metrics, PrometheusMiddleware
from model.order import Order, OrderList, OrderItem, OrderItemList
import uvicorn
import os

app = FastAPI()
app.add_middleware(PrometheusMiddleware)
app.add_route("/metrics/", metrics)


customers = CustomerList(__root__=[
    Customer(id=1, name="Acme Corp"),
    Customer(id=2, name="Zeta Inc.")
])


@app.get('/healthz')
async def healthz():
    if len(customers.__root__) == 0:
        return Response(content='', status_code=503)
    return PlainTextResponse("ok")


@app.get('/readyz')
async def readyz():
    return PlainTextResponse("ok")


@app.get("/", response_model=CustomerList)
async def get_customers():
    return customers


@app.get("/{id}", response_model=Customer)
async def get_customer(id: int):
    customer = next((c for c in customers.__root__ if c.id == id), None) # filter(lambda c: c.id == id, customers)
    if customer == None:
        raise HTTPException(status_code=404, detail="Customer {} not found".format(id))
    return customer


@app.post("/", status_code=201)
async def add_customer(customer: Customer):
    id = len(customers.__root__) + 1
    print(id)
    new_cust = Customer(id=id, name=customer.name)
    customers.__root__.append(new_cust)
    return new_cust


@app.delete('/{id}', status_code=204)
async def delete_customer(id: int):
    customers.__root__ = [c for c in customers.__root__ if c.id != id]
    return Response(status_code=204)


if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=12345)