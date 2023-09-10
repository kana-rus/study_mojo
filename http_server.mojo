from python import Python
from python.object import PythonObject
from builtin.string import _snprintf
#from builtin.type_aliases import 

"""
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
"""

struct Address:
    var host: String
    var port: Int

    fn __init__(inout self, host: String, port: Int):
        self.host = host
        self.port = port

    fn __moveinit__(inout self, owned existing: Self):
        self.host = existing.host
        self.port = existing.port
    
    fn into_pyexpr(owned self) -> Tuple[String, Int]:
        return (self.host, self.port)

    fn to_string(self) -> String:
        return self.host + ":" + self.port

struct Socket:
    var inner: PythonObject

    fn __init__(inout self, owned python_socket: PythonObject):
        try:
            self.inner = python_socket^
        except e:
            print(e.value)
    
    fn __moveinit__(inout self, owned existing: Self):
        self.inner = existing^.inner

    fn bind(inout self, owned address: Address):
        try:
            self.inner.bind(address^.into_pyexpr()).__del__()#None
        except e:
            print(e.value)

    fn listen(inout self):
        try:
            self.inner.listen().__del__()#None
        except e:
            print(e.value)

    fn accept(inout self) -> Incoming:
        try:
            let incoming = self.inner.accept()

            let client_socket = Socket(
                incoming.__getitem__(0)
            )
            let address = Address(
                incoming.__getitem__(1).__getitem__(0).to_string(),
                incoming.__getitem__(1).__getitem__(1).to_float64().to_int()
            )

            return Incoming(client_socket^, address^)

        except e:
            print(e.value)

    fn recv(inout self, bufsize: Int):
        try:
            let recv = self.inner.recv(bufsize)
            #####
            ## Python 側で `recv` は `bytes` を返しているが。。。
            #####
            
        except e:
            print(e.value)


struct Incoming:
    var client_socket:  Socket
    var remote_address: Address

    fn __init__(inout self, owned client_socket: Socket, owned remote_address: Address):
        self.client_socket  = client_socket^
        self.remote_address = remote_address^

"""
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
"""
struct Server:
    var socket: Socket

    fn __init__(inout self):
        try:
            let s = Python.import_module("socket")
            let socket = s.socket()
            socket.setsockopt(s.SOL_SOCKET, s.SO_REUSEADDR, 1).__del__()#None
            self.socket = socket
        except e:
            print(e.value)

    fn serve(inout self):
        self.socket.bind(Address("localhost", 8080))
        self.socket.listen()
        
        print("=== Waiting for a client connection ===")
        let incoming = self.socket.accept()
        print("=== Accepted connection: remote address " + incoming.remote_address.to_string() + " ===")

fn main() raises:
    let s = Python.import_module("socket")

