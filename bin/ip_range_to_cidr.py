#! /usr/bin/python
import ipaddress
from icecream import ic
import sys

def convert(s: str):
    ip_addresses = [ipaddress.IPv4Address(i.strip()) for i in s.split('-')]
    start = ip_addresses[0]
    end = ip_addresses[1]
    return ipaddress.summarize_address_range(start, end)

def main():
    result = sum([list(convert(line)) for line in sys.stdin], [])
    result = [str(i) for i in result]
    for n, i in enumerate(result):
        # print(f"route{n+1}={i}")
        print(i)

if __name__ == "__main__":
    main()
