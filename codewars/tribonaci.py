

def tribonacci(signature, n):
    print(signature, n)
    for item in range(1, n-2):
        signature.append(signature[item-1] + signature[item] + signature[item + 1])
    print(signature)


if __name__ == "__main__":
    signature = [0, 1, 1]
    signature_2 = [0, 0, 1]
    signature_3 = [0, 0, 0]
    n = 10
    print(tribonacci(signature, n))
    print(tribonacci(signature_2, n))
    print(tribonacci(signature_3, n))