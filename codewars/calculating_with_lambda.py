id_ = lambda x: x
number = lambda x: lambda f=id_: f(x)
# f=id_ default value
zero, one, two, three, four, five, six, seven, eight, nine = map(number, range(10))
plus = lambda x: lambda y: y + x
minus = lambda x: lambda y: y - x
times = lambda x: lambda y: y * x
divided_by = lambda x: lambda y: y / x



if __name__ == '__main__':
    from test import Test as test
    temp = seven
    temp = number
    temp = plus
    zero()
    test.assert_equals(seven(times(five())), 35)
    test.assert_equals(four(plus(nine())), 13)
    test.assert_equals(eight(minus(three())), 5)
    test.assert_equals(six(divided_by(two())), 3)
    print('all ok')