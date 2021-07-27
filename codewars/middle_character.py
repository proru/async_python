def get_middle(s):
    len_s = len(s)
    print(len_s, s)
    return s[len_s//2 + len_s%2-1:len_s//2+(len_s+1)%2 + 1]


if __name__ == "__main__":
    str = "testing"
    print(get_middle(str))
