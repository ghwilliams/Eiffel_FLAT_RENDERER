note
	description: "A set of Constants"

class
	FLAT_CONSTANTS

feature -- Misc Constants

	zero_hash: HASHABLE
			-- The `zero_hash' value.
		once
			Result := 0
		end

feature -- Character Constants

	new_line: CHARACTER = '%N'
			-- The `new_line' character.

	comma: CHARACTER = ','
			-- The `comma' character.

	hash_mark: CHARACTER = '#'
			-- The `hash_mark' character.

	colon_separator_mark: CHARACTER = ':'
			-- The `colon_separator_mark' character.

feature -- String Constants

	not_applicable_mark: STRING = "n/a"
			-- The `not_applicable_mark'.

	void_mark: STRING = "Void"
			-- The `void_mark'.

feature -- Rendering Agent Call Constants
		-- For example: See {FLAT_RENDERER_CSV}.render

	first_pass: BOOLEAN
			-- This is `first_pass' through data structure items.
		note
			description: "[
				This is an answer to the question: Is this the `first_pass' through a
				data structure of items? So, it is not presented as the question itself,
				but as the answer to the question and coded as a constant (once in this case).
				]"
		once
			Result := True
		end

	second_or_last_pass: BOOLEAN = False
			-- This is the `second_or_last_pass' through data structure items.

	is_last_item: BOOLEAN = True
			-- This agent call `is_last_item' in data structure items.

end
