note
	description: "[
		Visit the elements of a given (possibly multidimensional) data structure and
		call the supplied renderer agent for every element in it.
	]"
	purpose: "[
		Present formatted text output of an arbitrary given data structure.
		This problem was posed by Bertrand Meyer on the Eiffel users forum:
		 see thread Renders, a small community project by Bertrand Meyer.
	]"
	EIS: "name=eiffel_users_forum", "src=https://groups.google.com/forum/#!topic/eiffel-users/N9fLnpNvrOw"
	how: "[
		This class supplies a routine to `visit' all elements in
		a given data sctructure conforming to very specific abstract base classes.
		
		The following abstract classes (and descendants) are currently supported:
		  * ITERABLE [G]
		
		The `visit' algorithm traverses the data structures recursively until a
		basic type is found, and then a user supplied agent is called
		with the respective element for rendering.
	]"
	basic_data_types: "[
		The following basic types are currently implemented:
		  * STRING, INTEGER, REAL, DOUBLE, DECIMAL, DATE_TIME, DATE, BOOLEAN, and TIME
	]"

class
	FLAT_VISITOR

inherit
	FLAT_CONSTANTS

	FLAT_COMMON

feature {ANY} -- exported visit procedures

	visit (a_data_structure: detachable ANY; a_action: PROCEDURE [TUPLE [data_structure: detachable ANY; sense: BOOLEAN; key: HASHABLE; is_last_item: BOOLEAN]])
			-- Recursively `visit' the contents of `a_data_structure' applying `a_action' to each.
		note
			arguments: "[
				a_data_structure:	Data sctructure to be visited
				a_action:			The agent responsible for doing an action for
				                  	 every element of a_data_structure
			]"
			purpose: "[
				To get a formatted text output of the elements of `a_data_structure' in
				some form such as CSV, JSON, HTML <table>, YAML, and others.
				]"
			how: "[
				Recursively traverse `a_data_structure', calling `a_action' for each
				of its children if it is one of the basic data types. The `a_action'
				agent will determine the format of the output. This routine is only 
				responsible for walking `a_data_structure'.
			]"
		local
			l_key: HASHABLE
		do
			l_key := 0
			if
				attached {STRING} a_data_structure or
					attached {CHARACTER} a_data_structure or
					attached {DECIMAL} a_data_structure or
					attached {NUMERIC} a_data_structure or
					attached {ABSOLUTE} a_data_structure or
					attached {BOOLEAN} a_data_structure
			then
				a_action (a_data_structure, first_pass, l_key, is_last_item)
			elseif attached {ITERABLE [ANY]} a_data_structure as al_iterable then
				visit_internal (al_iterable, a_action)
			else
				a_action (a_data_structure, first_pass, l_key, is_last_item)
			end
		end

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

	visit_internal (a_child: ITERABLE [ANY]; a_action: PROCEDURE [TUPLE [data_structure: detachable ANY; sense: BOOLEAN; key: HASHABLE; is_last_item: BOOLEAN]])
			-- Visits recursively `a_child' and calls `a_action' for each one of its children
		note
			see_also: "[
				See the {FLAT_RENDERER_TEST_SET} in the test target for more information
				and examples of this class being used.
			]"
		local
			l_keys: detachable ARRAY [detachable HASHABLE]
			l_key: HASHABLE
			i: INTEGER
			l_is_last: BOOLEAN
			l_ic: ITERATION_CURSOR [ANY]
		do
			l_is_last := False
			across
				a_child as ic
			from
				i := 1
			invariant
				postive_non_zero: i >= 1
			loop
				if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_child as al_hash_table then
					l_keys := al_hash_table.current_keys
				end
				if attached l_keys and then attached {HASHABLE} l_keys [i] as al_key then
					l_key := al_key
				else
					l_key := i
				end
				l_ic := ic.twin
				l_ic.forth
				if l_ic.after then
					l_is_last := True
				end
				a_action (ic.item, True, l_key, l_is_last)
				if attached {STRING} ic.item as al_str then
				elseif attached {ITERABLE [ANY]} ic.item as al_iterable then
					visit_internal (al_iterable, a_action)
				end
				a_action (ic.item, False, l_key, l_is_last)
				i := i + 1
			end
		end

end
