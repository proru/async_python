import requests
from time import time


def get_file(url):
    r = requests.get(url, allow_redirects=True)
    return r


def write_file(response):
    filename = response.url.split('/')[-1]
    filename = "../assets/new file " + str(time()) + ".jpeg"
    with open(filename, 'wb') as file:
        file.write(response.content)


def main():
    t0 = time()

    url = 'https://www.fillmurray.com/640/360'
    for i in range(100):
        write_file(get_file(url))

    print(time() - t0)


if __name__ == '__main__':
    main()
