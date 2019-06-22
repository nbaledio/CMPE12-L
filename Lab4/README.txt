------------------------
Lab 4: ASCII (HEX or 2SC) to Base 4
CMPE 012 Winter 2019

Baledio, Nathan
nbaledio
-------------------------

At first, I took the approach that was drawn out for us,
but then I started to design my code in my own way. So
first, I loaded the bits located in the second position
of each argument, as they would tell me if the argument 
was binary or hex depending on the character found. 
Depending on the result, I converted using a binary
conversion or a hex conversion. The idea of both 
conversions is to read each ASCII value and convert it to
an integer value and add it to a total sum. This would
represent the input in decimal form. Next, depending on
the number, I would either subtract 256 to convert it to
its negative 2SC or leave alone if was positive. Now that
the two inputs are in 2SC decimal form, all I need to do
is add them together and convert to base 4. To convert
to base 4 without a print integer syscall, I first 
checked the number of digits in the sum and made 4 
different paths to handle how many digits would be 
printed (there will be at most 4). Each method uses
division to isolate the rightmost digit and converts it
to its corresponding ASCII value. Then the print char
call prints them one by one until the full sum is printed.

I learned about loading bytes into my registers as well
as learning how to reuse registers to avoid the limited
registers available. It was also a good refresher on
converting values to different bases as well as exploring
the other syscalls that are available.

My biggest issues were figuring out how to actually 
implement my pseudocode to actual code. Without certain
syscalls available (namely syscall 1) I had to work 
around some of my original plans and implement longer
work arounds so I could have my code work. This involved
a lot of functional programming, but in the end I was
able to avoid using prohibitted commands. Overall, I 
would say the lab wasn't as enjoyable as previous labs
(due to increased difficulty), but I was able to finish 
it in two days.

I didn't really think this lab was hard, but rather long.
Yes, figuring out how to convert inputs and such was a
bit difficult, but I think it was more or less due to
me trying to find out if there was an easier way to do
it instead of coding a long way. If anything were to be
redesigned, I think outputting it in simple base 10 2SC
instead of base 4 would be a lot easier. I saw the whole
base 4 thing as more of a challenge rather than something
to apply our knowledge to (aside from conversions, which
we should already know by now).

I did not collaborate with anyone on this lab.