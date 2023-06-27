#! /usr/bin/env python3

import requests
import pdb
import sys

from xdg_base_dirs import xdg_cache_home

cache_dir = xdg_cache_home() / "oxford_pron"
cache_dir.mkdir(exist_ok=True)

base_url = "http://audio.oxforddictionaries.com/en/mp3/"


def clean(word: str):
    word = word.lower().replace(" ", "_").replace("-", "_")
    return word


def possible_filenames(word: str):
    if word.startswith("con"):
        yield from possible_filenames("x"+word)
    word = clean(word)
    a = 1
    b = 1
    c = 8
    filename = f"{word}_gb_{b}"
    yield filename
    filename = f"{word}_gb_{b}_{c}"
    yield filename
    filename = f"{word}_{a}_gb_{b}"
    yield filename
    filename = f"{word}_{a}_gb_{b}_{c}"
    yield filename


def is_cached(filename: str) -> bool:
    path = cache_dir / filename
    return path.exists()


def download(filename: str) -> bool:
    url = f"{base_url}{filename}"
    r = requests.get(url)
    if r.status_code == 200:
        with open(cache_dir / filename, "wb") as f:
            f.write(r.content)
        return True
    return False


def try_obtain_mp3(word: str):
    for filename in possible_filenames(word):
        filename = filename + ".mp3"
        if is_cached(filename):
            return cache_dir / filename
    for filename in possible_filenames(word):
        filename = filename + ".mp3"
        if download(filename):
            return cache_dir / filename
    return None


if __name__ == "__main__":
    p = try_obtain_mp3(sys.argv[1])
    if p:
        print(p)
