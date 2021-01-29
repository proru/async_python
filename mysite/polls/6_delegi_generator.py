from inspect import getgeneratorstate


def coroutine(func):
    def inner(*args, **kwargs):
        g = func(*args, **kwargs)
        g.send(None)
        return g

    return inner


def subgen_old():
    x = 'Ready to accept message'
    message = yield x
    print('Subgen received:', message)


class BlaBlaException(Exception):
    pass


def subgen():
    for i in 'oleg':
        yield i


# def delegator(g):
#     for i in g:
#         yield i

# не нужно когда используем конструкцию yield from
# @coroutine
def subgenerator():
    # посчитать количество кругов в итерации
    while True:
        try:
            message = yield
        except BlaBlaException:
            print('Subgenerator blablaexception')
        except StopIteration:
            break
        else:
            print('------------------', message)
    return 'Retured from subgen()'


@coroutine
def delegator(g):
    # while True:
    #     try:
    #         data = yield
    #         g.send(data)
    #     except BlaBlaException as e:
    #         g.throw(e)
    result = yield from g
    print(result)


def generator():
    yield from 'oleg'


sg = subgenerator()
g = delegator(sg)
gen = generator()
