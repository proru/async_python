import asyncio
import aiohttp
from time import time


async def new_result(session):
    async_tasks = []
    result = []
    print(asyncio.all_tasks())
    tasks = create_new()
    for func, param in tasks:
        temp = await func(**param, session=session)
        # task = asyncio.create_task(func(**param, session=session))
        # temp = await task
        result.append(temp)
    return result


async def fetch_content(url, session):
    async with session.get(url, allow_redirects=True) as response:
        data = await response.read()
        return data


async def execute_concurrency(tasks):
    async_tasks = []
    async with aiohttp.ClientSession() as session:
        for function, params in tasks:
            task = asyncio.create_task(function(**params, session=session))
            async_tasks.append(task)

        return await asyncio.gather(*async_tasks)


def create_base():
    tasks = []
    for i in range(1):
        task = (new_result, {})
        tasks.append(task)
    return tasks


def create_new():
    # url = "https://www.fillmurray.com/640/360"
    url = "https://www.fillmurray.com/1000/500"
    tasks = []
    for i in range(20):
        task = (fetch_content, {'url': url})
        tasks.append(task)
    return tasks


if __name__ == '__main__':
    t0 = time()
    tasks = create_base()
    temp = asyncio.run(execute_concurrency(tasks))
    print(time() - t0)
    print('end')
