from test import Test as test


def zero(func=None):
    return eval("0" + func[0] + func[1]) if func else "0"


def one(func=None):
    return eval("1" + func[0] + func[1]) if func else "1"


def two(func=None):
    return eval("2" + func[0] + func[1]) if func else "2"


def three(func=None):
    return eval("3" + func[0] + func[1]) if func else "3"


def four(func=None):
    return eval("4" + func[0] + func[1]) if func else "4"


def five(func=None):  # your code here
    return eval("5" + func[0] + func[1]) if func else "5"


def six(func=None):  # your code here
    return eval("6" + func[0] + func[1]) if func else "6"


def seven(func=None):
    return eval("7" + func[0] + func[1]) if func else "7"


def eight(func=None):
    return eval("8" + func[0] + func[1]) if func else "8"


def nine(func=None):
    return eval("9" + func[0] + func[1]) if func else "9"


def plus(argument):
    if argument:
        return "+", argument


def minus(argument):
    if argument:
        return "-", argument


def times(argument):
    if argument:
        return "*", argument


def divided_by(argument):
    if argument:
        return "//", argument


if __name__ == '__main__':
    test.assert_equals(seven(times(five())), 35)
    test.assert_equals(four(plus(nine())), 13)
    test.assert_equals(eight(minus(three())), 5)
    test.assert_equals(six(divided_by(two())), 3)
    print('all ok')
    # print(next_bigger(4831789))
    # print(next_differ(5198883))
    # print(next_bigger(9161863))
    # print(next_differ(26506995676330))
    # str = 'Indivisibilities'
    # print(find_duplicates(str))
    # print(top_words(str))

    # str =    """   ''' """
    # print(top_words(str))
    # print(next_bigger(5318889))

    # print(next_differ(59884848495853))
