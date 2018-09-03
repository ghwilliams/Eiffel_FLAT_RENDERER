note
	description: "Common routines for system."

class
	FLAT_COMMON

feature -- Common

	last_character (a_string: STRING): CHARACTER
			-- what is the `last_character' in the non-empty `a_string'?
		require
			not_empty: not a_string.is_empty
		do
			Result := a_string [a_string.count]
		ensure
			last: Result = a_string [a_string.count]
		end

end
