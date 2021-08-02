

def is_valid_walk(walk):
    amount_n = walk.count('n')
    amount_e = walk.count('e')
    amount_w = walk.count('w')
    amount_s = walk.count('s')
    if amount_s == amount_n and amount_e == amount_w:
        return True
    return False


if __name__ == "__main__":
    text = ['n', 's', 'n', 's', 'n', 's', 'n', 's', 'n', 's']
    print(is_valid_walk(text))
