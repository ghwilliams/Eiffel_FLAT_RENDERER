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
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_VISITOR

create
	make

feature

	make
		do
		end

feature {ANY} -- exported dump procedures


--	dump_range (a_data_structure: ITERABLE [ANY]; a_range: INTEGER_INTERVAL): STRING
--			-- `dump_range' of `a_data_structure' over `a_range' of top items.
--		note
--			design: "[
--				From time-to-time, we may have big data in `a_data_structure' and we do not
--				want to output every element, but just a portion in `a_range'. Perhaps
--				we have 10,000 elements in our top end {ITERABLE} thing, and we only
--				want to see elements 8,000 to 8,010? This feature allows us to output
--				just the `a_range' needed for whatever our purpose is.
--			]"
--		require
--			in_range: (attached {READABLE_INDEXABLE [ANY]} a_data_structure as al_readable_indexable implies a_range.upper <= al_readable_indexable.upper and then a_range.lower >= al_readable_indexable.lower) or else (attached {ARGUMENTS} a_data_structure as al_arguments implies a_range.upper <= al_arguments.argument_count and then a_range.lower >= 1) or else (attached {ARGUMENTS_32} a_data_structure as al_arguments_32 implies a_range.upper <= al_arguments_32.argument_count and then a_range.lower >= 1)
--		local
--			i: INTEGER
--			l_line: STRING
--		do
--			create Result.make_empty
--			Result.append_character ('[')
--			Result.append_string_general (a_range.lower.out)
--			Result.append_character (' ')
--			Result.append_character ('|')
--			Result.append_character ('.')
--			Result.append_character ('.')
--			Result.append_character ('|')
--			Result.append_character (' ')
--			Result.append_string_general (a_range.upper.out)
--			Result.append_character (']')
--			Result.append_character ('%N')
--			if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_data_structure as al_hash_table then
--				al_hash_table.start
--			end
--			across
--				a_data_structure as ic
--			from
--				i := 1
--			until
--				i > a_range.upper
--			loop
--				if i >= a_range.lower and then attached {ITERABLE [ANY]} ic.item as al_iterable then
--					create l_line.make_empty
--					dump_internal (al_iterable)
--					l_line.prepend_character (':')
--					if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_data_structure as al_hash_table and then attached al_hash_table.current_keys [i] as al_key then
--						l_line.prepend_string_general (al_key.out)
--					else
--						l_line.prepend_string_general (i.out)
--					end
--					Result.append_string_general (l_line)
--				end
--				i := i + 1
--			end
--		end

feature -- Implementation

	visit_internal (a_child: ITERABLE [ANY]; a_action: PROCEDURE [TUPLE [ANY, BOOLEAN]])
			-- `dump_internal' version of `dump' contents of `a_child', appending to `a_parent_result'
		note
			see_also: "[
				See the {FLAT_RENDERER_TEST_SET} in the test target for more information
				and examples of this class being used.
			]"
		local
			i: INTEGER
		do
			across
				a_child as ic
			from
				i := 1
			invariant
				postive_non_zero: i >= 1
			loop
				a_action(ic.item, True) --call_agent(ic.item, True)
				if attached {STRING} ic.item as al_str then
				elseif attached {ITERABLE [ANY]} ic.item as al_iterable then
					visit_internal (al_iterable, a_action)
				end
				a_action(ic.item, False)--call_agent(ic.item, False)
				i := i + 1
			end
		end

	last_character (a_string: STRING): CHARACTER
			-- what is the `last_character' in non-empty `a_string'?
		require
			not_empty: not a_string.is_empty
		do
			Result := a_string [a_string.count]
		end

feature -- Agents

--	set_agent (on_stop: PROCEDURE [TUPLE [ANY, BOOLEAN]])
--		do
--			my_agents := on_stop
--		end

	call_agent (a_element: ANY; a_sens: BOOLEAN)
			--
		local
			l_op: TUPLE [ANY]
		do
			if attached {PROCEDURE [TUPLE [ANY, BOOLEAN]]} my_agent as al_p then
				al_p.call (a_element, a_sens)
			end
		end

feature {NONE}

	my_agent: detachable PROCEDURE [TUPLE [ANY, BOOLEAN]]

end
