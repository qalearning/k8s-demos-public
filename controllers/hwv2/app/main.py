from fastapi import FastAPI
import uvicorn
 
app = FastAPI()
 
 
@app.get("/")
async def hello_world():
    return "Hello World (v2)"
 
if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=12345)