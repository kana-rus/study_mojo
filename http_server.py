import socket as s

def serve():
    try:
        server_socket = s.socket()
        server_socket.setsockopt(s.SOL_SOCKET, s.SO_REUSEADDR, 1)
        server_socket.bind(("localhost", 8080))
        server_socket.listen(10)

        print("=== Waiting client connection ===")
        (client_socket, address) = server_socket.accept()
        print(f"=== Connected with client. remote address: {address} ===")

        req = client_socket.recv(4096)

        res_body = f"<html><body><h1>It works!</h1></body></html>"

        res = f"\
HTTP/1.1 200 OK\r\n\
Content-Type: text/html\r\n\
Content-Length: {len(res_body.encode())}\r\n\
\r\n\
{res_body}\
        "
        client_socket.send(res.encode())
        print(f"\n[Sent response]\n\n{res}\n")

        client_socket.close()

    finally:
        print("=== Exit server... ==")

if __name__ == "__main__":
    serve()
