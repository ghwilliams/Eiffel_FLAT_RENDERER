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

	render (a_data: ANY; a_sense: BOOLEAN)
		do
			if a_sense = True then

			else
				
			end
		end

feature

	my_str: STRING

	test_1_string: STRING = "[
1:1:Orange,2:Banana,3:Apple,4:Melom
2:1:Eiffel,2:Java,3:C++,4:C#
3:1:Stepanov,2:Wirth,3:B. Meyer,4:Stroustrup
]"

end
