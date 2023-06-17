# Simple python example with threads
# This is too meta
# Joaquin Badillo

import threading
import time

def disp(message):
    # Waits 1 second and prints a message
    time.sleep(1)
    print(f"Message: {message}")

def main():
    print("Simple example")
    threads = []

    for i in range(5):
        thread = threading.Thread(target=disp, args=(f"Hello from thread {i + 1}",))
        threads.append(thread)
        print(f"Starting thread {i + 1}")
        thread.start()
    for thread in threads:
        thread.join()

    print("Threads finished")

if __name__ == "__main__":
    main()


