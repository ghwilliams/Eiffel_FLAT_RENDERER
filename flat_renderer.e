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
	EIS: "name=eiffel_users_forum", "src=https://groups.google.com/forum/#!topic/eiffel-users/N9fLnpNvrOw"
	how: "[
		This class supplies procedures for dumping data sctructures conforming
		to very specific abstract base classes.
		The following abstract classes are currently supported:
		  * ITERABLE [G]
		The dump algorithm traverses the data structures recursively until a
		basic type is found, and then the element value is printed.
		The following basic types are currently implemented:
		  * STRING, INTEGER, REAL, DOUBLE, DECIMAL, DATE_TIME, DATE, and TIME
		]"
	author: "Williams Lima"
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER

feature {ANY} -- exported dump procedures

	dump (a_data_structure: detachable ANY): STRING
			-- `dump' contents of `a_data_structure' to a more human-readable string format.
		note
			arguments: "[
						a_data_structure  Data sctructure to be dumped
						]"
			purpose: "[
						This routine is an iterface to the internal routine render_01.
			         ]"
		do
			create Result.make_empty
			if attached {ITERABLE [ANY]} a_data_structure as al_iterable then
				dump_iterable (al_iterable, Result)
			elseif attached a_data_structure as al_data_structure then
				Result.append_string_general (al_data_structure.out)
			else
				Result.append_string_general ("Void")
			end
			Result.adjust
		end

feature {NONE} -- Implementation

	dump_iterable (a_child: ITERABLE [ANY]; a_parent_result: STRING)
			-- `dump_iterable' contents of `a_child', appending to `a_parent_result'
		note
			see_also: "[
				See the {FLAT_RENDERER_TEST_SET} in the test target for more information
				and examples of this class being used.
				]"
		local
			l_keys: ARRAY [detachable HASHABLE]
			i: INTEGER
		do
			if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_child as al_hash_table then
				l_keys := al_hash_table.current_keys
			end
			across
				a_child as ic
			from
				i := 1
			loop
				if attached l_keys and then attached {HASHABLE} l_keys [i] as al_key then
					a_parent_result.append_character ('#')
					a_parent_result.append_string_general (al_key.out)
				else
					a_parent_result.append_string_general (i.out)
				end
				a_parent_result.append_character (':')
				if attached {STRING} ic.item as al_string then
					a_parent_result.append_string_general (al_string)
					a_parent_result.append_character (',')
				elseif attached {CHARACTER} ic.item as al_character then
					a_parent_result.append_string_general (al_character.out)
					a_parent_result.append_character (',')
				elseif attached {DECIMAL} ic.item as al_decimal then
					a_parent_result.append_string_general (al_decimal.out)
					a_parent_result.append_character (',')
				elseif attached {NUMERIC} ic.item as al_numeric then
					a_parent_result.append_string_general (al_numeric.out)
					a_parent_result.append_character (',')
				elseif attached {ABSOLUTE} ic.item as al_time then
					a_parent_result.append_string_general (al_time.out)
					a_parent_result.append_character (',')
				elseif attached {ITERABLE [ANY]} ic.item as al_iterable then
					dump_iterable (al_iterable, a_parent_result)
				else
					a_parent_result.append_string_general ("n/a")
					a_parent_result.append_character (',')
				end
				i := i + 1
			end
			if a_parent_result [a_parent_result.count] = ',' then
				a_parent_result.remove_tail (1)
				a_parent_result.append_character ('%N')
			end
		end

end
