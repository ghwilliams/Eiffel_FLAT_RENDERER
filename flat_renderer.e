note
	description: "Abstract notion of a {FLAT_RENDERER}"

deferred class
	FLAT_RENDERER


inherit
	ANY
		redefine
			default_create
		end

	FLAT_CONSTANTS
		undefine
			default_create
		end

	FLAT_COMMON
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
			-- Additionally, `reset' `rendered_result'.
		do
			Precursor
			reset
		end

feature -- Output

	render (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; a_is_last: BOOLEAN)
			-- Append a text version of `a_data' to `render_result'.
		note
			arguments: "[
				a_data:		The data structure to be converted to a STRING
				a_sense:	True - It is the first pass trough a_data
				         	False - It is the second (and last) pass through a_data
				a_key:		Key value associated with a_data
				is_last:	True - a_data is the last child in its branch. False otherwise.
			]"
			see_also: "[
				See the {FLAT_RENDERER_TEST_SET} in the test target for more information
				and examples of this class being used.
			]"
		deferred
		end

feature --

	reset
			-- Clean string `render_result'.
		do
			create rendered_result.make_empty
		end

feature -- Access

	rendered_result: STRING
			-- The `rendered_result' of a data structure given to `render'.

end
