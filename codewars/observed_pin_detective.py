from typing import List, Any

from test import Test as test
from itertools import product

constant_tuple = {'1': ('2', '4', '1'), '2': ('1', '3', '5', '2'),
            '3': ('2', '6', '3'), '4': ('1', '5', '7', '4'),
            '5': ('2', '4', '6', '8', '5'), '6': ('3', '5', '9', '6'),
            '7': ('4', '8', '7'), '8': ('5', '7', '9', '0', '8'), '9': ('6', '8', '9'),
            '0': ('8', '0')}

constant = {'1': ['2', '4', '1'], '2': ['1', '3', '5', '2'],
            '3': ['2', '6', '3'], '4': ['1', '5', '7', '4'],
            '5': ['2', '4', '6', '8', '5'], '6': ['3', '5', '9', '6'],
            '7': ['4', '8', '7'], '8': ['5', '7', '9', '0', '8'], '9': ['6', '8', '9'],
            '0': ['8', '0']}


def get_pins(observed):
    return ["".join([jtem for jtem in item]) for item in product(*[constant[item] for item in observed])]


if __name__ == '__main__':
    print('start')
    expectations = [
                    ('11', ["11", "22", "44", "12", "21", "14", "41", "24", "42"]),
                    ('369',
                     ["339", "366", "399", "658", "636", "258", "268", "669", "668", "266", "369", "398", "256", "296",
                      "259", "368", "638", "396", "238", "356", "659", "639", "666", "359", "336", "299", "338", "696",
                      "269", "358", "656", "698", "699", "298", "236", "239"])]
    # ('8', ['5', '7', '8', '9', '0']),
    for tup in expectations:
        test.assert_equals(sorted(get_pins(tup[0])), sorted(tup[1]))
    print('end')