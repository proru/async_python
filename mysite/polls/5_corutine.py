def subgen():
    x = 'Ready to accept message'
    message = yield x
    print('Subgen received:', message)
