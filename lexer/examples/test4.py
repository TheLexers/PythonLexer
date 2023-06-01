# Test with code that is just a little bit more sophisticated
# Testing yield, lambdas, type annotations, and more

from typing import Type

# Mergesort in place
def mergesort(lst: list) -> None:
    def doMergesort(lst: list, start: int, end: int) -> None:
        if (start >= end):
            return

        midpoint = (start + end) // 2

        doMergesort(lst, start, midpoint)
        doMergesort(lst, midpoint + 1, end)
            
        left = lst[start : midpoint + 1]
        right = lst[midpoint + 1 : end + 1]
        i = 0
        j = 0
        k = start

        while (i < len(left) and j < len(right)):
            if (left[i] < right[j]):
                lst[k] = left[i]
                i += 1
            else:
                lst[k] = right[j]
                j += 1
            k += 1
        
        while (i < len(left)):
            lst[k] = left[i]
            i += 1
            k += 1
        
        while (j < len(right)):
            lst[k] = right[j]
            j += 1
            k += 1
    
    doMergesort(lst, 0, len(lst) - 1)

# A memory efficient generator for Fibonacci numbers
def fibGenerator(num: int) -> int:
    currentFib = 0
    nextFib = 1

    count = 0

    # We just wanted to test the yield keyword haha
    while count < num:
        yield currentFib
        
        count += 1

        temp = currentFib
        currentFib = nextFib
        nextFib += temp

# A function that uses map and filter to check which squares end in 4
def mystery(lst: list) -> list:
    squared = map(lambda x: x * x, lst)
    return filter(lambda x: x % 10 == 4, squared)

# Approximate the root of a function using Newton's method
def root(f, df, x0: float, i: int) -> float:
    x = x0

    for val in range(i):
        x = x - f(x) / df(x)

    return x

# Let's test some classes why not
class Vector2:
    def __init__(self):
        self.x = 0
        self.y = 0
    
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y
    
    def __add__(self, vector):
        return Vector2(self.x + vector.x, self.y + vector.y)
    
    def __sub__(self, vector):
        return Vector2(self.x - vector.x, self.y - vector.y)

    def __mul__(self, vector):
        # Inner product
        return self.x * vector.x + self.y * vector.y
    
    def __str__(self) -> str:
        return "(" + str(self.x) + ", " + str(self.y) + ")"

def main() -> None:
    lst = [8, 2, 3, 7, 4, 11, 3]

    print("Sorting list: " + str(lst))
    mergesort(lst)
    print("Done: " + str(lst), end="\n\n")

    print("Generating fibonnaci numbers...")
    for fib in fibGenerator(10):
        print(fib, end=" ")
    print("\n")

    print("Using mystery function...")
    print(list(mystery([x for x in range(10)])), end="\n\n")

    print("Approximation for sqrt(2) using Newton's Method:")
    print(root(lambda x: x * x - 2, lambda x: 2 * x, 1, 10), end="\n\n")

    print("Let's try some vectors!")
    v1 = Vector2(1, 2)
    print("v1 = " + str(v1))
    v2 = Vector2(3, 4)
    print("v2 = " + str(v2))

    print("v1 + v2 = " + str(v1 + v2))
    print("v1 - v2 = " + str(v1 - v2))
    print("v1 * v2 = " + str(v1 * v2))

if (__name__ == "__main__"):
    print("Welcome to the 4th test file!", end="\n\n")
    main()