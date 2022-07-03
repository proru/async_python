import datetime
import time
from contextlib import contextmanager


class TimeoutException(Exception): pass


def fun_while():
    while True:
        time.sleep(1)
        print('time ', time.time())


@contextmanager
def context_manager_timeout(seconds=10):
    def signal_handler(signum, frame):
        raise TimeoutException("Timed out!")
    signal.signal(signal.SIGALRM, signal_handler)
    signal.alarm(seconds)
    try:
        yield
    finally:
        # off alarm
        signal.alarm(0)


if __name__=='__main__':
    import os
    import signal

    # os.killpg(457721, signal.SIGINT)
    # try:
    import hashlib
    s = str(datetime.datetime.now()) + '12'
    temp = hashlib.sha1(s.encode("utf-8")).hexdigest()
    print(temp)
    print(len(str(temp)))
    #     with context_manager_timeout(10):
    #        fun_while()
    # except TimeoutException as e:
    #     print("Timed out!")
