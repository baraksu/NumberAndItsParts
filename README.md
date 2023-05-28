# Find Number Divisors | Assembly Project by Yonatan Daga

**Project Name:** Find Number Divisors \
**Programmer:** Yonatan Daga \
**Teacher:** Barak Suberri \
**Grade:** 10a \
**School:** Yeshivat Bnei Akiva - Givat Shmuel \
**Year:** 2023

## What does the program do?

The program gets a number (up to 4-digits) as an input. \
The program will print all of the numbers that are divisable by the entered number. \
It supports both positive and negative numbers.

## Running Examples

### Example 1: The Number 1000

<img
  src = "https://github.com/baraksu/NumberAndItsParts/blob/main/Screenshots/Run1.png?raw=true"
  style = "
    display: block;
    margin-left: auto;
    margin-right: auto;
    width: 70%;"
/>

In this picture we can see that the entered number is 1000. \
The program displayes as an all of the numbers that are disivable by 1000 without a remainder,
as an exercise.

### Example 2: (-10)

<img
  src = "https://github.com/baraksu/NumberAndItsParts/blob/main/Screenshots/Run2.png?raw=true"
  style = "
    display: block;
    margin-left: auto;
    margin-right: auto;
    width: 60%;"
/>

In this picture we can see that the entered number is (-10). \
We can also see here that the program knows how to work with negative numbers, and even
with numbers that have less than 4 digits. The program will display all of the divisors of
(-10). In this case, of course, both negative and positive numbers will be displayed.

> Note: Numbers that are less than 4 digits needs to be padded with zeros.

## Developing Process

Developing this project was a long and challenging process.

### Planning the Algorithm

At first, I decided to plan the project's algorithm. I planned everything
including how the code would work, and what would happen "behind the scenes". \
Even before I actually started writing the code, I knew exactly how it would be built
and what would every single part do.

I started planning the algorithm with thinking about the project as a modular code, and
splitting the long process to different procedures.

#### Procedures In This Project

* `print` - Prints a string to the console.
* `check_minus` - Checks for a minus sign and gets another digit as input, if needed.
* `str_to_num` - Converts a string to a number.
* `num_to_str` - Converts a number to a string.
* `printDivisors` - Prints a number's divisors.
* `resetStr` - Resetting `my_string` to '$'. (This procedure was added on the developing
  process, since it was a long code-snippet that was repeated many times in the code.)

I planned exactly how to combine all of the procedures in the project, and how every job
will be divided between them - and then I continued to the next step.

### Developing the Program and Writing the Code

I started developing the program and writing the code itself by writing individual procedures,
and generally individual code-snippets that will be mixed together afterwards.

#### Getting The Input

The first part of the program is getting a number from the user as an input. On this part, of
course, I needed to convert a string to a number.

I started with printing an appropriate prompt, and creating a loop that repeats 4 times - in
every repetition the user will enter 1 character. The problem here was handling an input that
includes a minus sign - If the user would enter a minus sign, they would only be able to enter
3 digits afterwards. Even if the input would be 5 characters long - the user would not be able
to enter positive numbers. That's why I wrote the `check_minus` procedure.

The minus sign in the entered number is not stored as a part of the number. It is stored
inside a different variable, named `minus`. Its default value is `0`, and it changes to `1`
when a minus sign is entered. \
Because of the reason mentioned before, the procedure `check_minus` is responsible of checking
whether a minus sign was entered, and if needed, get another digit as an input.

Now that we finished getting the input, the next step will require us to convert the string to
an actual number. That's why I wrote the procedure `str_to_num`, which is responsible of
converting the entered string to a number, just like the `int.Parse()` function in C#
language.

Converting the string to a number has been a major part of the project - and one of
the hardest procedures I wrote in it. This procedure splits the string into individual
characters, converts every character to a digit by subtracting 30h (ASCII value for the
character "0") from its value, and multiplies the digit by the appropriate number according to
the character's index in the original string (first character is multiplied by 1000,
second character by 100, etc.)

