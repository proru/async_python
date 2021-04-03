# A
# simple
# substitution
# cipher
# replaces
# one
# character
# from an alphabet
#
# with a character from an alternate alphabet, where each character's position in an alphabet is mapped to the alternate alphabet for encoding or decoding.
#
# E.g.
#
# map1 = "abcdefghijklmnopqrstuvwxyz";
# map2 = "etaoinshrdlucmfwypvbgkjqxz";
#
# cipher = Cipher(map1, map2);
# cipher.encode("abc")  # => "eta"
# cipher.encode("xyz")  # => "qxz"
# cipher.encode("aeiou")  # => "eirfg"
#
# cipher.decode("eta")  # => "abc"
# cipher.decode("qxz")  # => "xyz"
# cipher.decode("eirfg")  # => "aeiou"
# If
# a
# character
# provided is not in the
# opposing
# alphabet, simply
# leave
# it as be.

class Cipher:

    def __init__(self, map1, map2):
        self.map_from = map1
        self.map_to = map2
        self.range_from = len(map1)
        self.range_to = len(map2)

    def encode(self, str):
        leng = len(str)
        temp = []
        for item in range(leng):
            temp_str = self.map_from.find(str[item])
            if temp_str > 0:
                temp.append(self.map_to[temp_str])
            else:
                temp.append(str[item])
        return ''.join(temp)

    def decode(self, str):
        leng = len(str)
        temp = []
        for item in range(leng):
            temp_str = self.map_to.find(str[item])
            if temp_str > 0:
                temp.append(self.map_from[temp_str])
            else:
                temp.append(str[item])
        return ''.join(temp)


if __name__ == '__main__':
    map1 = "abcdefghijklmnopqrstuvwxyz"
    # map2 = "etaoinshrdlucmfwypvbgkjqxz"
    # cipher = Cipher(map1, map2)
    # print(cipher.encode("abc"))  # => "eta"
    # print(cipher.encode("xyz"))  # => "qxz"
    # print(cipher.encode("aeiou"))  # => "eirfg"
    #
    # print(cipher.decode("eta"))  # => "abc"
    # print(cipher.decode("qxz"))  # => "xyz"
    # print(cipher.decode("eirfg"))  # => "aeiou"
    map2 = "tfozcivbsjhengarudlkpwqxmy"
    cipher = Cipher(map1, map2)
    print(cipher.decode('kjpphi'))  # 'tjuukf'
    print(cipher.decode('t_fo&*83'))  # 'tjuukf'
    print(cipher.encode('t_fo&*83'))  # 'tjuukf'
    print(cipher.encode('azbczzzz'))  # 'tjuukf'
