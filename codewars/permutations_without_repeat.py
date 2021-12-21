from test import Test as test
import itertools
import time


def permutations_new(string_list):
    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    count_string = [string_list.count(item) * item for item in alphabet]
    count_string = list(filter(lambda x: x != '', count_string))
    set_string = itertools.product(*count_string)
    print(list(itertools.product(*set_string, )))
    return ["".join([jtem for jtem in item]) for item in set_string]


def perm(string):
    return [''.join(item) for item in set(itertools.permutations(string))]


def permutations(items):
    def visit(head_in=None):
        (rv, next_j) = ([], head_in)
        for i in range(number_element):
            (dat, next_j) = list_index[next_j]
            rv.append(value_of_index[dat])
        return ''.join(rv)

    value_of_index = list(set(items))
    list_index = list(reversed(sorted([value_of_index.index(i) for i in items])))
    number_element = len(list_index)
    # put list_index into linked-list format
    (val, nxt) = (0, 1)
    for i in range(number_element):
        list_index[i] = [list_index[i], i + 1]
    list_index[-1][nxt] = None  # last element empty
    head = 0
    after_i = number_element - 1
    current_i = after_i - 1
    yield visit(head)  # initial list
    while list_index[after_i][nxt] is not None or list_index[after_i][val] < list_index[head][val]:
        j = list_index[after_i][nxt]  # added to algorithm for clarity
        if j is not None and list_index[current_i][val] >= list_index[j][val]:
            before_k = after_i
        else:
            before_k = current_i
        k = list_index[before_k][nxt]
        list_index[before_k][nxt] = list_index[k][nxt]
        list_index[k][nxt] = head
        if list_index[k][val] < list_index[head][val]:
            current_i = k
        after_i = list_index[current_i][nxt]
        head = k
        yield visit(head)


if __name__ == '__main__':
    print('start')
    test.assert_equals(sorted(permutations('a')), ['a'])
    test.assert_equals(sorted(permutations('ab')), ['ab', 'ba'])
    example = 'asdacsfdhgj'
    t0 = time.time()
    permutations(example)
    print(time.time()-t0)
    t0 = time.time()
    perm(example)
    print(time.time()-t0)
    print('end')
