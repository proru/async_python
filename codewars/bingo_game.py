import random
import numpy as np


def get_bingo_card():
    arr = []
    # b = list(set(['B' + str(item) for item in np.random.randint(1, 16, 15)]))[0:5]
    # i = list(set(['I' + str(item) for item in np.random.randint(16, 31, 15)]))[0:5]
    # n = list(set(['N' + str(item) for item in np.random.randint(31, 46, 15)]))[0:4]
    # g = list(set(['G' + str(item) for item in np.random.randint(46, 61, 15)]))[0:5]
    # o = list(set(['O' + str(item) for item in np.random.randint(61, 76, 15)]))[0:5]

    b = range(1, 101)
    b = ['B' + str(item) for item in random.sample(range(1, 16), 5)]
    i = ['I' + str(item) for item in random.sample(range(16, 31), 5)]
    n = ['N' + str(item) for item in random.sample(range(31, 46), 4)]
    g = ['G' + str(item) for item in random.sample(range(46, 61), 5)]
    o = ['O' + str(item) for item in random.sample(range(61, 76), 5)]
    arr = b + i + n + g + o
    print(arr)


if __name__ == '__main__':
    get_bingo_card()
