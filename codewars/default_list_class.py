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

class DefaultList(list):

    def __init__(self, list, default_value):
        super().__init__()
        self.list = list
        self.default_element = default_value

    def __getitem__(self, i):
        try:
            return self.list[i]
        except IndexError as e:
            return self.default_element




if __name__ == '__main__':
    list_default = DefaultList([1, 4, 455, 6, '15'], '0')
    print(list_default[1])
    print(list_default[5])
    print(list_default[-10])
