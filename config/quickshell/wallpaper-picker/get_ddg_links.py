#!/usr/bin/env python3
"""
get_ddg_links.py — DuckDuckGo Images scraper for the wallpaper picker.
Outputs pipe-separated pairs: <thumbnail_url>|<full_image_url>
Only yields results with width >= 1920 and height >= 1080.
"""
import sys
import json
import time
import re
import os
import urllib.request
import urllib.parse
import http.cookiejar

LOG_FILE     = "/tmp/qs_python_scraper.log"
CONTROL_FILE = "/tmp/ddg_search_control"


def log(msg):
    try:
        with open(LOG_FILE, "a") as f:
            f.write(f"{time.strftime('%H:%M:%S')} - {msg}\n")
    except Exception:
        pass


def get_state():
    try:
        with open(CONTROL_FILE) as f:
            return f.read().strip()
    except Exception:
        return "run"


def main():
    log("=== NEW SEARCH STARTING ===")
    if len(sys.argv) < 2:
        log("ERROR: No query provided.")
        return

    query = sys.argv[1].strip() + " wallpaper"
    log(f"Query: '{query}'")

    cj     = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    urllib.request.install_opener(opener)

    headers = {
        "User-Agent":      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                           "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept":          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,"
                           "image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Referer":         "https://duckduckgo.com/",
    }

    search_url = (
        "https://duckduckgo.com/"
        f"?q={urllib.parse.quote(query)}&iar=images&iax=images&ia=images&kp=-1"
    )
    vqd = None

    log(f"Fetching VQD token from: {search_url}")
    for attempt in range(3):
        try:
            req  = urllib.request.Request(search_url, headers=headers)
            html = urllib.request.urlopen(req, timeout=10).read().decode("utf-8")
            match = re.search(r'vqd=([0-9a-zA-Z_-]+)', html) or \
                    re.search(r'vqd[\'"]?\s*:\s*[\'"]?([0-9a-zA-Z_-]+)', html)
            if match:
                vqd = match.group(1)
                log(f"VQD token: {vqd}")
                break
            log(f"Attempt {attempt + 1}: VQD not found in HTML.")
        except Exception as e:
            log(f"Attempt {attempt + 1} error: {e}")
            time.sleep(1)

    if not vqd:
        log("CRITICAL: Could not obtain VQD token. Aborting.")
        return

    headers["Referer"] = search_url
    headers["Accept"]  = "application/json, text/javascript, */*; q=0.01"

    next_url    = None
    links_found = 0

    for page in range(5):
        state = get_state()
        if state == "stop":
            log("Stop signal before page fetch. Exiting.")
            break
        while state == "pause":
            time.sleep(1)
            state = get_state()

        log(f"Fetching JSON page {page + 1}…")

        params = {
            "l":   "us-en",
            "o":   "json",
            "q":   query,
            "vqd": vqd,
            "f":   ",,,",
            "p":   "-1",
            "ex":  "-1",
        }

        url = (
            "https://duckduckgo.com" + next_url
            if next_url
            else "https://duckduckgo.com/i.js?" + urllib.parse.urlencode(params)
        )
        if next_url:
            if "p=-1"  not in url: url += "&p=-1"
            if "vqd="  not in url: url += f"&vqd={vqd}"

        try:
            req  = urllib.request.Request(url, headers=headers)
            data = json.loads(urllib.request.urlopen(req, timeout=10).read().decode("utf-8"))
            results = data.get("results", [])
            log(f"Page {page + 1}: {len(results)} raw results.")

            for res in results:
                if int(res.get("width",  0)) >= 1920 and int(res.get("height", 0)) >= 1080:
                    t, i = res.get("thumbnail"), res.get("image")
                    if t and i:
                        try:
                            sys.stdout.write(f"{t}|{i}\n")
                            sys.stdout.flush()
                            links_found += 1
                        except BrokenPipeError:
                            log("Broken pipe — bash side stopped listening.")
                            os._exit(0)

            next_url = data.get("next")
            if not next_url:
                log("No 'next' page from DDG.")
                break

        except BrokenPipeError:
            os._exit(0)
        except Exception as e:
            log(f"Error on page {page + 1}: {e}")
            break

    log(f"=== SEARCH COMPLETE. FHD+ links yielded: {links_found} ===")


if __name__ == "__main__":
    try:
        os.remove(LOG_FILE)
    except Exception:
        pass

    try:
        main()
        sys.stdout.flush()
    except BrokenPipeError:
        os._exit(0)
    except KeyboardInterrupt:
        os._exit(1)
    except Exception as e:
        log(f"FATAL: {e}")
        os._exit(1)
