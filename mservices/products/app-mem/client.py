#!/bin/python3
import grpc
from products_pb2 import Category, ProductListRequest
from products_pb2_grpc import ProductsStub

req = ProductListRequest(category=Category.DVD, max_results=3)

channel = grpc.insecure_channel("localhost:50051", options=(('grpc.enable_http_proxy', 0),))
client = ProductsStub(channel)
response = client.ListProducts(req)
print(response)