note
	description: "[
		Print the elements of a given (possibly multidimensional) data structure
		]"
	purpose: "[
		This is an attempt to solve the problem on how to debug
		a given data structure. This problem was posed by 
		Bertrand Meyer on the Eiffel users forum:
			see thread Renders, a small community project by Bertrand Meyer.
		]"
	how: "[
		This class supplies procedures for dumping data sctructures conforming
		to very specific abstract base classes.
		The following abstract classes are currently supported:
		  * READABLE_INDEXABLE
		The dump algorithms traverse the data structures recursively until a
		basic type is found when the element value is printed.
		The following basic types are currently implemented
		  * STRING, INTEGER, REAL, and DOUBLE
		]"
	author: "Williams Lima"
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER

feature {ANY} -- exported dump procedures

	dump_01(a_data_structure: READABLE_INDEXABLE[ANY])
		note
			arguments: "[
						a_data_structure  Data sctructure to be dumped
						]"
			purpose: "[
						This routine is an iterface to the internal routine render_01.
			         ]"

		local
			dimensions: ARRAY[INTEGER]     -- This vector stores a counter for each dimension		
										   -- used by routine render_01
			start_dimension: INTEGER       --

										   -- used by routine render_01		
		do
			-- Initialize auxiliary work variables
			start_dimension := 1            -- We start at the top level (first dimension)
			create dimensions.make_empty
			dimensions.force (1, 1)

			render_01 (a_data_structure, dimensions, Start_dimension)
		ensure
			class
		end

feature {NONE} -- Private auxiliary routines

	render_01 (a_child: READABLE_INDEXABLE[ANY]; dimensions: ARRAY[INTEGER]; current_dimension: INTEGER)
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
				-- What is definition of dimension in this routine?
				--   Dimension is defined by the number of nested structures
				--   composing 'a_data_structure.
				-- For example:
				--  a - v: ARRAY[LINKED_LIST[STRING]]
				--      In this case v is considered as two-dimensional
				--  b - ARRAY2[STRING]
				--      This is a one-dimensional data structure - ARRAY2 stores its elements
				--      in a single linear array. So although ARRAY2 is used to represent
				--      real world two-dimensional structures, this routine sees it as
				--      one-dimensional.
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
		do
			-- Processing of basic data types
			--    STRING, INTEGER, REAL, and DOUBLE
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
			elseif attached {READABLE_INDEXABLE[ANY]} a_child as al_child then
				-- Recursive traversal of the data sctructure
				-- Start
				across a_child.lower |..| a_child.upper as i loop
					if attached {READABLE_INDEXABLE[ANY]} a_child.item (i.item) as al_child_item then
						dimensions.force (1, current_dimension+1)
						render_01 (al_child_item, dimensions, current_dimension+1)
					end
					dimensions[current_dimension] := dimensions[current_dimension] + 1
				end
				-- End Recursive traversal of data structure
			else
				across a_child.lower |..| a_child.upper as i loop
					across 1 |..| (dimensions.count-1) as  ic loop
						io.put_string (dimensions[ic.item].out + " ")
					end
					io.put_string ( i.item.out + " " + "****" + " ") io.put_new_line
				end
			end
		ensure
			class

		end
end
