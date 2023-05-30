# Test 1: Functions, strings and numbers

def greetTheWorld():
    print("Hello World!")

def greetSomeone(name):
    print("Hello " + name + "!")

def factorial(num):
    # Implementation using Tail Recursion btw ;)
    def doFactorial(num, a):
        if (num == 0):
            return a
        else:
            return doFactorial(num - 1, a * num)
    
    return doFactorial(num, 1)

if (__name__ == "__main__"):
    greetTheWorld()
    greetSomeone("Gil")
    print("factorial(5) = " + str(factorial(5)))