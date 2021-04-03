# The collections module has defaultdict, which gives you a default value for trying to get the
# value of a key which does not exist in the dictionary instead of raising an error. Why not do this for a list?
#
# Your job is to create a class (or a function which returns an object) called DefaultList.
# The class will have two parameters to be given: a list, and a default value. The list will
# obviously be the list that corresponds to that object. The default value will be returned any
# time an index of the list is called in the code that would normally raise an error (i.e. i > len(list) - 1 or i < -len(list)).
# This class must also support the regular list functions extend, append, insert, remove, and pop.
#
# Because slicing a list never raises an error (slicing a list between two indexes that are not a part of the list returns [],
# slicing will not be tested for.
#
# Example
# lst = DefaultList(['hello', 'abcd', '123', 123, True, False], 'default_value')
# lst[4] = True
# lst[80] = 'default_value'
# lst.extend([104, 1044, 4066, -2])
# lst[9] = -2
from typing import Iterable


class DefaultListBest(list):

    def __init__(self, list_init, default_value=None):
        super().__init__(list_init)
        self.default_value = default_value

    def __getitem__(self, item):
        try:
            return super().__getitem__(item)
        except IndexError as e:
            return self.default_value


class DefaultList:
    list = []
    default_value = None

    def __init__(self, list=[], default_value=None):
        self.list = list
        self.default_value = default_value

    def __repr__(self):
        print(self.list)
        print(self.default_value)

    def __str__(self):
        return str(self.list) + ' | ' + str(self.default_value)

    def extend(self, iterable) -> None:
        print('extend', self.list)
        print('iterable', iterable)
        if self.list or self.list == []:
            self.list.extend(iterable)

    def append(self, object) -> None:
        print('append', self.list)
        print('object ', object)
        if self.list or self.list == []:
            self.list.append(object)

    def insert(self, __index: int, __object) -> None:
        print('insert', self.list)
        if self.list or self.list == []:
            self.list.insert(__index, __object)

    def remove(self, __value) -> None:
        print('remove', self.list)
        print('value', __value)
        if self.list:
            self.list.remove(__value)

    def pop(self, __index: int = ...):
        print('pop', self.list)
        if self.list:
            return self.list.pop(__index)

    def __getitem__(self, i):
        print('get_item', self.list)
        try:
            if self.list:
                return self.list[i]
            else:
                return self.default_value
        except IndexError as e:
            return self.default_value


if __name__ == '__main__':
    # list_default = DefaultList([1, 4, 455, 6, '15'], 'you')
    # list_default3 = DefaultList(
    #     ['fGcLAULtM ho', True, 8227, 6583, 'waGu', 'y', 'ARwxlNOh ', 'VQKhPchkQScwV', 'tMod', True, 6309, 798, True,
    #      False, False, 'aLBTuD M'], "A DyMDlwec")
    # list_default2 = DefaultList(
    #     ['i', True, 'a', 7542, 4083, 'MwZsOsiLPY', True, 4735, True, True, 3100, 'ZB', 'CvpjF', 'N', 'as', 479, 2149],
    #     3510)
    #
    # print(list_default)
    # print(str(list_default))
    # list_default.extend([104, 1044, 4066, -2])
    # print(list_default)
    # print(list_default[12])
    # list = [1, 4, 455, 6, '15']
    # print(list.extend([104, 1044]))
    # print(list_default3[-7])
    # print(['fGcLAULtM ho', True, 8227, 6583, 'waGu', 'y', 'ARwxlNOh ', 'VQKhPchkQScwV', 'tMod', True, 6309, 798, True,
    #        False, False, 'aLBTuD M'][-7])
    # print(list_default2[13])
    list_default4 = DefaultList(
        [1, 3, 4, 7, 2, 34, 3, 23, 'hello', 'lists', 'word', 344],
        'def')
    print(list_default4.append(233344455))
    print(list_default4)

    # print(list_default[1])
    # print(list_default[5])
    # print(list_default[-10])
