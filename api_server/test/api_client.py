from requests import request
from random import choice
from time import sleep
import socket
import ssl
import json

class TestApiClient:
    """Test API Client for IoT Door System"""

    def __init__(self):
        self._key_ = "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"
        self.base_route = "DLIS"
        self.url = "http://127.0.0.1:8888/" + self.base_route
        self.route: str
        for _ in range(10):
            self.post_lock()
            sleep(0.01)
            self.get_lock()
            sleep(0.01)
            self.get_state()
            sleep(0.01)
            self.post_state()
            sleep(0.01)
            self.get_pin()
            sleep(0.1)
            self.post_pin()
            sleep(0.1)


    def data(self) -> dict:
        data = [
            {"pin": "5463", "state": True, "lock": False},
            {"pin": "9784", "state": False, "lock": True},
            {"pin": "9876", "state": True, "lock": True},
            {"pin": "4321", "state": False, "lock": False},
            {"pin": "0000"}, {"state": True}, {"lock": True},
            {"pin": "8672"}, {"state": False}, {"lock": False},
            ]
        return choice(data)

    def post_lock(self):
        req = request("POST", f"{self.url}/lock", json=self.data(), timeout=5)
        print(req.status_code, req.text)

    def get_lock(self):
        req = request("GET", f"{self.url}/lock", timeout=5)
        print(req.status_code, req.json())

    def post_state(self):
        req = request("POST", f"{self.url}/state", json=self.data(), timeout=5)
        print(req.status_code, req.text)
    
    def get_state(self):
        req = request("GET", f"{self.url}/state", timeout=5)
        print(req.status_code, req.json())

    def get_pin(self):
        req = request("GET", f"{self.url}/pin?key={self._key_}", timeout=5)
        print(req.status_code, req.json())

    def post_pin(self):
        req = request("POST", f"{self.url}/pin?key={self._key_}", json=self.data(), timeout=5)
        print(req.status_code, req.text)

# _req_ = request("POST", f"{url}/{route}?key={_key_}", json=data)
# print(_req_.status_code, _req_.json())

class TestStateApi:
    def __init__(self):
        self._key_ = "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"
        self.base_route = "DLIS"
        self.url = "https://iot-door-lock-system.onrender.com/" + self.base_route
        self.route: str
        self.state = True
    
    def PostState(self):
        self.post_requests = request("POST", f"{self.url}/state", json={"state": self.state}, timeout=5)
        print(self.post_requests.status_code, self.post_requests.json())
        self.state = not self.state

    def GetState(self):
        self.get_requests = request("GET", f"{self.url}/state", timeout=5)
        print(self.get_requests.status_code, self.get_requests.json())

class _TestStateApi_:
    def __init__(self):
        self._key_ = "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"
        self.base_route = "DLIS"
        self.host = "dubemchukwu.pythonanywhere.com"
        self.port = 443  # HTTPS
        self.state = True
        self.lock = False

    def _create_ssl_connection(self):
        context = ssl.create_default_context()
        raw_socket = socket.create_connection((self.host, self.port), timeout=5)
        return context.wrap_socket(raw_socket, server_hostname=self.host)

    def PostState(self):
        try:
            conn = self._create_ssl_connection()
            path = f"/{self.base_route}/state"
            body = json.dumps({"state": self.state, "lock": True})
            request = (
                f"POST {path} HTTP/1.1\r\n"
                f"Host: {self.host}\r\n"
                "Content-Type: application/json\r\n"
                f"Content-Length: {len(body)}\r\n"
                "Connection: close\r\n"
                "\r\n"
                f"{body}"
            )
            conn.send(request.encode())
            response = conn.recv(4096).decode()
            print("[POST] Raw Response:\n", response)
            conn.close()
            self.state = not self.state
        except Exception as e:
            print("POST Error:", e)

    def PostLock(self):
        try:
            conn = self._create_ssl_connection()
            path = f"/{self.base_route}/lock"
            body = json.dumps({"lock": self.lock})
            request = (
                f"POST {path} HTTP/1.1\r\n"
                f"Host: {self.host}\r\n"
                "Content-Type: application/json\r\n"
                f"Content-Length: {len(body)}\r\n"
                "Connection: close\r\n"
                "\r\n"
                f"{body}"
            )
            conn.send(request.encode())
            response = conn.recv(4096).decode()
            print("[POST] Raw Response:\n", response)
            conn.close()
            self.lock = not self.lock
        except Exception as e:
            print("POST Lock Error:", e)

    def GetState(self):
        try:
            conn = self._create_ssl_connection()
            path = f"/{self.base_route}/state"
            request = (
                f"GET {path} HTTP/1.1\r\n"
                f"Host: {self.host}\r\n"
                "Connection: close\r\n"
                "\r\n"
            )
            conn.send(request.encode())
            response = b""
            while True:
                chunk = conn.recv(1024)
                if not chunk:
                    break
                response += chunk
            conn.close()

            print("[GET] Raw Response:\n", response.decode())
        except Exception as e:
            print("GET Error:", e)


if __name__ == "__main__":
    # TestApiClient()
    stateapi = _TestStateApi_()
    while True:
        # stateapi.PostState()
        stateapi.PostLock()
        sleep(8.15)
        # stateapi.PostLock()
        # sleep(.15)