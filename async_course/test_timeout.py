import time
import contextlib
import errno
import os
import signal
import datetime

from threading import Thread


class TimeoutProcessingError(Exception):
    def __init__(self, limit, message="timeout of proccesing messages"):
        self.time_limit = limit
        self.message = message
        super().__init__(self.message)


class TimeoutSignaller(Thread):
    def __init__(self, limit, handler):
        Thread.__init__(self)
        self.limit = limit
        self.running = True
        self.handler = handler
        assert callable(handler), "Timeout Handler needs to be a method"

    def run(self):
        timeout_limit = datetime.datetime.now() + datetime.timedelta(seconds=self.limit)
        while self.running:
            if datetime.datetime.now() >= timeout_limit:
                self.handler()
                self.stop_run()
                break

    def stop_run(self):
        self.running = False


class ProcessContextManager:
    def __init__(self, process, seconds=0, outhandler=None):
        self.seconds = seconds
        self.process = process
        self.outhandler = outhandler
        self.signal = TimeoutSignaller(self.seconds, self.signal_handler)

    def __enter__(self):
        self.signal.start()
        return self.process

    def __exit__(self, exc_type, exc_val, exc_tb):
        print('stop processing -------------------')
        self.signal.stop_run()
        self.process

    def signal_handler(self):
        # Make process terminate however you like
        # using self.process reference
        if self.outhandler:
            self.outhandler()
        self.__exit__(exc_type=None, exc_val=None, exc_tb=None)
        # raise Exception('hello world ')
        # raise TimeoutProcessingError(limit=self.limit)


DEFAULT_TIMEOUT_MESSAGE = os.strerror(errno.ETIME)


class timeout(contextlib.ContextDecorator):
    def __init__(self, seconds, *, timeout_message=DEFAULT_TIMEOUT_MESSAGE, suppress_timeout_errors=False):
        self.seconds = int(seconds)
        self.timeout_message = timeout_message
        self.suppress = bool(suppress_timeout_errors)

    def _timeout_handler(self, signum, frame):
        raise TimeoutError(self.timeout_message)

    def __enter__(self):
        signal.signal(signal.SIGALRM, self._timeout_handler)
        signal.alarm(self.seconds)

    def __exit__(self, exc_type, exc_val, exc_tb):
        signal.alarm(0)
        if self.suppress and exc_type is TimeoutError:
            return True


def fun_while():
    while True:
        time.sleep(1)
        print('time ', time.time())


if __name__ == '__main__':
    # func()
    temp = 'initial'

    try:
        with ProcessContextManager(process=fun_while, seconds=2) as p:
            # do stuff e.g.
            # time.sleep(20)
            p()
    except Exception as e:
        temp = e
    print('temp enter', temp)
    data = {}
    print('hello')
