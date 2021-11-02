

def maskify(cc):
    return '#'*(len(cc)-4 if len(cc) > 4 else 0) + cc[-4:]


def dirReduc(arr):
    default = ('north south', 'west east', 'east west', 'south north')
    arr_new = map(lambda x: x.lower(), arr)
    stri = ' '.join(arr_new)
    for _ in range(len(arr)):
        stri = stri.replace(default[0], '')
        stri = stri.replace(default[1], '')
        stri = stri.replace(default[2], '')
        stri = stri.replace(default[3], '')
        stri = stri.replace('  ', ' ')
    arr = list(map(lambda x: x.upper(), stri.split()))
    return arr


opposite = {'NORTH': 'SOUTH', 'EAST': 'WEST', 'SOUTH': 'NORTH', 'WEST': 'EAST'}

def dirReduc2(plan):
    new_plan = []
    for d in plan:
        if new_plan and new_plan[-1] == opposite[d]:
            new_plan.pop()
        else:
            new_plan.append(d)
    return new_plan

def dirReduc3(arr):
    dir = " ".join(arr)
    dir2 = dir.replace("NORTH SOUTH",'').replace("SOUTH NORTH",'').replace("EAST WEST",'').replace("WEST EAST",'')
    dir3 = dir2.split()
    print(dir2)
    return dirReduc(dir3) if len(dir3) < len(arr) else dir3

if __name__ == '__main__':
    from test import Test as test

    cc = ''
    r = maskify(cc)
    test.assert_equals(r, cc)

    cc = '123'
    r = maskify(cc)
    test.assert_equals(r, cc)

    cc = 'SF$SDfgsd2eA'
    r = maskify(cc)
    test.assert_equals(r, '########d2eA')

    a = ["NORTH", "SOUTH", "SOUTH", "EAST", "WEST", "NORTH", "WEST"]

    test.assert_equals(dirReduc(a), ['WEST'])
    u = ["NORTH", "WEST", "SOUTH", "EAST"]
    test.assert_equals(dirReduc(u), ["NORTH", "WEST", "SOUTH", "EAST"])

    a = ["NORTH","NORTH","SOUTH","SOUTH","SOUTH", "EAST", "WEST", "NORTH", "WEST"]
    test.assert_equals(dirReduc(a), ['WEST'])


    a = ["NORTH","NORTH","SOUTH","SOUTH","SOUTH", "EAST", "WEST", "NORTH", "WEST"]
    test.assert_equals(dirReduc2(a), ['WEST'])

    a = ["NORTH","NORTH","SOUTH","SOUTH","SOUTH", "EAST", "WEST", "NORTH", "WEST"]
    test.assert_equals(dirReduc3(a), ['WEST'])
    print('all ok')