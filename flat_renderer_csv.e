note
	description: "Comma Separated Values (CSV) renderer."

class
	FLAT_RENDERER_CSV

inherit
	FLAT_RENDERER

feature

	render (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; a_is_last_item: BOOLEAN)
			-- <Precursor>
		local
			l_end_mark: CHARACTER
		do
			if a_sense = first_pass then
				if attached {INTEGER} a_key then
				elseif attached {HASHABLE} a_data then
					rendered_result.append_character (hash_mark)
				end
				if a_key /= zero_hash then
					rendered_result.append_string_general (a_key.out)
					rendered_result.append_character (colon_separator_mark)
				end
				if a_is_last_item then
					l_end_mark := new_line
				else
					l_end_mark := comma
				end
				if attached {STRING} a_data as al_string then
					rendered_result.append_string_general (al_string)
					rendered_result.append_character (l_end_mark)
				elseif attached {CHARACTER} a_data as al_character then
					rendered_result.append_string_general (al_character.out)
					rendered_result.append_character (l_end_mark)
				elseif attached {DECIMAL} a_data as al_decimal then
					rendered_result.append_string_general (al_decimal.out)
					rendered_result.append_character (l_end_mark)
				elseif attached {NUMERIC} a_data as al_numeric then
					rendered_result.append_string_general (al_numeric.out)
					rendered_result.append_character (l_end_mark)
				elseif attached {ABSOLUTE} a_data as al_time then
					rendered_result.append_string_general (al_time.out)
					rendered_result.append_character (l_end_mark)
				elseif attached {BOOLEAN} a_data as al_boolean then
					rendered_result.append_string_general (al_boolean.out)
					rendered_result.append_character (l_end_mark)
				elseif attached {ITERABLE [ANY]} a_data as al_hash then
				elseif attached {ANY} a_data as al_any then
					rendered_result.append_string_general (al_any.out)
					rendered_result.append_character (l_end_mark)
				elseif attached a_data as al_data then
					rendered_result.append_string_general (not_applicable_mark)
					rendered_result.append_character (l_end_mark)
				else
					rendered_result.append_string_general (void_mark)
					rendered_result.append_character (l_end_mark)
				end
			else
				do_nothing -- `a_sense' /= `first_pass'
				-- TODO: Do we actually need to do something on second or last pass?
				--			It appears we simply ignore subsequent passes. Is this true?
			end
		end

end
