import datetime
import time
import signal
from contextlib import contextmanager
from typing import List, Tuple, NoReturn
import cProfile
import os


class TimeoutException(Exception):
    pass


@contextmanager
def context_manager_timeout(timeout_in_seconds=1200):
    def signal_handler(signum, frame):
        raise TimeoutException("Timed out for handling function!")
    signal.signal(signal.SIGALRM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)
    print('pid:', os.getpid())
    signal.alarm(timeout_in_seconds)
    try:
        yield
    finally:
        # off alarm
        signal.alarm(0)


def counting_str(temp):
    sum = 0
    for idx, item in enumerate(temp):
        if (idx+1) % 2 == 0:
            item = item.replace(' ', '', 5)
            sum += int(item)
            print(item)


def function_test(test: List, new: List):
    pass


def profile(func):
    """Decorator for run function profile"""
    def wrapper(*args, **kwargs):

        profiler = cProfile.Profile()
        result = profiler.runcall(func, *args, **kwargs)
        BASE_DIR = os.path.dirname(os.path.abspath(os.path.join(__file__, os.pardir)))
        profile_filename = BASE_DIR + '/' + func.__name__ + '.snapshot'
        profiler.dump_stats(profile_filename)
        return result
    return wrapper


@profile
def new_test():
    for num in range(10000):
        num = str(num) + ',0'
        try:
            num = float(num)
        except Exception as e:
            num = num.replace(',', '.')
        num = float(num)


@profile
def first_test():
    for num in range(10000):
        init_num = num = str(num) + ',0'
        num = float(num.replace(',', '.'))


@profile
def func_test():
    try:
        with context_manager_timeout(timeout_in_seconds=360):
            for jtem in range(1000):
                test = [item * item for item in range(100)]
                print('pid:', os.getpid())
                print('pid:', datetime.datetime.now(), test)
                time.sleep(5)
    except TimeoutException as e:
        print(e)

    # multi = MultiConsumer(*consumers)
    # multi.run()


if __name__ == '__main__':
    import requests
    # if List == function_test.__annotations__.get('test') and List == function_test.__annotations__.get('new'):
    #     print('ok')
    # response = requests.post('http://127.0.0.1:8000/')
    # import uuid
    # import random
    # data = {uuid.uuid4(): item % 17 for item in range(1, 100)}
    # # list_data = list(data.keys())[:12]
    # # print(data)
    # number_partition = 0
    # amount_partition = 10
    # for item in range(200):
    #     number_partition = number_partition % amount_partition + 1
    #     temp = min(data, key=lambda unit: data[unit])
    #     print('key', temp)
    #     print(data[temp])
    #     data[temp] = data[temp] + 1
    #     print(data[temp])
    # # func_test()
    first_test()
    new_test()
    print('hello')