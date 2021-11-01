import socket
from select import select

# domain:5000

to_monitor = []

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(('localhost', 5000))
server_socket.listen()


def accept_connection(server_socket):
    # в данном случае блокируют друг друга пока никто не подключился
    # пока никто не отправил сообщение надо создать цикл событий
    # можно это сделать чтобы не ждать каждый другого
    print('Before .accept')
    client_socket, addr = server_socket.accept()
    print('Connection from', addr)
    # send_message(client_socket)
    to_monitor.append(client_socket)


def send_message(client_socket):
    print('Before .recv()')
    request = client_socket.recv(4096)

    if request:
        response = 'Hello world \n'.encode()
        client_socket.send(response)
    else:
        client_socket.close()
        print('Outside inner while loop')


def event_loop():
    while True:
        # select надройска активная системная для состояние файловых
        ready_to_read, _, _ = select(to_monitor, [], [])  # read write errors
        for sock in ready_to_read:
            if sock is server_socket:
                accept_connection(sock)
            else:
                send_message(sock)


if __name__ == '__main__':
    to_monitor.append(server_socket)
    #  в этом случае они работают асинхронно в одном потоке
    #
    event_loop()
