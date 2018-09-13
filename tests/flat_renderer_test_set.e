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

	basic_types_tests
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
			note_about_strings: "[
				You may note (in the code below) that sending in a STRING object results in a
				list of characters in the output of the `dump' call. This is because a manifest
				STRING is (in fact) ITERABLE (as a set of characters). This causes the `dump'
				routine to traverse the characters of the passed string. Otherwise, if one sends
				some other data structure, which contains item elements which are strings, those
				strings are output as expected (i.e. if you send "blah", you get "blah" and not
				the 1:b,2:l,3:a,4:h output below).
				]"
		local
			l_visitor: FLAT_VISITOR
			l_renderer: FLAT_RENDERER_CSV

		do
			create l_visitor.make
			create l_renderer

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

				-- Add action listener
			l_visitor.add_action_listener (agent l_renderer.render)

			l_renderer.reset
			l_visitor.visit("blah")
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_1_string", "blah", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(100)
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_2_integer", "100", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(create {DATE}.make (2018, 5, 15))
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_3_date", "05/15/2018", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(create {TIME}.make (10, 45, 30))
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_4_time", "10:45:30.000 AM", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(Void)
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_5_void", "Void", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(10.99)
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_6_real", "10.99", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(create {DECIMAL}.make_from_string ("21.33"))
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_7_decimal", "21.33", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit('X')
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_8_character", "X", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(True)
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_9_boolean", "True", l_renderer.rendered_result)

			l_renderer.reset
			l_visitor.visit(anything)
			l_renderer.rendered_result.adjust

			assert_strings_equal ("basic_10_any", anything_out, l_renderer.rendered_result)
		end

feature {NONE} -- Support: Basic Types

	anything: ANY
			-- An instance of {ANY} as `anything'.
		once
			create Result
		end

	anything_out: STRING
			-- Specially prepared `out' of `anything'.
		do
			Result := anything.out
			Result.adjust
		end

feature -- Tests: Big Data

	big_data_tests
			-- Tests of {FLAT_VISITOR} with a larger data set.
		note
			design: "[
				We want to test with larger data sets and range limits
				within the larger data sets.
				]"
		local
			l_visitor: FLAT_VISITOR
			l_renderer: FLAT_RENDERER_CSV
			l_rendered_result: STRING
			l_range: INTEGER_INTERVAL

		do
			create l_visitor.make
			create l_renderer

			create l_range.make (50, 60)

			create l_rendered_result.make_empty

			l_rendered_result.append_character ('[')
			l_rendered_result.append_string_general (l_range.lower.out)
			l_rendered_result.append_character (' ')
			l_rendered_result.append_character ('|')
			l_rendered_result.append_character ('.')
			l_rendered_result.append_character ('.')
			l_rendered_result.append_character ('|')
			l_rendered_result.append_character (' ')
			l_rendered_result.append_string_general (l_range.upper.out)
			l_rendered_result.append_character (']')
			l_rendered_result.append_character ('%N')

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

				-- Add action listener
			l_visitor.add_action_listener (agent l_renderer.render)
			l_visitor.visit_range(big_data_1, l_range)

			l_rendered_result.append_string (l_renderer.rendered_result)
			l_rendered_result.adjust

			assert_strings_equal ("range_1", big_data_1_string, l_rendered_result)

			l_range := 65 |..| 77

			l_rendered_result.wipe_out
			l_renderer.reset

			l_rendered_result.append_character ('[')
			l_rendered_result.append_string_general (l_range.lower.out)
			l_rendered_result.append_character (' ')
			l_rendered_result.append_character ('|')
			l_rendered_result.append_character ('.')
			l_rendered_result.append_character ('.')
			l_rendered_result.append_character ('|')
			l_rendered_result.append_character (' ')
			l_rendered_result.append_string_general (l_range.upper.out)
			l_rendered_result.append_character (']')
			l_rendered_result.append_character ('%N')

			l_visitor.visit_range(big_data_2, l_range)

			l_rendered_result.append_string (l_renderer.rendered_result)
			l_rendered_result.adjust

			assert_strings_equal ("range_2", big_data_2_string, l_rendered_result)
		end

