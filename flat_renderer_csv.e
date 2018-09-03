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
			if a_sense = is_the_first_pass then
					-- a_data was reached for the first time during data traversal
				if attached {INTEGER} a_key then
					-- Must be here to avoid puting the hash mark # for integer keys
				elseif attached {HASHABLE} a_data then
					rendered_result.append_character (hash_mark)
				end
				if a_key /= zero_hash then
						-- The value zero_hash is only assigned by {VISITOR}.visit
						-- for the first node in the data structure being traversed.
						-- In this case we will not append any adornment character to it.
						-- This will give the correct behavior when a single basic type
						-- is passed as an argument for {VISITOR}.visit
					rendered_result.append_string_general (a_key.out)
					rendered_result.append_character (colon_separator_mark)
				end
				if a_is_last_item then
						-- If this is the last child of a given data element
						-- add a new line character.
					l_end_mark := new_line
				else
						-- add a comma otherwise
					l_end_mark := comma
				end
					-- Processing of basic data types
					-- Start
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
					-- End - Processing of basic data types
			else
				do_nothing -- `a_sense' /= `is_the_first_pass'
				-- TODO: Do we actually need to do something on second or last pass?
				--			It appears we simply ignore subsequent passes. Is this true?
				--				
				-- Williams (Answer to the question above)
				-- Short answer is: Yes. In this routine we are not making any
				-- use of this subsequent pass.
				-- But, the recursive nature of the {VISITOR}.visit routine
				-- gives us the opportunity to take two different
				-- actions for each data element:
				-- Look at the code fragment below taken from {VISITOR}.visit:
				--
				--    1.   a_action (ic.item, is_the_first_pass, l_key, l_is_last)
				--    2.   if attached {STRING} ic.item as al_str then
				--    3.   elseif attached {ITERABLE [ANY]} ic.item as al_iterable then
				--    4.       visit_internal (al_iterable, a_action)
				--    5.   end
				--    6.   a_action (ic.item, is_the_second_or_last_pass, l_key, l_is_last)
				--
				-- In Line 1 a_sense = is_the_first_pass  indicating that we have first
				-- passed through the current data element
				-- In Line 4 we process children elements if any
				-- And, in Line 6 a_sense = is_the_second_or_last_pass meaning
				-- that we are about to leave this element during the data traversal. So,
				-- we have a second opportunity to do something interesting for this element.
				-- Maybe is_the_first_pass and is_the_second_or_last_pass could be renamed
				-- to is_entering and is_exiting respectively.
			end
		end

end
