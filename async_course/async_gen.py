import socket
from select import select

# Concurrency from the Ground up Live
tasks = []

to_read = {}
to_write = {}


# domain:5000
def server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(('localhost', 5000))
    server_socket.listen()

    while True:
        # в данном случае блокируют друг друга пока никто не подключился
        # пока никто не отправил сообщение надо создать цикл событий
        # можно это сделать чтобы не ждать каждый другого
        yield ('read', server_socket)
        print('Before .accept')
        client_socket, addr = server_socket.accept()  # read
        print('Connection from', addr)

        tasks.append(client(client_socket))


def client(client_socket):
    while True:
        # отдаем управление перед тем как вызвать блокирующую операцию
        yield ('read', client_socket)
        print('Before .recv()', client_socket)
        request = client_socket.recv(4096)  # read

        if not request:
            break
        else:
            response = 'Hello world \n'.encode()  # write
            # генератор возвращает по одному объекту когда его вызывают
            # отдают кортежи
            yield ('write', client_socket)
            print('After client socket write',client_socket)
            client_socket.send(response)
    print('Outside inner while loop')
    client_socket.close()


def event_loop():
    # проверяем пока существует хотя бы один из них пока список не один не пустой то
    # цикл продолжатеся
    while any([tasks, to_read, to_write]):
        while not tasks:
            # если задания кончились то заходим найти активное задание
            ready_to_read, ready_to_write, _ = select(to_read, to_write, [])
            #  в этом случае идем по ключам словаря именно
            # хотя здесь происходит просто итерация но по словарю она тоже возможожна
            for sock in ready_to_read:
                # извлекаем значение ключа и затем удаляем из словаря сразу
                tasks.append(to_read.pop(sock))
            for sock in ready_to_write:
                tasks.append(to_write.pop(sock))

        try:
            # сначала мы заполняем задания
            # наполняем задания и
            task = tasks.pop(0)
            # итерируем и получаем генераторов события которые нужно отслеживать
            reason, sock = next(task)
            # проверяем полученные событие и сохраняем его в определенный пулл событий
            if reason == 'read':
                to_read[sock] = task
            if reason == 'write':
                to_write[sock] = task

        except StopIteration:
            print('Done!')


# создаем первый сервер для начала
# как работают два генератора в одном цикле
tasks.append(server())
event_loop()
