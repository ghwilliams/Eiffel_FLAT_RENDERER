note
	description: "Comma Separated Values (CSV) renderer."
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER_CSV

create
	make

feature

	make
		do
			reset
		end

	render (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; is_last: BOOLEAN)
			-- Append a text version of a_data to render_result
		note
			arguments: "[
				a_data   The data structure to be converted to a STRING
				a_sense  True - It is the first pass trough a_data
				         False - It is the second (and last) pass through a_data
				a_key    Key value associated with a_data
				is_last  True - a_data is the last child in its branch. False otherwise.
			]"
			see_also: "[
				See the {FLAT_RENDERER_TEST_SET} in the test target for more information
				and examples of this class being used.
			]"
		local
			l_end_mark: CHARACTER
		do
			if a_sense = True then
				if attached {INTEGER} a_key then
				elseif attached {HASHABLE} a_data then
					render_result.append_character ('#')
				end
				if a_key /= 0 then
					render_result.append_string_general (a_key.out)
					render_result.append_character (':')
				end
				if is_last then
					l_end_mark := '%N'
				else
					l_end_mark := ','
				end
				if attached {STRING} a_data as al_string then
					render_result.append_string_general (al_string)
					render_result.append_character (l_end_mark)
				elseif attached {CHARACTER} a_data as al_character then
					render_result.append_string_general (al_character.out)
					render_result.append_character (l_end_mark)
				elseif attached {DECIMAL} a_data as al_decimal then
					render_result.append_string_general (al_decimal.out)
					render_result.append_character (l_end_mark)
				elseif attached {NUMERIC} a_data as al_numeric then
					render_result.append_string_general (al_numeric.out)
					render_result.append_character (l_end_mark)
				elseif attached {ABSOLUTE} a_data as al_time then
					render_result.append_string_general (al_time.out)
					render_result.append_character (l_end_mark)
				elseif attached {BOOLEAN} a_data as al_boolean then
					render_result.append_string_general (al_boolean.out)
					render_result.append_character (l_end_mark)
				elseif attached {ITERABLE [ANY]} a_data as al_hash then
				elseif attached {ANY} a_data as al_any then
					render_result.append_string_general (al_any.out)
					render_result.append_character (l_end_mark)
				elseif attached a_data as al_data then
					render_result.append_string_general ("n/a")
					render_result.append_character (l_end_mark)
				else
					render_result.append_string_general ("Void")
					render_result.append_character (l_end_mark)
				end
			end
		end

	reset
			-- Clean string render_result
		do
			render_result := ""
		end

feature

	last_character (a_string: STRING): CHARACTER
			-- what is the `last_character' in non-empty `a_string'?
		require
			not_empty: not a_string.is_empty
		do
			Result := a_string [a_string.count]
		end

	render_result: STRING -- Text representing the data structure being rendered

end
