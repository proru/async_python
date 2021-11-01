from test import Test as test


def get_sum(a, b):
    order = sorted([a, b])
    return sum([item for item in range(order[0], order[1]+1)])

def iq_test(numbers):
    cnt_even = 0
    cnt_not = 0
    numbers = map(int, numbers.split())
    for idx, num in enumerate(numbers):
        if num % 2 == 0:
            cnt_even += 1
            place_even = idx
        else:
            cnt_not += 1
            place_not = idx
    if cnt_even > cnt_not:
        return place_not + 1
    else:
        return place_even + 1
    #your code here


if __name__ == "__main__":
    print(get_sum(1, 5))
    print(get_sum(0, 1))
    print(get_sum(0, -1))
    # test = Test()
    # test.assert_equals(iq_test("2 4 7 8 10"), 3)
    # test.assert_equals(iq_test("1 2 2"), 1)
    # text = ['n', 's', 'n', 's', 'n', 's', 'n', 's', 'n', 's']