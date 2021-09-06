
def max_sequence_info(arr):
    ans = arr[0]
    ans_l = 0
    ans_r = 0
    sum = 0
    minus_pos = -1
    r = 0
    len_arr = len(arr)
    while r < len_arr:
        sum += arr[r]
        print(sum)
        if sum > ans:
            ans = sum
            ans_l = minus_pos + 1
            ans_r = r
        if sum < 0:
            sum = 0
            minus_pos = r
        r += 1
    return (ans, ans_l, ans_r)


def max_sequence(arr):
    ans = arr[0] if arr else 0
    summ = 0
    for item in arr:
        summ += item
        ans = summ if summ > ans else ans
        summ = summ if summ > 0 else 0
    return ans if ans > 0 else 0


if __name__ == "__main__":
    str = "testing"
    array = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
    print( max_sequence(array))
    array = [-2, -1, -3, -4, -1, -2, -1, -5, -4]
    print( max_sequence(array))
    print( max_sequence([]))