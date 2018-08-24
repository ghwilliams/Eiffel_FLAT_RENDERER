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
    table: ARRAY[HASH_TABLE[INTEGER, STRING]]
```
and initialized as<br>
```
table[1].put(400,"Zurich"); table[1].put(198,"Geneva"); table[1].put(176,"Basel"); table[1].put(146,"Lausanne")
table[2].put(1894,"Balzer"); table[2].put(1893,"Duryea Car"); table[2].put(1889,"Daimler-Maybach Stahlradwagen");table[2].put(1884,"La Marquise")
```
  
The output is:<br>

```
1 Zurich 400
1 Geneva 198
1 Basel 176
1 Lausanne 146
2 Balzer 1894
2 Duryea Car 1893
2 Daimler-Maybach Stahlradwagen 1889
2 La Marquise 1884
```

## Aknowledgements
 All friends from Eiffel Users forum
 
