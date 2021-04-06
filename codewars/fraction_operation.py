class Fraction:

    def __init__(self, numerator, denominator):
        self.top = numerator
        self.bottom = denominator

    def __eq__(self, other):
        first_num = self.top * other.bottom
        second_num = other.top * self.bottom
        return first_num == second_num

    def __add__(self, other):
        top = self.top * other.bottom + self.bottom * other.top
        bottom = self.bottom * other.bottom
        while True:
            res = self._factor(top).intersection(self._factor(bottom))
            if len(res) > 0:
                for item in res:
                    top = top / item
                    bottom = bottom / item
            else:
                top = int(top)
                bottom = int(bottom)
                break
        return Fraction(top, bottom)

    def _factor(self, n):
        ans = set()
        d = 2
        while d * d <= n:
            if n % d == 0:
                ans.add(d)
                n //= d
            else:
                d += 1
        if n > 1:
            ans.add(n)
        return ans

    def __str__(self):
        return 'outputs: ' + str(self.top) + '/' + str(self.bottom)


if __name__ == '__main__':
    fro = Fraction(4, 5)
    bro = Fraction(3, 4)
    print(fro + bro)
