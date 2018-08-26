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

	dump_01 (a_data_structure: ANY): STRING
		note
			arguments: "[
						a_data_structure  Data sctructure to be dumped
						]"
			purpose: "[
						This routine is an iterface to the internal routine render_01.
			         ]"

		local

		do
			create Result.make_empty
			if attached {READABLE_INDEXABLE[ANY]} a_data_structure as al_ri then
				Result := dump_readable_indexable (al_ri, "")
			end
		end

feature {NONE} -- Private auxiliary routines

	dump_readable_indexable (a_child: READABLE_INDEXABLE[detachable separate ANY]; a_parent_result: STRING): STRING
			-- Output content of `a_child' and append to `a_parent_result'.
		local
			l_keys: ARRAY [detachable HASHABLE]
			k: INTEGER
			l_result: STRING
		do
			create l_result.make_empty
			if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_child as al_ht then
				l_keys := al_ht.current_keys
			end
			from k := a_child.lower until k > a_child.upper loop
				if attached l_keys and then attached {HASHABLE} l_keys [k + 1] as al_key then
					l_result.append_character ('#')
					l_result.append_string_general (al_key.out)
				else
					l_result.append_string_general (k.out)
				end
				l_result.append_character (':')
				if attached {STRING} a_child.item (k) as al_string then
					l_result.append_string_general (al_string)
				elseif attached {READABLE_INDEXABLE [detachable separate ANY]} a_child.item (k) as al_ri then
					l_result.append_string_general (dump_readable_indexable (al_ri, l_result))
					l_result.remove_tail (1)
				elseif attached {NUMERIC} a_child.item (k) as al_numeric then
					l_result.append_string_general (al_numeric.out)
				elseif attached {DECIMAL} a_child.item (k) as al_decimal then
					l_result.append_string_general (al_decimal.out)
				elseif attached {ABSOLUTE} a_child.item (k) as al_time then
					l_result.append_string_general (al_time.out)
				else
					l_result.append_string_general ("n/a")
				end
				l_result.adjust
				l_result.append_character (',')
				k := k + 1
			end
			l_result.adjust
			Result := l_result
			if Result [Result.count] = ',' then
				Result.remove_tail (1)
			end
			Result.append_character ('%N')
		end

end
