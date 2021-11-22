

def find_next_square(sq):
    num = sq ** 0.5
    if (num - int(num)) == 0:
        return int(num) ** 2
    return -1

def find_next_square2(sq):
    num = sq ** 0.5
    if num.is_integer():
        return int(num) ** 2
    return -1



if __name__ == '__main__':
    # print(song_decoder("AWUBBWUBC"))
    # print(song_decoder("AWUBWUBWUBBWUBWUBWUBC"))
    num = 121
    num1 = 625
    print(find_next_square(num))
    print(find_next_square(113))
    print(find_next_square(625))

