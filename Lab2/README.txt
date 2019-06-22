------------------------
Lab 2: Whack-A-Mole
CMPE 012 Winter 2019
Baledio, Nathan
nbaledio
-------------------------

There were a few learning objectives from this lab.
In order to better understand sequential logic, we
implemented a makeshift game of whack-a-mole. The goal
was to learn about registers and multiplexers and how we
can use them to implement signed numbers. I'll admit, my
design approach was unorganized at first, but I was able
to approach the lab efficiently in the end. First I 
started with a 1 bit register and copied it 3 times.
After seeing how it was able to record a value for the
register, I then started on the adder, implementing it
via a truth table. After that I focused on making the
register pass certain values upon whack being hit. The 
last part was converting the score to a signed magnitude
which was done using another 4-bit adder. My main issue
I encountered with the lab was figuring out where to
start. At first I thought I could implement it without
all of the learning objectives, but then I realized I
was doing the assignment completely wrong. I had to
reset all of my progress aside from my 4-bit adder. Once
I realized how 2's complement worked, everything fell 
into place. It was enjoyable to see how 2's complement
seeming fixed everything I was having a problem with
and how simple it was to implement it with the adders.
I think the biggest challenge was understanding the
concepts we learned in class. Before doing the lab, I
was still confused on many of the things we were supposed
to implement, but after playing with it for a bit, I was
able to figure everything out and realized that the lab
could probably be finished in 30 min-1 hour at its 
quickest. If there was any part of the lab I would 
redesign, I think it would be to include a hint as to the
design path to take. Ex: what we should start with, and
then what we should do next, because I was completely 
lost as to how to first start this lab when I first read
it. The end goal was relatively simple, it's just that
there were many components to deal with, and some would
be harder to deal with if other parts weren't created 
first. I found it easier to build the 4 bit register,
and link it to the 7 segment display to see how values
were recorded when whack was hit. Then doing the adder
with the logic of twos complement with dummy switches
made it easy to see how adding and subtracting worked.
Then moving on to combining the adder and register would
be the next step and finally adjusting the adder to act
different depending on when whack was hit. And lastly 
doing the sign conversion.