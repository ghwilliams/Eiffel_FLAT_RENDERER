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

	dump_01 (a_data_structure: ANY)
		note
			arguments: "[
						a_data_structure  Data sctructure to be dumped
						]"
			purpose: "[
						This routine is an iterface to the internal routine render_01.
			         ]"

		local

		do
			if attached {READABLE_INDEXABLE[ANY]} a_data_structure as al_ri then
				dump_readable_indexable (al_ri, "")
			elseif attached {TUPLE} a_data_structure as al_tp then
				dump_tuple (al_tp, "")
			end
		ensure
			class
		end

feature {NONE} -- Private auxiliary routines

	dump_readable_indexable (a_child: READABLE_INDEXABLE[ANY]; a_str: STRING)
		note
			arguments: "[
				a_child			  Data sctructure to be dumped
				a_str             Work string containing a counter for each dimension
				]"
			purpose: "[
				To print to the console all the elements in the supplied data structure 'a_child'.
				This version specialized for READABLE_INDEXABLE class.
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
		local
			keys: ARRAY[STRING]
			k: INTEGER
			l_str: STRING
		do
			if attached {HASH_TABLE[ANY,STRING]} a_child as al_ht then
				keys := al_ht.current_keys
			end
			from k:= a_child.lower until k > a_child.upper loop
				if keys /= Void then
					l_str := a_str + " " + keys[k+1]
				else
					l_str := a_str + " " + k.out
				end

				if attached {STRING} a_child.item (k) as al_str then
					io.put_string (l_str + " ")
					io.put_string (al_str + " ") io.put_new_line
				elseif attached {NUMERIC} a_child.item (k) as al_num then
					io.put_string (l_str + " ")
					io.put_string (al_num.out + " ") io.put_new_line
				elseif attached {READABLE_INDEXABLE[ANY]} a_child.item (k) as al_ri then
					dump_readable_indexable (al_ri, l_str)
				elseif attached {TUPLE} a_child.item (k) as al_tuple then
					dump_tuple (al_tuple, l_str)
				end
				k := k + 1
			end
		ensure
			class

		end

	dump_tuple (a_child: TUPLE; a_str: STRING)
		note
			arguments: "[
					a_child			  Data sctructure to be dumped
					a_str             Work string containing a counter for each dimension
					]"
				purpose: "[
					To print to the console all the elements in the supplied data structure 'a_child'.
					This version specialized for TUPLE class.
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
		local
			k: INTEGER
			l_str: STRING
		do
			from k:= a_child.lower until k > a_child.upper loop
				l_str := a_str + " " + k.out
				if attached {STRING} a_child.item (k) as al_str then
					io.put_string (l_str + " ")
					io.put_string (al_str + " ") io.put_new_line
				elseif attached {NUMERIC} a_child.item (k) as al_num then
					io.put_string (l_str + " ")
					io.put_string (al_num.out + " ") io.put_new_line
				elseif attached {READABLE_INDEXABLE[ANY]} a_child as al_ri then
					dump_readable_indexable (al_ri, l_str)
				elseif attached {TUPLE} a_child.item (k) as al_tuple then
					dump_tuple (al_tuple, l_str)
				end
				k := k + 1
			end
		ensure
			class

		end
end
