from math import *
if __name__ == "__main__":
    min = int(input("Start: "))
    max = int(input("End: "))
    for i in range(min, max):
        yes = True
        for j in range(2, int(sqrt(i) + 1)):
            if i % j == 0:
                yes = False
                break
        if yes:
            print(i)