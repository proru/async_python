import math
import sys

import types

def import_code(code, name):
    # create blank module
    module = types.ModuleType(name)
    # populate the module with code
    exec(code, module.__dict__)
    return module



def load_everything_from(module_names):
    g = globals()
    for module_name in module_names:
        m = __import__(module_name)
        names = getattr(m, '__all__', None)
        if names is None:
            names = [name for name in dir(m) if not name.startswith('_')]
        for name in names:
            g[name] = getattr(m, name)


def hackermann(m, n, f):
    if m <= 0:
        return n + f
    if m > 0 and n <= 0:
        return hackermann(m - f, 1, f)
    if m > 0 and n > 0:
        return hackermann(m - f, hackermann(m, n - f, f), f)


from collections import deque


def ack_ix(m, n, f=None):
    stack = deque([])
    stack.extend([m, n])

    while len(stack) > 1:
        print(stack)
        n, m = stack.pop(), stack.pop()

        if m == 0:
            stack.append(n + f)
        elif m == 1:
            stack.append(n + 2)
        elif m == 2:
            stack.append(2 * n + 3)
        elif m == 3:
            stack.append(2 ** (n + 3) - 3)
        elif n == 0:
            stack.extend([m - f, 1])
        else:
            stack.extend([m - f, m, n - 1])

    return stack[0]

if __name__ == '__main__':
    print('hello')
    print(sys.path)
    # # load_everything_from(math)
    # code = """def testFunc():
    #     print('spam!')
    # """
    # m = import_code(code, 'test')
    # m.testFunc()

    print(ack_ix(1,2))
    print(ack_ix(1,4))
    print(ack_ix(1,3))
    print(ack_ix(3,2))
    print(ack_ix(3,0))
    print(ack_ix(2,1))
    print(ack_ix(0,2))

