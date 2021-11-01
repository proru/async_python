

def song_decoder(song):
    return " ".join(filter(None, song.split("WUB")))

def iq_test(numbers):
    temp = [numbers[0]]
    for item in numbers:
        print(item)
    return


if __name__ == '__main__':
    # print(song_decoder("AWUBBWUBC"))
    # print(song_decoder("AWUBWUBWUBBWUBWUBWUBC"))

    print(iq_test("2 4 7 8 10"))
    print(iq_test("1 2 2"))