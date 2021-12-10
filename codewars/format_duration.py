from test import Test as test


def format_duration(seconds):
    answer = []
    constant = {'year': 365*24*60*60, 'day': 24*60*60, 'hour': 60*60, 'minute': 60, 'second': 1}
    for key, value in constant.items():
        temp = seconds//value
        if temp >= 1:
            seconds = seconds - temp*value
            answer.append(str(int(temp)) + ' ' + key + ('s' if temp >= 2 else ''))
    str_ans = answer[0] if answer else ''
    for item in range(1, len(answer)-1):
        str_ans += ', ' + answer[item]
    if len(answer) > 1:
        str_ans += ' and ' + answer[len(answer)-1]
    return str_ans





if __name__ == '__main__':
    print('start')
    test.assert_equals(format_duration(1), "1 second")
    test.assert_equals(format_duration(0), "")
    test.assert_equals(format_duration(62), "1 minute and 2 seconds")
    test.assert_equals(format_duration(120), "2 minutes")
    test.assert_equals(format_duration(3600), "1 hour")
    test.assert_equals(format_duration(3662), "1 hour, 1 minute and 2 seconds")
    print('end')
