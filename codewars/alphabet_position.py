
def to_jaden_case(string):
    return " ".join([item.capitalize() for item in string.split()])

def alphabet_position(text):
    # text = map(ord, text.encode("cp1252"))
    text = filter(lambda x: ord(x)>= 97 and ord(x) <=123, text.lower())
    text = " ".join(map(lambda x: str(ord(x)-64), text))
    # text = [item for item in map(lambda x: str(ord(x)-64) if (ord(x) >= 97 and ord(x) <=123) else "", text)]
    return text


if __name__=="__main__":
    text = " at twelve o' clock."
    # print(alphabet_position(text))
    print(to_jaden_case("kjas ldkfj asdf"))