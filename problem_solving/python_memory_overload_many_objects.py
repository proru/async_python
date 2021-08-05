import tracemalloc
import aiomonitor
import time

tracemalloc.start()

import asyncio

root = {
    'prev': None,
    'next': None,
    'id': 0
}


async def leaking_func():
    current = root
    n = 0

    while True:
        print()
        n += 1

        _next = {
            'prev': current,
            'next': None,
            'id': n
        }
        current['next'] = _next
        current = _next

        await asyncio.sleep(0.1)

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    with aiomonitor.start_monitor(loop=loop):
        loop.run_until_complete(leaking_func())