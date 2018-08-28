note
	description: "[
		Print the elements of a given (possibly multidimensional) data structure
		This version uses an iterative depth-first algorithm for traversing
		the data structure hierarchy.
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
		The dump algorithm traverses the data structures until a
		basic type is found, when the respective element value is printed.
		The following basic types are currently implemented:
		  * STRING, INTEGER, REAL, DOUBLE, DECIMAL, DATE_TIME, DATE, and TIME
	]"
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
				dump_iterable_iterative (al_iterable, Result)
			elseif attached a_data_structure as al_data_structure then
				Result.append_string_general (al_data_structure.out)
			else
				Result.append_string_general ("Void")
			end
			Result.adjust
		end

feature {NONE} -- Implementation

	dump_iterable_iterative (a_child: ANY; a_parent_result: STRING)
			-- `dump_iterable_iterative' contents of `a_child', appending to `a_parent_result'
		local
			l_keys: ARRAY [detachable HASHABLE]
			l_key: ANY
			l_temp_stack, -- Used to correct the order of output
					-- The natural order of depth-first using a stack
					-- must be reversed in order to get the same order
					-- of the implementation using the recursive version.

				l_stack: LINKED_STACK [ANY] -- Stores data structures to be processed
			l_child: ANY -- The current data structure bein processed

				-- An array per hierarchy level with the keys used to print the elements
				-- in the respective level.
			l_keys_per_level: LINKED_LIST [ARRAY [detachable HASHABLE]]
		do
			create l_stack.make
			create l_temp_stack.make
			create l_keys_per_level.make
			create l_keys.make_empty
			from
				l_stack.put (a_child)
			until
				l_stack.is_empty
			loop
					-- Get next element to be processed
				l_child := l_stack.item
				l_stack.remove
				if l_keys_per_level.count > 0 then
					l_keys := l_keys_per_level.last
					l_key := l_keys [1]
					l_keys.remove_head (1)
					l_keys.rebase (1)
					if attached {INTEGER} l_key as al_key then
						a_parent_result.append_string_general (al_key.out)
					elseif attached {HASHABLE} l_key as al_key then
						a_parent_result.append_character ('#')
						a_parent_result.append_string_general (al_key.out)
					end
					a_parent_result.append_character (':')
				end
				if attached {STRING} l_child as al_string then
					a_parent_result.append_string_general (al_string)
					a_parent_result.append_character (',')
				elseif attached {CHARACTER} l_child as al_character then
					a_parent_result.append_string_general (al_character.out)
					a_parent_result.append_character (',')
				elseif attached {DECIMAL} l_child as al_decimal then
					a_parent_result.append_string_general (al_decimal.out)
					a_parent_result.append_character (',')
				elseif attached {NUMERIC} l_child as al_numeric then
					a_parent_result.append_string_general (al_numeric.out)
					a_parent_result.append_character (',')
				elseif attached {ABSOLUTE} l_child as al_time then
					a_parent_result.append_string_general (al_time.out)
					a_parent_result.append_character (',')
				elseif attached {ITERABLE [ANY]} l_child as al_child then
						-- Add descendants of l_child to the working stack
						-- Firstly use temp stack (used to reverse the order of elements)
					across
						al_child as ic
					from
						l_temp_stack.wipe_out
					loop
						l_temp_stack.put (ic.item)
					end
						-- then put them in the working stack with the correct order
					across
						l_temp_stack as is
					loop
						l_stack.put (is.item)
					end
						-- End adding descendants to working stack

						-- Setup keys for descendants of l_child
					if attached {HASH_TABLE [ANY, detachable HASHABLE]} al_child as al_hash_table then
						l_keys := al_hash_table.current_keys
					else
						l_keys := (1 |..| l_temp_stack.count).as_array
					end
						-- End setting up keys

					l_keys_per_level.force (l_keys) -- Add another hierarchy level
				else
					a_parent_result.append_string_general ("n/a")
					a_parent_result.append_character (',')
				end
				if l_keys_per_level.is_empty then
					if a_parent_result.count > 0 and then a_parent_result [a_parent_result.count] = ',' then
						a_parent_result.remove_tail (1)
						a_parent_result.append_character ('%N')
					end
				else
					if l_keys_per_level.last.count = 0 then
							-- If the keys in the current level have been exausted
							-- remove this level from the hierarchy.
						l_keys_per_level.finish
						l_keys_per_level.remove
						if a_parent_result.count > 0 and then a_parent_result [a_parent_result.count] = ',' then
							a_parent_result.remove_tail (1)
							a_parent_result.append_character ('%N')
						end
					end
				end
			end
		end

end
