import threading
import math

def burn():
    while True:
        math.sqrt(123456789)  # pointless CPU work

# number of worker threads = how hard you push
for _ in range(4):  # start with 4; raise to 8,16 later to scale harder
    t = threading.Thread(target=burn)
    t.start()

# keep main thread alive
while True:
    pass
