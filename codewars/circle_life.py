import time


def func_draw(arr, x, y, n):
    arr[x][y] = 1
    for j in range(n):
        for i in range(j):
            arr[x + i][y + n - j] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1
            arr[x - i][y + n - j] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1
            arr[x + n - i - 1][y] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1
            arr[x - n + i + 1][y] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1
            arr[x + i][y - n + j] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1
            arr[x - i][y - n + j] = n * n - abs((x - i) * (y - j)) if n * n >= abs((x - i) * (y - j)) else 1


def func(arr, x, y, n):
    for i in range(100):
        for j in range(100):
            if n * n >= abs((x - i) * (y - j)):
                arr[i][j] = 1


if __name__ == '__main__':
    arr = [[0 for j in range(100)] for l in range(100)]
    print(arr)
    x = 50
    y = 50
    n = 40
    t0 = time.time()
    func_draw(arr, x, y, n)
    print(time.time() - t0)
    t0 = time.time()
    func(arr, x, y, n)
    print(time.time() - t0)
    print(arr)
