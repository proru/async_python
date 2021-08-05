import tracemalloc

tracemalloc.start()

from aiohttp import web
import asyncio
import random
import logging
import sys
import aiomonitor


logger = logging.getLogger(__name__)


async def leaking(app):
    """
    Стартап утекающей корутины
    """

    stop = asyncio.Event()

    async def leaking_coro():
        """
        Утекающая корутина
        """
        data = []
        i = 0

        logger.info('Leaking: start')

        while not stop.is_set():
            i += 1
            try:
                return await asyncio.wait_for(stop.wait(), timeout=1)
            except asyncio.TimeoutError:
                pass
            # ЗДЕСЬ БУДЕМ УТЕКАТЬ!
            data.append('hi' * random.randint(10_000, 20_000))
            if i % 2 == 0:
                logger.info('Current size = %s', sys.getsizeof(data))

    leaking_future = asyncio.ensure_future(asyncio.shield(leaking_coro()))
    yield
    stop.set()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    loop = asyncio.get_event_loop()

    with aiomonitor.start_monitor(loop=loop):
        app = web.Application()
        app.cleanup_ctx.append(leaking)
        web.run_app(app, port=8000)