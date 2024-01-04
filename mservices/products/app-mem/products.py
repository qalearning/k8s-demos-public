from concurrent import futures
import random
import grpc

from products_pb2 import (
    Category,
    Product,
    ProductListRequest,
    ProductListResponse
)
import products_pb2_grpc

products_by_category = {
    Category.BOOK: [
        Product(id=1, name="The Fellowship of the Ring", price=5.99),
        Product(id=2, name="The Two Towers", price=5.99),
        Product(id=3, name="The Return of the King", price=5.99),
    ],
    Category.CD: [
        Product(id=4, name="Jive Bunny's Greatest Hits", price=1.99),
        Product(id=5, name="Best of Black Lace", price=0.99),
        Product(id=6, name="Hoffmeister - The David Hasselhoff Collection", price=59.99),
    ],
    Category.DVD: [
        Product(id=7, name="The Omen", price=15.99),
        Product(id=8, name="Damien: Omen 2", price=15.99),
        Product(id=9, name="Omen 3: The Final Conflict", price=15.99),
    ],
}

class ProductService(
    products_pb2_grpc.ProductsServicer
):
    def ListProducts(self, request, context):
        if request.category not in products_by_category:
            context.abort(grpc.StatusCode.NOT_FOUND, "Category not found")

        products_in_category = products_by_category[request.category]
        num_results = min(request.max_results, len(products_in_category))
        products_to_return = random.sample(
            products_in_category, num_results
        )

        return ProductListResponse(products=products_to_return)
    
def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    products_pb2_grpc.add_ProductsServicer_to_server(
        ProductService(), server
    )
    server.add_insecure_port("[::]:50051")
    server.start()
    server.wait_for_termination()

if __name__ == "__main__":
    serve()