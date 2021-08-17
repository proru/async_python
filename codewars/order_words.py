import re
from collections import OrderedDict

def order(sentence):
    arr = sentence.split()
    temp = [None] * len(arr)
    for item in arr:
        num = re.findall("[1-9]+", item)
        temp[int(num[0])-1] = item
        print(sorted(item))
    return " ".join(temp)


if __name__=="__main__":
    text = "is2 Thi1s T4est 3a"
    print(order(text))