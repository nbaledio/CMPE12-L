------------------------
Lab 5: Subroutines
CMPE 012 Winter 2019
Baledio, Nathan
nbaledio
-------------------------

My design approach was to first start out with a skeleton
of each of the three main functions and then work on them
one by one. I wanted to save the cipher function for last
as I knew it would have nested function calls that would
have to deal with saving return addresses in the stack.
Once I got to working on cipher, I worked on it from
the most nested call first, and then realized that I 
should have worked from the first call to the last, as
it would have made keeping track of the stack pointer 
much easier.

I learned about dealing with the the stack pointer as 
well as dealing with return addresses, which was very
helpful. Before, my code would use a lot of jump 
statements and have many labels for return points, and I
found that to be very tiring. Now after learning about 
the jump and link function and how saving addresses can
combine with this function, I learned how to make my
code a bit cleaner when it came to jumps.

I actually encounterd a lot of issues in this lab. First
was linking the two files, which simply turned out to be
me forgetting to write ".text"  on my lab file. Then 
came the biggest problem. In my cipher method, for some
reason the user input string would be overwritten and 
there was no way for me to save it's value before it was
either encrypted or decrypted. The only solution I could
come up with was to have the string re-encrpyt/decrypt
itself in the print strings method so I could show the
before and after strings properly. It works this way, but
I still don't know why I was unable to save the original
strings.

The one thing I would have actually preferred was to
write my own main function. It's nice to have it done,
and this teaches us about linking files, but there were
times where I wished I could tweak the main file so I 
could make things easier for my functions. I know it's
good practice to adapt your own code to others', but it's
always a long process to do so.

I did not collaborate with anyone on this lab.