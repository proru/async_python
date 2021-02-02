import requests
from requests import Request, Session
from requests_middleware import MiddlewareHTTPAdapter
from requests_middleware.contrib.httpcacheware import CacheMiddleware
from requests_middleware.contrib.throttleware import \
    ThrottleMiddleware, RequestsPerHourThrottler
from abc import ABC, abstractmethod

session = requests.Session()
middlewares = [
    CacheMiddleware(),
    ThrottleMiddleware(RequestsPerHourThrottler(10)),
]
adapter = MiddlewareHTTPAdapter(middlewares)
session.mount('http://', adapter)
session.mount('https://', adapter)

s = Session()
url = 'http://www.google.ru'

headers = {
    'Accept': '*/*'
}
req = Request('GET', url, headers=headers)
prepped = req.prepare()









# do something with prepped.body


# prepped.body = 'No, I want exactly this as the body.'

# do something with prepped.headers
# del prepped.headers['Content-Type']

resp = session.send(prepped)

print(resp.status_code)
