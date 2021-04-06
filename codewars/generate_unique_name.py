import random
import string


def generateName():
    return "".join(random.choice(string.ascii_letters) for j in range(6))


if __name__=='__main__':
    print(generateName())
