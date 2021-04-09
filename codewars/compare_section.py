import unittest
from test_code import Test
import math


# def make_class(*args):
#     diction = {}
#     for item in args:
#         diction[item] = None


def make_class(*args):
    class MyClass:
        name_attr = args
        def __init__(self, *args, **kwargs):
            if args:
                for item in range(len(self.name_attr)):
                    self.__dict__[self.name_attr[item]] = args[item]
    return MyClass
    # return type("MyClass", (object,),
    #             {"name": None, "species": None, "age": None, "health": None, "weight": None, "color": None})


class Dictionary():
    def __init__(self):
        self.diction = {}

    def newentry(self, word, definition):
        self.diction[word] = definition

    def look(self, key):
        return self.diction[key] if self.diction.get(key) else "Can't find entry for Banana"


def split_the_bill(x):
    listok = [v for k, v in x.items()]
    summ = sum(listok) / len(listok)
    for k, v in x.items():
        x[k] = v - summ
    return x


def compare(s1, s2):
    slist = list(map(int, s1.split('.')))
    dlist = list(map(int, s2.split('.')))
    slen = len(slist)
    dlen = len(dlist)
    if slen > dlen:
        dlist = dlist + [0] * (slen - dlen)
    elif dlen > slen:
        slist = slist + [0] * (dlen - slen)
        slen = dlen
    for item in range(slen):
        if slist[item] > dlist[item]:
            return 1
        elif slist[item] < dlist[item]:
            return -1
    return 0

def sum(*args):
    sum = 0
    for item in args:
        sum += int(item) if type(item) is int else 0
    return sum


if __name__ == '__main__':
    # test.describe('Example test cases')
    # print(compare('1', '2'), -1)
    # print(compare('1.1', '1.2'), -1)
    # print(compare('1.1', '1'), 1)
    # print(compare('1.2.3.4', '1.2.3.4'), 0)
    # print(compare('96.19.25.82.36.84.22.96.37', '96.19.25.82.36.84.22.96.37.12.63.21.57.67.48.64.37.10'), -1)
    # print(split_the_bill({'A': 20, 'B': 15, 'C': 10}), {'A': 5, 'B': 0, 'C': -5})
    # Animel = make_class("name", "species", "age", "health", "weight", "color")
    # anima = Animel("Bob", "Dog", 5, "good", "50lb", "brown")
    # print(anima.name)

    print(sum(1, "2", 3), 4)
