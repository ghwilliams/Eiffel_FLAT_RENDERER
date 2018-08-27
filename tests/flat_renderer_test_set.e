note
	description: "[
		Testing of the FLAT_RENDERER class.
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

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test: Breaking Attempts

	breaking_attempt_tests
			-- Attempt to break it!
		note
			design: "[
				First: Send the `l_renderer' basic data types alone to see what happens.
					(in this case, it was discovered that there was not basic `out' call
					for types not conforming to ITERABLE [G]). This form of testing revealed
					a bug! It also revealed another bug when sent a STRING, where the trailing
					commas were not being handled properly.
				]"
			eis_note: "See page 147 for the list of basic types"
			EIS: "name=eiffel_ecma_spec", "src=https://www.ecma-international.org/publications/standards/Ecma-367.htm"
		local
			l_renderer: FLAT_RENDERER
		do
			create l_renderer
			assert_strings_equal ("breaking_1_string", "1:b,2:l,3:a,4:h", l_renderer.dump ("blah"))
			assert_strings_equal ("breaking_2_integer", "100", l_renderer.dump (100))
			assert_strings_equal ("breaking_3_date", "05/15/2018", l_renderer.dump (create {DATE}.make (2018, 5, 15)))
			assert_strings_equal ("breaking_4_time", "10:45:30.000 AM", l_renderer.dump (create {TIME}.make (10, 45, 30)))
			assert_strings_equal ("breaking_5_void", "Void", l_renderer.dump (Void))
			assert_strings_equal ("breaking_6_real", "10.99", l_renderer.dump (10.99))
			assert_strings_equal ("breaking_7_decimal", "[0,2133,-2]", l_renderer.dump (create {DECIMAL}.make_from_string ("21.33")))
			assert_strings_equal ("breaking_8_character", "X", l_renderer.dump ('X'))
			assert_strings_equal ("breaking_9_boolean", "True", l_renderer.dump (True))
		end

feature {NONE} -- Support: Breaking Attempts



feature -- Tests

	ad_hoc_test
			-- Test of {FLAT_RENDERER} with an ad-hoc contented ARRAYED_LIST of ARRAYs-of-ANY.
		local
			l_rend: FLAT_RENDERER
		do
			create l_rend
			assert_strings_equal ("data_1", data_1_string, l_rend.dump (data_1_table))
		end

feature {NONE} -- Support

	data_1_table: ARRAYED_LIST [ARRAY [ANY]]
			-- `data_1_table' data structure for testing.
		once
			create Result.make (3)
			Result.force (<<create {DATE}.make (2018, 1, 2), create {DECIMAL}.make_from_string ("25.01"), "Larry", "Curly", "Moe", "Shemp", 1001, 100.99099>>)
			Result.force (<<"blah_stuff", 1, 2, 3>>)
			Result.force (<<10, 20, create {TIME}.make (10, 20, 59)>>)
		end

	data_1_string: STRING = "[
1:1:01/02/2018,2:25.01,3:Larry,4:Curly,5:Moe,6:Shemp,7:1001,8:100.99099
2:1:blah_stuff,2:1,3:2,4:3
3:1:10,2:20,3:10:20:59.000 AM
]"
		-- `data_1_string' as "expected" value in `assert_strings_equal' calls.

feature -- Tests: Test 1

	test_1
			-- Test of FLAT_RENDERER for _____?
		local
			l_rend: FLAT_RENDERER
		do
			create l_rend
			assert_strings_equal ("test_1", test_1_string, l_rend.dump (test_1_table))
		end

feature {NONE} -- Support: Test 1

	test_1_table: ARRAY [ARRAY [STRING]]
			-- `test_1_table' data structure for testing.
		local
			l_list: ARRAYED_LIST [ARRAY [STRING]]
		once
			create l_list.make (3)
			l_list.force (<<"Orange", "Banana", "Apple", "Melom">>)
			l_list.force (<<"Eiffel", "Java", "C++", "C#">>)
			l_list.force (<<"Stepanov", "Wirth", "B. Meyer", "Stroustrup">>)
			Result := l_list.to_array
		end

	test_1_string: STRING = "[
1:1:Orange,2:Banana,3:Apple,4:Melom
2:1:Eiffel,2:Java,3:C++,4:C#
3:1:Stepanov,2:Wirth,3:B. Meyer,4:Stroustrup
]"
		-- `test_1_string' as "expected" value in `assert_strings_equal' calls.

feature -- Tests: Test 2

	test_2
			-- First test using a 2-dimensional data structure using HASH_TABLE
		local
			l_rend: FLAT_RENDERER					     -- Renderer
		do
			-- Render table
			create l_rend
			assert_strings_equal ("test_2", test_2_string, l_rend.dump (table_2_table))
		end

feature {NONE} -- Support: Test 2

	table_2_table: ARRAY [HASH_TABLE[INTEGER, STRING]]
			-- `table_2_table' data structure for testing.
		local
			l_list: ARRAYED_LIST [HASH_TABLE [INTEGER, STRING]]
		once
			create l_list.make (2)
			l_list.force (create {HASH_TABLE [INTEGER, STRING]}.make (4))
			l_list.force (create {HASH_TABLE [INTEGER, STRING]}.make (4))
			l_list [1].force (400, "Zurich")
			l_list [1].force (198, "Geneva")
			l_list [1].force (176, "Basel")
			l_list [1].force (146, "Lausanne")
			l_list [2].force (1894, "Balzer")
			l_list [2].force (1893, "Duryea Car")
			l_list [2].force (1889, "Daimler-Maybach Stahlradwagen")
			l_list [2].force (1884, "La Marquise")
			Result := l_list.to_array
		end

	test_2_string: STRING = "[
1:#Zurich:400,#Geneva:198,#Basel:176,#Lausanne:146
2:#Balzer:1894,#Duryea Car:1893,#Daimler-Maybach Stahlradwagen:1889,#La Marquise:1884
]"
		-- `test_2_string' as "expected" value in `assert_strings_equal' calls.

end


