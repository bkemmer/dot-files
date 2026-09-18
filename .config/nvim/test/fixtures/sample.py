# Fixture for textobject assertions. Line numbers are load-bearing:
# test_behaviour.lua references them directly. Do not reformat.
CONSTANT = 42


def greet(name, punctuation):
    message = "hello " + name
    return message + punctuation


class Greeter:
    def __init__(self, prefix):
        self.prefix = prefix

    def call(self):
        return greet(self.prefix, "!")


result = greet("world", "?")
