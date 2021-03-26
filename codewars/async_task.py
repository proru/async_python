import asyncio
import time


async def nested(item):
    print(item)
    list = []
    for i in range(10 ** 7):
        list.append(i)
    await asyncio.sleep(1)


async def main():
    # Schedule nested() to run soon concurrently
    # with "main()".
    items = [1, 3, 4, 6, 7]
    tasks = [nested(item) for item in items]
    # "task" can now be used to cancel "nested()", or
    # can simply be awaited to wait until it is complete:
    await asyncio.gather(*tasks)


if __name__ == '__main__':
    t0 = time.time()
    asyncio.run(main())
    t1 = time.time()
    print(t1 - t0)
    t0 = time.time()
    items = [1, 3, 4, 6, 7]
    list = []
    for item in items:
        for i in range(10 ** 7):
            list.append(i)
        print(item)
        asyncio.sleep(1)
    t1 = time.time()
    print(t1 - t0)
