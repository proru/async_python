import socket
from select import select
import selectors
from collections import defaultdict
from time import time

# domain:5000
global_response = defaultdict(list)
selector = selectors.DefaultSelector()


# generator может передавать контроль выполнения не прерывая работу
#  герератора

# генерирует уникальные имена файлов
def gen_filename():
    while True:
        pattern = 'file-{}.jpeg'
        t = int(time() * 1000)
        yield pattern.format(str(t))
        # делит выполнение функции на две части но все равно в
        # вся программа будет выполнена
        print("hello")


def gen(s):
    for i in s:
        yield i


# можно сделать несколько частичных массивов
def gen_num():
    yield 1
    yield 2
    yield 3


def gen2(n):
    for i in range(n):
        yield i


g1 = gen('oleg')
g2 = gen2(4)
tasks = [g1, g2]

while tasks:
    task = tasks.pop(0)

    try:
        i = next(task)
        print(i)
        tasks.append(task)

    except StopIteration:
        pass

g = gen_filename()


def server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(('localhost', 5000))
    server_socket.listen()

    selector.register(fileobj=server_socket, events=selectors.EVENT_READ, data=accept_connection)


def accept_connection(server_socket):
    # в данном случае блокируют друг друга пока никто не подключился
    # пока никто не отправил сообщение надо создать цикл событий
    # можно это сделать чтобы не ждать каждый другого
    print('Before .accept')
    client_socket, addr = server_socket.accept()
    print('Connection from', addr)

    selector.register(fileobj=client_socket, events=selectors.EVENT_READ, data=send_message)


def send_message(client_socket):
    print('Before .recv()')
    request = client_socket.recv(4096)
    global global_response
    response = ""
    print(request)
    if request == b'read\n':
        print(global_response)
        for key, value in global_response:
            print(key)
            print(value)
            if key != client_socket:
                for item in global_response[key]:
                    response = response + global_response[key][item] + "\n"
        global_response[client_socket].append(request)
        client_socket.send(response)
    elif request:
        print(request)
        global_response[client_socket].append(request)
        response = 'accept\n'.encode()
        client_socket.send(response)
    else:
        selector.unregister(client_socket)
        client_socket.close()
        print('Outside inner while loop')


def event_loop():
    while True:
        events = selector.select()  # key events )
        # SelectorKey
        # fileobj
        # events
        # data
        for key, _ in events:
            # получает саму функцию и вызывает ее и мы регистрируем и смотрим
            # за активностью объекта
            callback = key.data
            callback(key.fileobj)

# if __name__ == '__main__':
#  в этом случае они работают асинхронно в одном потоке
# регистрируем первый вызов
