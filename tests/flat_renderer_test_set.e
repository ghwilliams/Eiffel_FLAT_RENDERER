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

feature -- Test routines

	flat_renderer_ad_hoc_arrayed_list_test
			-- Test of {FLAT_RENDERER} with an ad-hoc contented ARRAYED_LIST of ARRAYs-of-ANY.
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
1:1:01/02/2018,2:25.01,3:Larry,4:Curly,5:Moe,6:Shemp,7:1001,8:100.99099
2:1:blah_stuff,2:1,3:2,4:3
3:1:10,2:20,3:10:20:59.000 AM


]"

feature -- Tests: Application

	test_1
			-- Test of FLAT_RENDERER for _____?
		local
			l_table: ARRAY [ARRAY [STRING]]            	-- Data source 2D-table
			l_row: ARRAY [STRING]                     	-- One row of data			
			l_rows_count,			                    -- Number of rows in table
			l_columns_count: INTEGER                 	-- Number of columns in table
			l_rend: FLAT_RENDERER						-- Renderer
		do
			-- Set table dimensions
			l_rows_count := 3
			l_columns_count := 4

			-- Create and fill table
			-- Start
			create l_row.make_filled ("", 1, l_columns_count)
			create l_table.make_filled (l_row, 1, l_rows_count)

			across 1 |..| l_rows_count as ic loop
				create l_row.make_filled ("", 1, l_columns_count)
				l_table.put (l_row, ic.item)
			end

			l_table[1].item(1) := "Orange";     l_table[1].item(2) := "Banana"; l_table[1].item(3) := "Apple";    l_table[1].item(4) := "Melom"
			l_table[2].item(1) := "Eiffel";     l_table[2].item(2) := "Java";   l_table[2].item(3) := "C++";      l_table[2].item(4) := "C#"
			l_table[3].item(1) := "Stepanov";   l_table[3].item(2) := "Wirth";  l_table[3].item(3) := "B. Meyer"; l_table[3].item(4) := "Stroustrup"

			-- End - Create and fill table

			-- Render table
			create l_rend
			assert_strings_equal ("test_1", test_1_string, l_rend.dump_01 (l_table))
		end

feature {NONE} -- Support

	test_1_string: STRING = "[
1:1:Orange,2:Banana,3:Apple,4:Melom
2:1:Eiffel,2:Java,3:C++,4:C#
3:1:Stepanov,2:Wirth,3:B. Meyer,4:Stroustrup


]"

end


