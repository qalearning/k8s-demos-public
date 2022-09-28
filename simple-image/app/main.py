from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import JSONResponse, Response, PlainTextResponse
from starlette.routing import Route
from starlette.templating import Jinja2Templates
from starlette_prometheus import metrics, PrometheusMiddleware
import uvicorn
import os

templates = Jinja2Templates(directory='/code/app/templates')

BROKEN_PATH = '/data/broke'

async def root(request):
    """massive comments everywhere"""
    accept = request.headers['accept']
    agent = request.headers['user-agent']
        
    nodename = os.getenv('NODE_NAME', 'no node')
    podname = os.getenv('POD_NAME', 'no pod')
    if podname == 'no pod':
        content = 'Hello from Docker!\n'
    else:
        content = 'Node: %s, pod: %s\n' % (nodename, podname)
    if agent.startswith('curl'):
        return PlainTextResponse(content)
    else:
        return templates.TemplateResponse('index.html',{
            'request': request,
            'nodename': nodename,
            'podname': podname
        })


async def healthz(request):
    if os.path.exists(BROKEN_PATH):
        return Response(content='', status_code=503)

    if request.headers.get('Custom-Header', '') == 'Awesome':
        return PlainTextResponse()
    else:
        return PlainTextResponse("I'm perfectly well thank you\n")


async def readyz(request):
    return PlainTextResponse("ok")


async def break_me(request):
    if os.path.exists(BROKEN_PATH) == False:
        open(BROKEN_PATH, 'a').close()
    return Response()


async def mend_me(request):
    if os.path.exists(BROKEN_PATH):
        os.remove(BROKEN_PATH)
    return Response()


routes = [
    Route('/', root),
    Route('/healthz', healthz),
    Route('/readyz', readyz),
    Route('/break_me', break_me),
    Route('/mend_me', mend_me)
]


app = Starlette(debug=True, routes=routes)

app.add_middleware(PrometheusMiddleware)
app.add_route("/metrics", metrics)

if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=8080)
