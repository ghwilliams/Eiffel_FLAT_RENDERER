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

	FLAT_COMMON

create
	make

feature -- Construction

	make
		do
			create action_listeners.make
			create basic_types.make
		end

feature {ANY} -- exported visit procedures

	visit (a_data_structure: detachable ANY)
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
			l_data_is_a_basic_type: BOOLEAN
		do
			l_key := 0
			l_data_is_a_basic_type := False
			if attached a_data_structure then
				across basic_types as ic_bt loop
					if ic_bt.item.same_type (a_data_structure) then
						l_data_is_a_basic_type := True
					end
				end
			end
			if l_data_is_a_basic_type then
				across action_listeners as ic_action loop
					ic_action.item (a_data_structure, const.is_the_first_pass, l_key, const.is_the_last_item)
				end
			elseif attached {ITERABLE [ANY]} a_data_structure as al_iterable then
				visit_internal (al_iterable)
			else
				across action_listeners as ic_action loop
					ic_action.item (a_data_structure, const.is_the_first_pass, l_key, const.is_the_last_item)
				end
			end
		end

	visit_range (a_data_structure: detachable ANY; a_range: INTEGER_INTERVAL)
	    note
	    	design: "[
				From time-to-time, we may have big data in `a_data_structure' and we do not
				want to output every element, but just a portion in `a_range'. Perhaps
				we have 10,000 elements in our top end {ITERABLE} thing, and we only
				want to see elements 8,000 to 8,010? This feature allows us to output
				just the `a_range' needed for whatever our purpose is.
				]"
		require
			in_range: (attached {READABLE_INDEXABLE [ANY]} a_data_structure as al_readable_indexable implies
							a_range.upper <= al_readable_indexable.upper and then a_range.lower >= al_readable_indexable.lower)
					or else
						(attached {ARGUMENTS} a_data_structure as al_arguments implies
							a_range.upper <= al_arguments.argument_count and then a_range.lower >= 1)
					or else
						(attached {ARGUMENTS_32} a_data_structure as al_arguments_32 implies
							a_range.upper <= al_arguments_32.argument_count and then a_range.lower >= 1)

	    local
			l_key: HASHABLE
			i: INTEGER
			l_data_is_a_basic_type: BOOLEAN
		do
			l_key := 0
			l_data_is_a_basic_type := False
			if attached a_data_structure then
				across basic_types as ic_bt loop
					if ic_bt.item.same_type (a_data_structure) then
						l_data_is_a_basic_type := True
					end
				end
			end
			if l_data_is_a_basic_type then
				across action_listeners as ic_action loop
					ic_action.item (a_data_structure, const.is_the_first_pass, l_key, const.is_the_last_item)
				end
			elseif attached {ITERABLE [ANY]} a_data_structure as al_iterable then
				across
					al_iterable as ic
				from i := 1
				until
					i > a_range.upper
				loop
					if i >= a_range.lower and then attached {ITERABLE [ANY]} ic.item as al_item_iterable then
						if attached {HASH_TABLE [ANY, detachable HASHABLE]} a_data_structure as al_hash_table
							and then attached al_hash_table.current_keys [i] as al_key then
							l_key := al_key
						else
							l_key := i
						end
						across action_listeners as ic_action loop
							ic_action.item (al_item_iterable, const.is_the_first_pass, l_key, not const.is_the_last_item)
						end
						visit_internal (al_item_iterable)
					end
					i := i + 1
				end
			else
				across action_listeners as ic_action loop
					ic_action.item (a_data_structure, const.is_the_first_pass, l_key, const.is_the_last_item)
				end
			end

		end

feature -- Implementation

	visit_internal (a_child: ITERABLE [ANY])
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
				across action_listeners as ic_action loop
					ic_action.item (ic.item, const.is_the_first_pass, l_key, l_is_last)
				end
				if attached {STRING} ic.item as al_str then
				elseif attached {ITERABLE [ANY]} ic.item as al_iterable then
					visit_internal (al_iterable)
				end
				across action_listeners as ic_action loop
					ic_action.item (ic.item, const.is_the_second_or_last_pass, l_key, l_is_last)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation: Constants

	const: FLAT_CONSTANTS
			-- Constants access
		once
			create Result
		end

feature -- Action listeners exported

	add_action_listener (a_action: PROCEDURE [TUPLE [data_structure: detachable ANY;
													sense: BOOLEAN;
													key: HASHABLE;
													is_last_item: BOOLEAN]])
			-- Add another action to the list of action listeners
		do
			action_listeners.extend (a_action)
		end

feature {FLAT_VISITOR} -- Action listeners internals

	action_listeners: LINKED_LIST [PROCEDURE [TUPLE [data_structure: detachable ANY;
													sense: BOOLEAN;
													key: HASHABLE;
													is_last_item: BOOLEAN]]]

feature -- Basic types

	add_basic_type_model (a_model: ANY)
			-- Add a new type model
		do
			basic_types.extend (a_model)
		end

	basic_types: LINKED_LIST [ANY]
end
