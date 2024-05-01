import time


def time_function(f):
    def new_foo(*args, **kwargs):
        start = time.time()
        f(*args, **kwargs)
        print(f"{f.__name__}: {time.time() - start:.5f}")

    return new_foo


@time_function
def square(n):
    time.sleep(1)
    return n * n


if __name__ == "__main__":
    square(20)
