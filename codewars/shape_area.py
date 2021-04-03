# from random import shuffle
#
# test.describe("Base class checks")
#
# test.assert_equals(all(issubclass(x, Shape) for x in (Triangle, Circle, Rectangle, CustomShape, Square)), True)
#
# test.describe("Shapes are sortable on are")
#
# expected = []
#
# area = 1.1234
# expected.append(CustomShape(area))
#
# side = 1.1234
# expected.append(Square(side))
#
# radius = 1.1234
# expected.append(Circle(radius))
#
# triangleBase = 5
# height = 2
# expected.append(Triangle(triangleBase, height))
#
# height = 3
# triangleBase = 4
# expected.append(Triangle(triangleBase, height))
#
# width = 4
# expected.append(Rectangle(width, height))
#
# area = 16.1
# expected.append(CustomShape(area))
#
# test.it("Base class check")
# test.assert_equals(all(issubclass(x, Shape) for x in (Triangle, Circle, Rectangle, CustomShape, Square)), True)
#
# # create a copy of expected
# actual = expected[:]
#
# # in-place shuffle (check: https://docs.python.org/3.6/library/random.html?highlight=shuffle#random.shuffle)
# shuffle(actual)
# actual.sort()
#
# test.assert_equals(actual, expected)
# Task:
#
# Create different shapes that can be part of a sortable list. The sort order is based on the size of their respective areas:
# The area of a Square is the square of its side
# The area of a Rectangle is width multiplied by height
# The area of a Triangle is base multiplied by height divided by 2
# The area of a Circle is the square of its radius multiplied by π
# The area of a CustomShape is given

# side = 1.1234
# radius = 1.1234
# base = 5
# height = 2
#
# # All classes must be subclasses of the Shape class
#
# shapes: List[Shape] = [Square(side), Circle(radius), Triangle(base, height)]
# shapes.sort()


from math import pi


class Shape(object):

    def __init__(self, area):
        self.area = area

    def __eq__(self, other):
        return self.area == other.area

    def __lt__(self, other):
        return self.area < other.area


class Square(Shape):

    def __init__(self, side):
        super().__init__(side * side)


class Circle(Shape):

    def __init__(self, radius):
        super().__init__(radius * radius * pi)


class Triangle(Shape):

    def __init__(self, base, height):
        super().__init__(base * height * 0.5)


class Rectangle(Shape):

    def __init__(self, width, height):
        super().__init__(width * height)


class CustomShape(Shape):

    def __init__(self, area):
        super().__init__(area)


if __name__ == '__main__':
    print('hello')
    side = 3
    radius = 1
    base = 15
    height = 2

    # All classes must be subclasses of the Shape class

    shapes = [Square(side), Circle(radius), Triangle(base, height)]
    print(shapes)
    print(shapes.sort())
    print(shapes)
