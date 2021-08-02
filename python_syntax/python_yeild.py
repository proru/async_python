

class Bank():
    crisis = False

    def create_atm(self):
        while not self.crisis:
            yield "$100"



def function():
    mygenerator = (x*x for x in range(3))
    for i in mygenerator:
       print(i)
    print(mygenerator)

def createGenerator() :
    mylist = range(3)
    for i in mylist:
        yield i*i

if __name__=="__main__":
    # print(function())
    # my_generator = createGenerator()
    # for i in my_generator:
    #     print(i)
    bank = Bank()
    temp_atm = bank.create_atm()
    print(next(temp_atm))
    print([next(temp_atm) for _ in range(5)])
    bank.crisis = True
    # print(next(temp_atm))
    atm_two = bank.create_atm()
    # print(next(atm_two))
    bank.crisis = False
    atm_three = bank.create_atm()
    print(next(atm_three))