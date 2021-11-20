import datetime
import time

def counting_str(temp):
    sum = 0
    for idx, item in enumerate(temp):
        if (idx+1) % 2 == 0:
            item = item.replace(' ', '', 5)
            sum += int(item)
            print(item)


if __name__ == '__main__':
    value = '9,56'
    try:
        print(float(value))
    except ValueError as e:
        print(float(value.replace(',', '.')))
    print('hello')