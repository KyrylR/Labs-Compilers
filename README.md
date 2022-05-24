# Labs-Compilers

[My notes here frome lectures](https://github.com/KyrylR/Compilers-Lectures)

## Certificate

[SOE.YCSCS1: Compilers edX Verified Certificate](https://courses.edx.org/certificates/59e85e4665be445bae7f0bee23c99750)

## Programming Assignment 1

### Task
For this assignment, you are to write a lexical analyzer, also called a scanner, using a lexical analyzer
generator. (The C++ tool is called flex; the Java tool is called jlex.) You will describe the set of tokens
for Cool in an appropriate input format, and the analyzer generator will generate the actual code (C++
or Java) for recognizing tokens in Cool programs.

**WARNING. The cool.flex constants are heavily interrelated with cool-parse.h**

### Useful Links to PA1:

[Character representation in regular expressions](https://uk.wikipedia.org/wiki/%D0%9F%D1%80%D0%B5%D0%B4%D1%81%D1%82%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%BD%D1%8F_%D1%81%D0%B8%D0%BC%D0%B2%D0%BE%D0%BB%D1%96%D0%B2_%D1%83_%D1%80%D0%B5%D0%B3%D1%83%D0%BB%D1%8F%D1%80%D0%BD%D0%B8%D1%85_%D0%B2%D0%B8%D1%80%D0%B0%D0%B7%D0%B0%D1%85)

[This manual describes flex](https://web.stanford.edu/class/archive/cs/cs143/cs143.1112/materials/other/manflex.html)


## Programming Assignment 2

### Task
In this assignment you will write a parser for Cool. The assignment makes use of two tools: the parser
generator (the C++ tool is called bison; the Java tool is called CUP) and a package for manipulating
trees. The output of your parser will be an abstract syntax tree (AST). You will construct this AST
using semantic actions of the parser generator.
You certainly will need to refer to the syntactic structure of Cool, found in Figure 1 of The Cool
Reference Manual (as well as other parts). The documentation for bison and CUP is available online.
The C++ version of the tree package is described in the Tour of Cool Support Code handout. The
documentation for the Java version is available online. You will need the tree package information for
this and future assignments.
There is a lot of information in this handout, and you need to know most of it to write a working
parser. Please read the handout thoroughly

**WARNING. The cool.flex constants are heavily interrelated with cool-parse.h**

### Useful Links to PA2:

[A Tour of the Cool Support Code](https://courses.edx.org/assets/courseware/v1/115f9c1f48cffa3192f23dc37c3a4eee/asset-v1:StanfordOnline+SOE.YCSCS1+3T2020+type@asset+block/cool-tour.pdf)

[This manual describes bison](https://www.gnu.org/software/bison/manual/bison.html)

[The Cool Reference Manual](https://www.gnu.org/software/bison/manual/bison.html)

## Authors

ex. Ryabov Kyrylo IPS-31

## License

This project is licensed under the [MIT] License - see the LICENSE.md file for details
