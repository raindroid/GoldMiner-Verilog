if __name__ == "__main__":
    for k in range(18, 10, -1):
        print("(data[moveIndex * 32 + %d] << %d) + "%(k, k-11))