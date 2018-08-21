note
	description: "[
			Dump a given (possibly multidimensional) data structure
		]"
	purpose: "[
		This is an attempt to solve the problem on how to debug
		a given data structure. This problem was posed by Bertrand Meyer on the Eiffel users forum:
		see thread Renders, a small community project by Bertrand Meyer.
		]"
	author: "Williams Lima"
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER

create
	make

feature

	make
		-- Nothing special yet
		do

		end

feature

	render (a_child: READABLE_INDEXABLE[ANY]; dimensions: ARRAY[INTEGER]; current_dimension: INTEGER)
		note
			arguments: "[
				a_child			  Data sctructure to be dumped
				dimensions  	  Work vector containing a counter for each dimension
				current_dimension The current dimension being processed
				]"
			purpose: "[
				To print to the console all the elements in the supplied data structure 'a_child'.
			]"
			how: "[
				By depth-first traversing the data structure and printing its elements one per line.
				The tricky part is to save a count for each dimension such that
				the indices for each printed dimension can be shown properly
				]"
			example: "[
				For a 2D data structure we can visualize it as
				    a b c                1,1   1,2   1,3
				    d e f   => indices   2,1   2,2   2,3				    
				 if it was defined as ARRAY[ARRAY[G]] the most internal data is printed first.
				 In the example above lines are printed first.
				 
				 The output from this routine for the example above will be
				 	1 1 a
				 	1 2 b
				 	1 3 c
				 	2 1 d
				 	2 2 e
				 	2 3 f
				 In the above output each column (except the last, wich contains the data itself)
				 is associated with one dimensions of the data.
				 ]"
			TODO: "[
				* Include more basic data types
				* Simplify the argument list - removing dimensions and current_dimension arguments.
				  Processing of basic data types				
				* Improve documentation
				* Improve conformance to style rules
				]"
		do
			-- Processing of basic data types
			-- Start
			if attached {STRING} a_child.item (a_child.lower)
				or attached {NUMERIC} a_child.item (a_child.lower) then
				across a_child.lower |..| a_child.upper as i loop
					across 1 |..| (dimensions.count-1) as  ic loop
						io.put_string (dimensions[ic.item].out + " ")
					end
					io.put_string ( i.item.out + " " + a_child.item (i.item).out + " ") io.put_new_line
				end
			-- End - Processing of basic data types
			else
				-- Recursive traversal of the data sctructure
				-- Start
				across a_child.lower |..| a_child.upper as i loop
					if attached {READABLE_INDEXABLE[ANY]} a_child.item (i.item) as al_child then
						dimensions.force (1, current_dimension+1)
						render (al_child, dimensions, current_dimension+1)
					end
					dimensions[current_dimension] := dimensions[current_dimension] + 1
				end
				-- End Recursive traversal of data structure
			end

		ensure
			class

		end

end
