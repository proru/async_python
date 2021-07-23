

def duplicate_encode(word):
    word = list(word.lower())
    num_word = {x: word.count(x) for x in set(word)}
    for item in range(len(word)):
        word[item] = ')' if num_word[word[item]] > 1 else '('
    return "".join(word)

def duplicate_encode_old(word):
    arr = ['(', ')'] + list(set(word.lower()))
    word = word.lower()
    for item in arr:
        num = word.count(item)
        word = word.replace(item, ')' if num > 1 else '(', num)
    return word

if __name__=="__main__":
    string_first = "recede"
    string_second = "(( @"
    print(duplicate_encode(string_first))
    print(duplicate_encode(string_second))