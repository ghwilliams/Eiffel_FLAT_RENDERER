note
	description: "Class for testing user defined basic types."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_CLASS_A

inherit
	ANY
		redefine
			out
		end
create
	make,
	make_empty

feature

	make (a_size: INTEGER)
		do
			create my_data.make_filled ("A string", 1, a_size)
		end

	make_empty
		do
			create my_data.make_empty
		end

	out: STRING
		do
			Result := "MY_CLASS_A: " + my_data.count.out
		end

feature

	my_data: ARRAY [STRING]

end
