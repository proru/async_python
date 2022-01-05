import datetime
import time


def counting_str(temp):
    sum = 0
    for idx, item in enumerate(temp):
        if (idx+1) % 2 == 0:
            item = item.replace(' ', '', 5)
            sum += int(item)
            print(item)


if __name__ == '__main__':
    import requests
    response = requests.post('http://127.0.0.1:8000/')
    print('hello')