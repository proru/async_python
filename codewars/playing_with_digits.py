
def dig_pow(n, p):
    summ = 0
    for item in str(n):
        summ += int(item)**p
        p += 1
    if summ % n == 0:
        return summ//n
    return -1


if __name__ == '__main__':
    number = 89
    power_cur = 1
    print(dig_pow(number, power_cur))
    print(dig_pow(92, 1))
    print(dig_pow(46288, 3))