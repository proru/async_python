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
    stack.extend([m, n, f])

    while len(stack) > 2:
        f = stack.pop()
        n = stack.pop()
        m = stack.pop()
        print(stack)
        if m <= 0:
            stack.append(n + f)
        elif n <= 0:
            stack.extend([m - f, 1, f])
        else:
            stack.extend([m - f, m, n - f])
        print(stack)

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

    print(hackermann(0, 1, 1))

    print(ack_ix(0, 1, 1))

    print(hackermann(0, 2, 1))
    print(ack_ix(0, 2, 1))
    print(ack_ix(1, 2, 1))
    print(hackermann(1, 2, 1))
