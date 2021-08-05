

def is_square_simple(n):
    number = 0
    while n >= number:
        if n == number*number:
            return True
        number += 1
    return False


def is_square(n):
    low = 0
    high = n
    i = 0
    if n == 1:
        return True
    while i < n//2 + 1 and n >= 0:
        temp_sqrt = i*i
        if temp_sqrt == n:
            return True
        elif temp_sqrt < n:
            low = i
        else:
            high = i
        i = low + (high - low) // 2
        if low == i or high == i:
            break
    return False

test_value = [-1,1,4,9,16,25,26,3,36,49,100]
# test_value = [26]

if __name__=="__main__":
    for item in test_value:
        print(is_square(item))
