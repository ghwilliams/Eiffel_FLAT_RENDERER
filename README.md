# Eiffel_FLAT_RENDERER
Strategies for debugging  Data structures in Eiffel 

## Introduction

This small project is an attempt to solve the problem
posed in the Eiffel users forum (see thread Renderers, a small community project
by Bertrand Meyer).
The problem consists in printing the elements of general data structures in a suitable
format. Such printing algorithm could then be used for debugging purposes.

This project is only a prototype, created with the sole purpose of
gaining a better understanding of the problem and playing with different strategies for
its solution.

Another solution strategy is being worked on by Larry Rix and can be found
at (https://github.com/ljr1981/iterable_output/).

## Methodology

The solution proposed in FLAT_RENDERER consist in traversing
the data structure recursively trhough its, possibly many, nesting
levels following a depth-first search algorithm. The algorithm
prints the value of a given element in the data structure if
this element is one of INTEGER, STRING, REAL or DOUBLE data types and
proceeds recursively otherwise.

## Output format

Each datum (element of type INTEGER, STRING, REAL or DOUBLE) is printed
in an individual line. For each dimension (or nesting level) is
printed also a counter indicating the current sequence number in that dimension.

## Examples

For a data structure defined as<br>
```
    table: ARRAY[ARRAY[STRING]]
```
and initialized as<br>
```
table[1].item(1) := "Orange";     table[1].item(2) := "Banana"; table[1].item(3) := "Apple"; table[1].item(4) := "Melom"
table[2].item(1) := "Eiffel";     table[2].item(2) := "Java";   table[2].item(3) := "C++";   table[2].item(4) := "C#"
table[3].item(1) := "Stepanov";   table[3].item(2) := "Wirth";  table[3].item(3) := "B. Meyer"; table[3].item(4) := "Stroustrup"
```
  
The output is:<br>

```
1 1 Orange
1 2 Banana
1 3 Apple
1 4 Melom
2 1 Eiffel
2 2 Java
2 3 C++
2 4 C#
3 1 Stepanov
3 2 Wirth
3 3 B. Meyer
3 4 Stroustrup
```

## Aknowledgement
 All friends from Eiffel Users forum
 
