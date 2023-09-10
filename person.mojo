struct Person:
    var name: String
    var age:  Int
    

    fn __init__(inout self, name: StringLiteral, age: Int):
        self.name = name
        self.age = age

    fn greet_to(self, another: Self):
        let message = "[" + self.name + "] Hello, " + another.name + "!"
        print(message)

fn main():
    let Alice = Person("Alice", 314)
    let Bob = Person("Bob", 524)
    Alice.greet_to(Bob)
