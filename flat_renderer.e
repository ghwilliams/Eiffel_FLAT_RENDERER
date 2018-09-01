note
	description: "Summary description for {FLAT_RENDERER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_RENDERER

create
	make

feature

	make
		do
			my_str := ""
		end

	render (a_data: ANY; a_sense: BOOLEAN; a_key: HASHABLE)
		local
		do
			if a_sense = True then
				if attached {INTEGER} a_key then
				elseif attached {HASHABLE} a_data then
					my_str.append_character ('#')
				end
				my_str.append_string_general (a_key.out)
				my_str.append_character (':')
				if attached {STRING} a_data as al_string then
					my_str.append_string_general (al_string)
					my_str.append_character (',')
				elseif attached {CHARACTER} a_data as al_character then
					my_str.append_string_general (al_character.out)
					my_str.append_character (',')
				elseif attached {DECIMAL} a_data as al_decimal then
					my_str.append_string_general (al_decimal.out)
					my_str.append_character (',')
				elseif attached {NUMERIC} a_data as al_numeric then
					my_str.append_string_general (al_numeric.out)
					my_str.append_character (',')
				elseif attached {ABSOLUTE} a_data as al_time then
					my_str.append_string_general (al_time.out)
					my_str.append_character (',')
				elseif attached {ITERABLE [ANY]} a_data as al_hash then
				else
					my_str.append_string_general ("n/a")
					my_str.append_character (',')
				end
			else
				if attached {STRING} a_data as al_string then
				elseif attached {CHARACTER} a_data as al_character then
				elseif attached {DECIMAL} a_data as al_decimal then
				elseif attached {NUMERIC} a_data as al_numeric then
				elseif attached {ABSOLUTE} a_data as al_time then
				elseif attached {ITERABLE [ANY]} a_data as al_hash then
						-- If we are leaving one hierachy level
					check
						last_is_comma_or_newline: (<<',', '%N'>>).has (last_character (my_str))
					end
					if last_character (my_str) = ',' then
						my_str.remove_tail (1)
						my_str.append_character ('%N')
					end
				else
					my_str.append_string_general ("n/a")
					my_str.append_character (',')
				end
			end
		end

feature

	last_character (a_string: STRING): CHARACTER
			-- what is the `last_character' in non-empty `a_string'?
		require
			not_empty: not a_string.is_empty
		do
			Result := a_string [a_string.count]
		end

	my_str: STRING

	test_1_string: STRING = "[
			1:1:Orange,2:Banana,3:Apple,4:Melom
			2:1:Eiffel,2:Java,3:C++,4:C#
			3:1:Stepanov,2:Wirth,3:B. Meyer,4:Stroustrup
		]"

end
