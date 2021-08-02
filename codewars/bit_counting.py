

def count_bits(n: int) -> int:
    temp = n
    counter = 0
    while temp > 0:
        param = temp % 2
        temp = temp // 2
        if param == 1:
            counter += 1
    return counter


def countBitsNew(n):
    total = 0
    while n > 0:
        total += n % 2
        print(n)
        n >>= 1
        print(n)
    return total



if __name__=="__main__":
    print(countBitsNew(2))