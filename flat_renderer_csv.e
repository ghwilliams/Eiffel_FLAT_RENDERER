note
	description: "Summary description for {FLAT_RENDERER_CSV}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER_CSV

create
	make

feature

	make
		do
			render_result := ""
		end

	render (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; is_last: BOOLEAN)
		local
			l_end_mark: CHARACTER
		do
			if a_data = Void then
				render_result := "Void"
			else
				if a_sense = True then
					if attached {INTEGER} a_key as al_key then
						if al_key /= 0 then
							render_result.append_string_general (a_key.out)
							render_result.append_character (':')
						end
					elseif attached {HASHABLE} a_data then
						render_result.append_character ('#')
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
					elseif attached {ITERABLE [ANY]} a_data as al_hash then
					else
						render_result.append_string_general ("n/a")
						render_result.append_character (l_end_mark)
					end
				end
			end
		end

	reset
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

	render_result: STRING

end
