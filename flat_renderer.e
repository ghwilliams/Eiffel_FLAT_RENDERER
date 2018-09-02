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

	render (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; is_last: BOOLEAN)
		local
			l_end_mark: CHARACTER
		do
			if a_data = Void then
				my_str := "Void"
			else
				if a_sense = True then
					if attached {INTEGER} a_key as al_key then
						if al_key /= 0 then
							my_str.append_string_general (a_key.out)
							my_str.append_character (':')
						end
					elseif attached {HASHABLE} a_data then
						my_str.append_character ('#')
						my_str.append_string_general (a_key.out)
						my_str.append_character (':')
					end
					if is_last then
						l_end_mark := '%N'
					else
						l_end_mark := ','
					end
					if attached {STRING} a_data as al_string then
						my_str.append_string_general (al_string)
						my_str.append_character (l_end_mark)
					elseif attached {CHARACTER} a_data as al_character then
						my_str.append_string_general (al_character.out)
						my_str.append_character (l_end_mark)
					elseif attached {DECIMAL} a_data as al_decimal then
						my_str.append_string_general (al_decimal.out)
						my_str.append_character (l_end_mark)
					elseif attached {NUMERIC} a_data as al_numeric then
						my_str.append_string_general (al_numeric.out)
						my_str.append_character (l_end_mark)
					elseif attached {ABSOLUTE} a_data as al_time then
						my_str.append_string_general (al_time.out)
						my_str.append_character (l_end_mark)
					elseif attached {ITERABLE [ANY]} a_data as al_hash then
					else
						my_str.append_string_general ("n/a")
						my_str.append_character (l_end_mark)
					end
				end
			end
		end

	reset
		do
			my_str := ""
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