Notice that the procedure `str_to_num` ignores the minus sign. The number that the procedure
returns will be positive anyway - even if the user entered a minus sign.

> Note: The procedure `str_to_num` (like every other procedure in this project), was developed
> from scratch by me, and I did not use any external code-snippets although they are very common
> on the internet.

#### Printing The Number Divisors

Now that we have the entered number stored as an actual number (and not a string) - we can
continue to the next part. This is the main part of this project: **printing the number's
divisors.**

In order to print the number divisors, we loop through all of the numbers from the entered
number to zero. On every repetition, we divide the entered number by the current loop index,
and display the whole exercise if there is no remainder.

Before displaying the exercise, we need to convert every number to a string - That's why we need
the `num_to_str` procedure in this project. This procedure gets a number, and returns this
number as a string. In order to do so, the procedure splits the number into individual digits,
adds 30h (ASCII value for character "0" character) to its value, and merges all of them into one
string that can be printed normally.

We can see that there are a lot of prints in this section, and that's why I decided to add two
more procedures to this project:

The first procedure I decided to add here is `print`, which as the name suggests, simply prints
a string. It is a simple procedure that prints a string using the normal `21h/09h` interrupt,
and although it looks simple and unnecessary, it helped me a lot in this project, and saved me
a lot of lines.

The second procedure added here is `resetStr`, which helps us reset the variable `my_string` to
`$$$$$$`. To explain why we need to do this so often, we firstly need to understand how the
program prints things in this section: When printing something in this section of the program,
the string will firstly be saved in the `my_string` variable, and then printed using the `print`
procedure. We use the same variable to save many things, and that's why we need to reset it so
often.

### Important Variables

In order to better understand how the program works, let's take another look at the first running
example. This time, we'll also look at how the variables change in real-time.

> Note: Only the important variables can be seen here.

<video autoplay loop muted playsinline src="https://github.com/baraksu/NumberAndItsParts/blob/main/Screenshots/Run1.webm?raw=true" controls="controls" style="display: block; margin-left: auto; margin-right: auto; width: 60%;"/>

We can see here that the number 1000 has been entered, but this time we can also see what happens
"behind the scenes". So what are all of these variables?

* `minus` - A minus sign indicator. In this case, no minus sign has been entered.
* `my_string` - A temp string variable that is used to save strings before printing them.
* `main` - The first number in the division exercise, which is the absolute value of the entered
number. In this case, its value is 1000.
* `second` - The second number in the division exercise, which is the current loop counter. In this
case, its value changes between 1000 and 1.
* `result` - The quotient of the division exercise.
* `remain` - The remainder of the division exercise. When it's 0 - the exercise will be displayed.

## Possible Future Features

In the future, I would like to add more features like supporting bigger numbers (5+ digits), or
even supporting other bases, like binary or hexadecimal numbers. If I'll continue to work on this
project, I would imporove the graphics, and maybe create a whole new GUI.

## Personal Experience

Like explained in the previous section, developing this project was a long and challenging process.
I planned everything before starting to code, so I pretty much knew what to expect. The most
challenging part was to convert numbers to strings, and vice versa. After I could do that -
everything else seemed easier than before.

Other than that, it was very interesting and different to work on a such a big project in Assembly.
As a developer that has worked on big projects on higher languages like Python, JS or even Java, C
and C# \(For example, this [entire Python back-end for my app](https://github.com/yonatand1230/KitappResources)\),
it was a unique experience to develop a program in Assembly, and get to see how everything
works "behind the scenes". For example, in higher languages you don't always get to see how and
where the computer stores everything in the memory, and generally you don't always really know how
everything works and what the computer's actually doing. On the other hand, when developing in Assembly,
you write every little action that the computer does, and you really get to learn more about how the
computer works.
