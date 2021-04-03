# In this Kata, you have to design a simple routing class for a web framework.
#
# The router should accept bindings for a given url, http method and an action.
#
# Then, when a request with a bound url and method comes in, it should return the result of the action.
#
# Example usage:
#
# router = Router()
# router.bind('/hello', 'GET', lambda: 'hello world')
#
# router.runRequest('/hello', 'GET') // returns 'hello world'
# When asked for a route that doesn't exist, router should return:
#
# 'Error 404: Not Found'

def newest():
    print(1, 3, 4, 5, 6)
    return 'Hello'


class Router(object):
    dict_router = {'route': {'GET': None}}

    def __init__(self):
        pass

    def bind(self, route, method, function):
        self.dict_router[route] = {method: function}

    def runRequest(self, route, method):
        try:
            return self.dict_router[route][method]()
        except KeyError as e:
            return 'Error 404: Not Found'


if __name__ == '__main__':
    router = Router()
    router.bind('/hello', 'GET', lambda: 'hello world')
    print(router.runRequest('/hello', 'GET'))
    router.bind('/hello', 'POST', newest)
    print(router.runRequest('/hello', 'POST'))
    print(router.runRequest('hello', 'POST'))
