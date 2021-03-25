import time
import re


def fun_multi(number):
    list = [num for num in range(1000)]
    # for item in range(1, number, 1):
    #     if item%3== 0 or item%5 ==0 :
    #         list.append(item)
    time0 = time.time()
    lengt = len(list)
    for i in range(int(lengt / 2)):
        list[i], list[lengt - i - 1] = list[lengt - i - 1], list[i]
    time1 = time.time()
    time2 = time1 - time0
    return time2


import itertools


def next_bigger(n):
    arr = []
    temp = n
    t0 = time.time()
    while temp > 0:
        arr.append(temp % 10)
        temp = int(temp / 10)
        print(temp)
    t1 = time.time()
    print(t1 - t0)
    arr = list(itertools.permutations(arr))
    t0 = time.time()
    print(t0 - t1)
    item = 0
    # for element in arr:
    #     arr[item] = int(''.join(map(str, element)))
    #     item += 1
    for element in arr:
        multi = element[0]
        for jtem in range(1, len(element)):
            multi = multi * 10 + element[jtem]
        arr[item] = multi
        item += 1
    t1 = time.time()
    print(t1 - t0)
    arr.sort(reverse=True)
    t0 = time.time()
    print(t0 - t1)
    index = arr.index(n)
    return arr[index - 1] if index < len(arr) else -1


def next_differ(n):
    arr = []
    temp = n
    while temp > 0:
        arr.append(temp % 10)
        temp = int(temp / 10)
    arr = arr[::-1]
    flag = 0
    len_arr = len(arr)
    for item in reversed(range(1, len_arr)):
        if arr[item - 1] < arr[item]:
            min_amount = min([jtem for jtem in arr[item:len_arr] if jtem > arr[item - 1]])
            minIndex = item + arr[item:len_arr].index(min_amount)
            arr[item - 1], arr[minIndex] = arr[minIndex], arr[item - 1]
            flag = 1
            arr = arr[:item] + sorted(arr[item:len_arr])
            break
    multi = None
    if flag:
        multi = arr[0]
        for jtem in range(1, len(arr)):
            multi = multi * 10 + arr[jtem]
    return multi if multi else -1


def top_words(text):
    text = text.lower()
    new = re.findall(r"[^a-z ']", text) + re.findall(r"^ *'* *$", text)
    print(new)
    for item in new:
        text = text.replace(item, "")
    arr = text.split()
    print(text)
    temp = {}
    for item in arr:
        temp[item] = temp[item] + 1 if temp.get(item) else 1
    print(temp)
    max_values = sorted(list(temp.values()), reverse=True)[:3]
    new = []
    for value in max_values:
        new.append(list(temp.keys())[list(temp.values()).index(value)])
    return new


def find_outlier(integers):
    item = 0
    count = 0
    for item in range(3):
        if integers[item] % 2 == 0:
            count += 1
    if count > 1:
        for item in integers:
            if (item + 1) % 2 == 0:
                return item
    if count < 2:
        for item in integers:
            if (item) % 2 == 0:
                return item


def find_duplicates(text):
    text = text.lower()
    temp = {}
    symbol = None
    for item in text:
        symbol = text.count(item)
        if symbol > 1:
            temp[item] = symbol
    return len(temp)


if __name__ == '__main__':
    # print(next_bigger(4831789))
    # print(next_differ(5198883))
    # print(next_bigger(9161863))
    # print(next_differ(26506995676330))
    # str = 'Indivisibilities'
    # print(find_duplicates(str))
    # print(top_words(str))
    print(find_outlier([160, 3, 1719, 19, 11, 13, -21]))
    # str =    """   ''' """
    # print(top_words(str))
    # print(next_bigger(5318889))

    # print(next_differ(59884848495853))
