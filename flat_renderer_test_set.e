note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	FLAT_RENDERER_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

feature -- Test routines

	creation_test
			-- New test routine
		local
			l_rend: FLAT_RENDERER
			l_data: ARRAYED_LIST [ARRAY [ANY]]
		do
			create l_rend
			create l_data.make (3)
			l_data.force (<<create {DATE}.make (2018, 1, 2), create {DECIMAL}.make_from_string ("25.01"), "Larry", "Curly", "Moe", "Shemp", 1001, 100.99099>>)
			l_data.force (<<"blah_stuff", 1, 2, 3>>)
			l_data.force (<<10, 20, create {TIME}.make (10, 20, 59)>>)

			assert_strings_equal ("data_1", data_1_string, l_rend.dump_01 (l_data))
		end

feature {NONE} -- Support

	data_1_string: STRING = "[
1:1:01/02/20182:[0,2501,-2]3:Larry4:Curly5:Moe6:Shemp7:10018:100.99099
2:1:blah_stuff2:13:24:3
3:1:102:203:10:20:59.000 AM

]"

end


