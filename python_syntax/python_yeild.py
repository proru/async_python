

def function():
    mygenerator = (x*x for x in range(3))
    for i in mygenerator:
       print(i)
    print(mygenerator)

def createGenerator() :
    mylist = range(3)
    for i in mylist :
        yield i*i

if __name__=="__main__":
    print(function())
    my_generator = createGenerator()
    for i in my_generator:
        print(i)