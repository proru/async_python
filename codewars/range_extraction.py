from test import Test as test
import itertools


def solution(args=None):
    def range(args):
        for diff_idx_arg, part_range in itertools.groupby(enumerate(args), lambda idx_arg: idx_arg[0] - idx_arg[1]):
            part_range = list(part_range)
            yield part_range[0][1], part_range[-1][1]
    args = list(range(args))
    result = []
    for item, value in enumerate(args):
        if value[0] == value[1]:
            result.append(str(value[0]))
        elif value[0]+1 == value[1]:
            result.append(str(value[0]))
            result.append(str(value[1]))
        else:
            result.append(str(value[0]) + '-' + str(value[1]))
    return ','.join(result)


def solution_new(args):
    print(len(args))
    args.pop(args.index(0))
    result = []
    for item in range(1, len(args)-1):
        if args[item-1] + 2 == args[item] + 1 == args[item+1]:
            print(item)
            if result:
                if result[-1][1] == item:
                    result[-1][1] = args[item+1]
                else:
                    result.append([args[item-1], args[item+1]])
            result.append([args[item-1], args[item+1]])
        else:
            result.append(args[item-1])
            result.append(args[item])
    for item, value in enumerate(result):
        result[item] = str(result[item][0]) + '-' + str(result[item][1])
    return ",".join(result)


if __name__ == '__main__':
    print('start')
    test.assert_equals(solution([-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]),
                       '-6,-3-1,3-5,7-11,14,15,17-20')
    test.assert_equals(solution([-3, -2, -1, 2, 10, 15, 16, 18, 19, 20]), '-3--1,2,10,15,16,18-20')
    print('end')