feature {NONE} -- Support: Big Data

	big_data_1: ARRAY [ANY]
			-- Data table `big_data_1' for testing.
		local
			l_rand: RANDOMIZER
			l_list: ARRAYED_LIST [ANY]
		once
			create l_list.make (100)
			across
				1 |..| 100 as ic
			loop
				l_list.force (<<ic.item * 100, ic.item + 1, ic.item + 2, ic.item + 3, ic.item + 4, ic.item + 5>>)
			end
			Result := l_list.to_array
		end

	big_data_1_string: STRING = "[
[50 |..| 60]
50:1:5000,2:51,3:52,4:53,5:54,6:55
51:1:5100,2:52,3:53,4:54,5:55,6:56
52:1:5200,2:53,3:54,4:55,5:56,6:57
53:1:5300,2:54,3:55,4:56,5:57,6:58
54:1:5400,2:55,3:56,4:57,5:58,6:59
55:1:5500,2:56,3:57,4:58,5:59,6:60
56:1:5600,2:57,3:58,4:59,5:60,6:61
57:1:5700,2:58,3:59,4:60,5:61,6:62
58:1:5800,2:59,3:60,4:61,5:62,6:63
59:1:5900,2:60,3:61,4:62,5:63,6:64
60:1:6000,2:61,3:62,4:63,5:64,6:65
]"
--		-- `big_data_1_string' for comparison to `big_data_1' data table data.

	big_data_2: HASH_TABLE [ANY, STRING]
			-- Data table `big_data_2' for testing.
		do
			create Result.make (100)
			across
				1 |..| 100 as ic
			loop
				Result.force (<<ic.item * 100, ic.item + 1, ic.item + 2, ic.item + 3, ic.item + 4, ic.item + 5>>, (ic.item * 10_000).out)
			end
		end

	big_data_2_string: STRING = "[
[65 |..| 77]
650000:1:6500,2:66,3:67,4:68,5:69,6:70
660000:1:6600,2:67,3:68,4:69,5:70,6:71
670000:1:6700,2:68,3:69,4:70,5:71,6:72
680000:1:6800,2:69,3:70,4:71,5:72,6:73
690000:1:6900,2:70,3:71,4:72,5:73,6:74
700000:1:7000,2:71,3:72,4:73,5:74,6:75
710000:1:7100,2:72,3:73,4:74,5:75,6:76
720000:1:7200,2:73,3:74,4:75,5:76,6:77
730000:1:7300,2:74,3:75,4:76,5:77,6:78
740000:1:7400,2:75,3:76,4:77,5:78,6:79
750000:1:7500,2:76,3:77,4:78,5:79,6:80
760000:1:7600,2:77,3:78,4:79,5:80,6:81
770000:1:7700,2:78,3:79,4:80,5:81,6:82
]"
	-- `big_data_2_string' for comparison to `big_data_2' data table data.

feature -- Tests: Ad hoc

	ad_hoc_test
			-- Test of {FLAT_VISITOR} with an ad-hoc contented ARRAYED_LIST of ARRAYs-of-ANY.
		local
			l_visitor: FLAT_VISITOR
			l_rend: FLAT_RENDERER_CSV
		do
			create l_visitor.make
			create l_rend

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

				-- Add action listener
			l_visitor.add_action_listener (agent l_rend.render)
			l_visitor.visit_internal(data_1_table)
			l_rend.rendered_result.adjust

			assert_strings_equal ("data_1", data_1_string, l_rend.rendered_result)
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
			l_visitor: FLAT_VISITOR
			l_rend: FLAT_RENDERER_CSV
		do
			create l_visitor.make
			create l_rend

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

				-- Add action listener
			l_visitor.add_action_listener (agent l_rend.render)
			l_visitor.visit(test_1_table)
			l_rend.rendered_result.adjust

			assert_strings_equal ("test_1", test_1_string, l_rend.rendered_result)
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
			l_visitor: FLAT_VISITOR
			l_rend: FLAT_RENDERER_CSV		-- Renderer
		do
				-- Render table
			create l_visitor.make
			create l_rend

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

				-- Add action listener
			l_visitor.add_action_listener (agent l_rend.render)
			l_visitor.visit(test_2_table)
			l_rend.rendered_result.adjust

			assert_strings_equal ("test_2", test_2_string, l_rend.rendered_result)
		end

