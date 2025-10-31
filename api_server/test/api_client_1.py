import requests
from requests import request
from random import choice
from time import sleep

class TestApiClient:
    """Test API Client for IoT Door System"""

    def __init__(self):
        self._state_ = False
        self._key_ = "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"
        self.base_route = "DLIS"
        # self.url = "https://iot-door-lock-system.onrender.com/" + self.base_route
        self.url = "https://dubemchukwu.pythonanywhere.com/" + self.base_route
        # self.url = "http://127.0.0.1:8000/" + self.base_route
        self.route: str
        # for _ in range(10):
        while True:
            # self.post_lock()
            # sleep(0.01)
            # self.get_lock()
            sleep(0.01)
            # self.get_state()
            sleep(0.01)
            self.post_state()
            # sleep(0.01)
            # self.get_pin()
            sleep(8.1)
            # self.post_pin()
            # sleep(0.1)


    def data(self) -> dict:
        data = [
            {"pin": "5463", "state": True, "lock": False},
            {"pin": "9784", "state": False, "lock": True},
            {"pin": "9876", "state": True, "lock": True},
            {"pin": "4321", "state": False, "lock": False},
            {"pin": "0000"}, {"state": True}, {"lock": True},
            {"pin": "8672"}, {"state": False}, {"lock": False},
            ]
        self._state_ = not self._state_
        return {"state": self._state_}

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
        req = request("GET", f"{self.url}/pin", headers={"key": "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"}, timeout=5)
        print(req.status_code, req.json())

    def post_pin(self):
        req = request("POST", f"{self.url}/pin", headers={"key": self._key_}, json=self.data(), timeout=5)
        print(req.status_code, req.text)

# _req_ = request("POST", f"{url}/{route}?key={_key_}", json=data)
# print(_req_.status_code, _req_.json())

if __name__ == "__main__":
    TestApiClient()