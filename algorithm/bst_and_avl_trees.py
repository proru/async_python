

def log_func(func):
    def wrapper(*args, **kwargs):
        val = func(*args, **kwargs)
        print(val)
        print(func)
        return val
    return wrapper


class BinaryNode:

    def __init__(self, value = None):
        """Создание узла бинарного дерева поиска."""
        self.value = value
        self.left = None
        self.right = None
        self.height = 0

    def inorder(self):
        if self.left:
            for n in self.left.inorder():
                yield n

        yield self.value
        if self.right:
            for n in self.right.inorder():
                yield n

    @log_func
    def add(self, val):
        """Добавление нового узла с заданным значением в BST."""
        new_root = self
        if val <= self.value:
            self.left = self.add_to_sub_tree(self.left, val)
            if self.height_difference() == 2:
                if val <= self.left.value:
                    new_root = self.rotate_right()
                else:
                    new_root = self.rotate_left_right()
        else:
            self.right = self.add_to_sub_tree(self.right, val)
            if self.height_difference() == -2:
                if val > self.right.value:
                    new_root = self.rotate_left()
                else:
                    new_root = self.rotate_right_left()
        new_root.compute_height()
        return new_root

    @log_func
    def add_to_sub_tree(self, parent, val):
        """Добавление val в родительское поддерево (если таковое существует) и возврат корня,
         елси он был изменен из-за поворота"""
        if parent is None:
            return BinaryNode(val)
        parent = parent.add(val)
        return parent

    @log_func
    def compute_height(self):
        """Вычисление высоты узла в BST из высот потомков."""
        height = -1
        if self.left:
            height = max(height, self.left.height)
        if self.right:
            height = max(height, self.right.height)
        self.height = height + 1

    @log_func
    def height_difference(self):
        """ Вычисление разности высот потомков в BST"""
        left_target = 0
        right_target = 0
        if self.left:
            left_target = 1 + self.left.height
        if self.right:
            right_target = 1 + self.right.height
        return left_target - right_target

    @log_func
    def rotate_right(self):
        new_root = self.left
        # self.left, new_root.right = new_root.right, self
        grand_son = new_root.right
        self.left = grand_son
        new_root.right = self
        self.compute_height()
        return new_root

    @log_func
    def rotate_right_left(self):
        child = self.right
        new_root = child.left
        grand_one = new_root.left
        grand_two = new_root.right
        child.left = grand_one
        child.right = grand_two

        new_root.left = self
        new_root.right = child

        child.compute_height()
        self.compute_height()
        return new_root

    @log_func
    def rotate_left(self):
        new_root = self.right
        grand_son = new_root.left
        self.right = grand_son
        new_root.left = self

        self.compute_height()
        return new_root

    @log_func
    def rotate_left_right(self):
        child = self.left
        new_root = child.right
        grand_one = new_root.left
        grand_two = new_root.right
        child.right = grand_one
        self.left = grand_two

        new_root.left = child
        new_root.right = self

        child.compute_height()
        self.compute_height()
        return new_root

    @log_func
    def remove_from_parent(self, parent, val):
        if parent:
            return parent.remove(val)
        return None

    @log_func
    def remove(self, val):
        new_root = self
        if val == self.value:
            if self.left is None:
                return self.right

            child = self.left
            while child.right:
                child = child.right

            child_key = child.value
            self.left = self.remove_from_parent(self.left, child_key)
            self.value = child_key

            if self.height_difference() == -2:
                if self.right.height_difference() <= 0:
                    new_root = self.rotate_left()
                else:
                    new_root = self.rotate_right_left()
        elif val < self.value:
            self.left = self.remove_from_parent(self.left, val)
            if self.height_difference() == -2:
                if self.right.height_difference() <= 0:
                    new_root = self.rotate_left()
                else:
                    new_root = self.rotate_right_left()

        else:
            self.right = self.remove_from_parent(self.right, val)
            if self.height_difference() == 2:
                if self.left.height_difference() >= 0:
                    new_root = self.rotate_right()
                else:
                    new_root = self.rotate_left_right()

        new_root.compute_height()
        return new_root


class BinaryTree:

    def __init__(self):
        """Создание пустого BST."""
        self.root = None

    def __iter__(self):
        """ Упорядоченный обход элементов дерева. """
        if self.root:
            return self.root.inorder()

    @log_func
    def add(self, value):
        """Вставка значения в корректное место в BST."""
        if self.root is None:
            self.root = BinaryNode(value)
        else:
            self.root = self.root.add(value)

    @log_func
    def __contains__(self, target):
        node = self.root
        while node:
            if target < node.value:
                node = node.left
            elif target > node.value:
                node = node.right
            else:
                node = node.right
        return True


if __name__ == "__main__":
    temp = [1, 4, 7, 14, 54, 2, 3, 6, 8, 23, 24, 5, 9, 10]
    binary_tree = BinaryTree()
    for i in temp:
        binary_tree.add(i)
    for v in binary_tree:
        print(v)