feature {NONE} -- Support: Test 2

	test_2_table: ARRAY [HASH_TABLE[INTEGER, STRING]]
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

feature -- Test multiple action listeners in VISIT
	test_multiple_actions_01
			-- Main test routine for multiple agents in the VISIT class
		local
			l_visitor: FLAT_VISITOR
			l_rend: FLAT_RENDERER_CSV
			l_expected: INTEGER
		do
			create l_visitor.make
			create l_rend

			l_expected := 5   -- Number of STRINGs in data_1_table

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

			l_visitor.add_action_listener (agent l_rend.render) -- Add listener for rendering
			l_visitor.add_action_listener (agent count_strings) -- Add listener for counting

			l_visitor.visit(data_1_table) -- Run visit only once

			l_rend.rendered_result.adjust

			assert_strings_equal ("data_1", data_1_string, l_rend.rendered_result)
			assert_integers_equal ("test_count_strings", l_expected, number_of_strings)
		end

	count_strings (a_data: detachable ANY; a_sense: BOOLEAN; a_key: HASHABLE; a_is_last_item: BOOLEAN)
			-- This procedure is intended to be used as an agent passed to VISITOR.add_action_listener. It will
			-- count the number of STRING types in the test data data_1_table
		do
			if attached {STRING} a_data as al_string and a_sense = True then
				number_of_strings := number_of_strings + 1
			end

		end

feature -- Test STRING count data
	number_of_strings: INTEGER
					-- Gets the result of counting the number of strings according to
					-- feature count_strings

feature -- Test multiple action listeners in VISIT
	test_user_basic_type
			-- Main test routine for multiple agents in the VISIT class
		local
			l_visitor: FLAT_VISITOR
			l_rend: FLAT_RENDERER_CSV
			l_expected: INTEGER
		do
			create l_visitor.make
			create l_rend

				-- Add basic types models to visitor
			l_visitor.add_basic_type_model (create {STRING}.make_empty)
			l_visitor.add_basic_type_model (create {INTEGER}.default_create)
			l_visitor.add_basic_type_model (create {DATE}.make_now)
			l_visitor.add_basic_type_model (create {TIME}.make_now)
			l_visitor.add_basic_type_model (create {REAL}.default_create)
			l_visitor.add_basic_type_model (create {DECIMAL}.make_one)
			l_visitor.add_basic_type_model (create {CHARACTER}.default_create)
			l_visitor.add_basic_type_model (create {BOOLEAN}.default_create)

			l_visitor.add_basic_type_model (create {MY_CLASS_A}.make_empty)

				-- Add a user basic type model

			l_visitor.add_action_listener (agent l_rend.render) -- Add listener for rendering

			l_visitor.visit(basic_type_data_1)

			l_rend.rendered_result.adjust

			assert_strings_equal ("data_1", basic_type_data_1_string, l_rend.rendered_result)
		end

	basic_type_data_1: ARRAYED_LIST [ARRAY [ANY]]
			-- `data_1_table' data structure for testing.
		once
			create Result.make (3)
			Result.force (<<create {DATE}.make (2018, 1, 2), create {DECIMAL}.make_from_string ("25.01"), "Larry", "Curly", "Moe", "Shemp", 1001, 100.99099>>)
			Result.force (<<create {MY_CLASS_A}.make (10), 1, create {MY_CLASS_A}.make (4), 3>>)
			Result.force (<<10, 20, create {TIME}.make (10, 20, 59)>>)
		end

	basic_type_data_1_string: STRING = "[
1:1:01/02/2018,2:25.01,3:Larry,4:Curly,5:Moe,6:Shemp,7:1001,8:100.99099
2:1:MY_CLASS_A: 10,2:1,3:MY_CLASS_A: 4,4:3
3:1:10,2:20,3:10:20:59.000 AM
]"
end


