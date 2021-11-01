import asyncio
import aiohttp
from time import time


def write_image(data):
    filename = '../assets/file-{}.jpeg'.format(int(time() * 1000))
    with open(filename, 'wb') as file:
        file.write(data)


async def fetch_content(url, session):
    async with session.get(url, allow_redirects=True) as response:
        data = await response.read()
        write_image(data)


async def main():
    url = "https://www.fillmurray.com/640/360"
    tasks = []

    async with aiohttp.ClientSession() as session:
        for i in range(1000):
            task = asyncio.create_task(fetch_content(url, session))
            tasks.append(task)

        await asyncio.gather(*tasks)


if __name__ == '__main__':
    t0 = time()
    asyncio.run(main())
    print(time() - t0)
