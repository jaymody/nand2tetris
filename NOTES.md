N2T (`nand2tetris`) is an excellent introduction to building a computer from scratch. To keep the book as simple as possible, it intentionally leaves out lots of details (which is a good thing, you shouldn't need to learn about transistor physics or know the arm64 ISA front to back just to implement your first computer!!!).

However, I am curious, what are those details that take you from `nand2tetris` to your average computer in 2023? This is a collection of my notes that attempts to fill in those gaps, as much as possible, and along the way research the big ideas (and ask the big questions) that at least should get you 80% of the way to building a modern day computer.

# Transistors
N2T works on the abstraction of the NAND gate, DFF, and the CPU clock. But how exactly do these things work? Crash course computer science does provides some useful insights: https://www.youtube.com/watch?v=gI-qXk7XojA

# History: Intel 4004
Would be interesting to exactly reimplement the intel 4004, which was the first commercially available single-chip microprocessor. It has a very simple micro-architecture, would be interesting to see how it works to situate myself historically.

# Micro-architectures and ISAs
What are the large ideas behind designing modern micro-architectures and ISAs? How did we get here?

How do caches work?

Are they faster simply because of proximity to the CPU?

Is there limit in size simply due to physics?

Arm64 vs x86?

Why are there so many instructions? Backwards compatibility?

What are the major axis of tradeoffs when it comes to micro-architectures? ISAs? (i.e. simplicity of ISA vs speed vs number of transistors vs thermal vs energy consumption vs cost to fab vs material cost etc ... )

What were some not so good design decision that have stuck around, due to backwards compatibility or other reasons? In other words, if you could turn back time, and redesign a CPU, what would you do differently?

# The Clock
Why is the limit of clock speed what it is? Is that due to the limits of the speed of electricity? Or is it because the oscillators can't go fast enough? Energy consumption?

How accurate is the CPU clock? How is time determined by a computer?

# Electricity
How is energy "consumed" by the computer? Is is just the constant flipping of the circuits from the clock?

# Thermal
What are the major limitations of hardware, in terms of heat? How much energy is transformed into heat?
