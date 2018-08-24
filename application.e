note
	description: "[
		This is the main class for the execution of tests
		of the class FLAT_RENDERER.
	]"
	author: "Williams Lima"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature  -- creation

	make
		do
			-- Select a test to execute
			run_test_5
		end

	run_test_0
			-- First test using a 2-dimensional data structure
		local
			table: ARRAY[ARRAY[STRING]]            -- Data source 2D-table
			row: ARRAY[STRING]                     -- One row of data			
			rows_count: INTEGER                    -- Number of rows in table
			columns_count: INTEGER                 -- Number of columns in table
		do
			-- Set table dimensions
			rows_count := 3
			columns_count := 4

			-- Create and fill table
			-- Start
			create row.make_filled ("", 1, columns_count)
			create table.make_filled (row, 1, rows_count)

			across 1 |..| rows_count as ic loop
				create row.make_filled ("", 1, columns_count)
				table.put (row, ic.item)
			end

			table[1].item(1) := "Orange";     table[1].item(2) := "Banana"; table[1].item(3) := "Apple"; table[1].item(4) := "Melom"
			table[2].item(1) := "Eiffel";     table[2].item(2) := "Java";   table[2].item(3) := "C++";   table[2].item(4) := "C#"
			table[3].item(1) := "Stepanov";   table[3].item(2) := "Wirth";  table[3].item(3) := "B. Meyer"; table[3].item(4) := "Stroustrup"

			-- End - Create and fill table

			-- Render table
			{FLAT_RENDERER}.dump_01 (table)

		end

	run_test_1
			-- Test using a 3-dimensional data structure of STRINGs
		local
			block: ARRAY[ARRAY[ARRAY[STRING]]] -- Data source 3D
			page: ARRAY[ARRAY[STRING]]         -- One page
			row: ARRAY[STRING]                 -- One row		

			rows_count: INTEGER
			columns_count: INTEGER
			pages_count: INTEGER           -- Number of items per dimension						
		do
			-- Set dimensions			

			columns_count := 3
			rows_count    := 2
			pages_count   := 3

			-- Create and fill data structure
			-- Start
			create row.make_filled ("", 1, columns_count)
			create page.make_filled (row, 1, rows_count)
			create block.make_filled (page, 1, pages_count)

			across 1 |..| pages_count as ipage loop
				create page.make_filled (row, 1, rows_count)
				across 1 |..| rows_count as irow loop
					create row.make_filled ("", 1, columns_count)
					page.put (row, irow.item)
				end
				block.put (page, ipage.item)
			end

			block[1].item(1).item (1) := "Orange111";  block[1].item(1).item(2) := "Banana112"; block[1].item(1).item(3) := "Apple113";
			block[1].item(2).item (1) := "Orange121";  block[1].item(2).item(2) := "Banana122"; block[1].item(2).item(3) := "Apple123";

			block[2].item(1).item (1) := "Orange211";  block[2].item(1).item(2) := "Banana212"; block[2].item(1).item(3) := "Apple213";
			block[2].item(2).item (1) := "Orange221";  block[2].item(2).item(2) := "Banana222"; block[2].item(2).item(3) := "Apple223";

			block[3].item(1).item (1) := "Orange311";  block[3].item(1).item(2) := "Banana312"; block[3].item(1).item(3) := "Apple313";
			block[3].item(2).item (1) := "Orange321";  block[3].item(2).item(2) := "Banana322"; block[3].item(2).item(3) := "Apple323";

			-- End - Create and fill table	

			-- Render table
			{FLAT_RENDERER}.dump_01 (block)

		end

	run_test_2
			-- Test using a 3-dimensional data structure of DOUBLEs
		local
			block: ARRAY[ARRAY[ARRAY[DOUBLE]]] -- Data source 3D
			page: ARRAY[ARRAY[DOUBLE]]         -- One page
			row: ARRAY[DOUBLE]                 -- One row		

			rows_count: INTEGER
			columns_count: INTEGER
			pages_count: INTEGER           -- Number of items per dimension						
		do
			-- Set dimensions			

			columns_count := 3
			rows_count    := 2
			pages_count   := 3

			-- Create and fill data structure
			-- Start
			create row.make_filled (0.0, 1, columns_count)
			create page.make_filled (row, 1, rows_count)
			create block.make_filled (page, 1, pages_count)

			across 1 |..| pages_count as ipage loop
				create page.make_filled (row, 1, rows_count)
				across 1 |..| rows_count as irow loop
					create row.make_filled (0.0, 1, columns_count)
					page.put (row, irow.item)
				end
				block.put (page, ipage.item)
			end

			block[1].item(1).item (1) := 1.11;  block[1].item(1).item(2) := 1.12; block[1].item(1).item(3) := 1.13;
			block[1].item(2).item (1) := 1.21;  block[1].item(2).item(2) := 1.22; block[1].item(2).item(3) := 1.23;

			block[2].item(1).item (1) := 2.11;  block[2].item(1).item(2) := 2.12; block[2].item(1).item(3) := 2.13;
			block[2].item(2).item (1) := 2.21;  block[2].item(2).item(2) := 2.22; block[2].item(2).item(3) := 2.23;

			block[3].item(1).item (1) := 3.11;  block[3].item(1).item(2) := 3.12; block[3].item(1).item(3) := 3.13;
			block[3].item(2).item (1) := 3.21;  block[3].item(2).item(2) := 3.22; block[3].item(2).item(3) := 3.23;

			-- End - Create and fill table		

			-- Render table
			{FLAT_RENDERER}.dump_01 (block)

		end

	run_test_3
			-- Uses 2-dimensional data structure using ARRA2[STRING]
		local
			table: ARRAY2[STRING]                  -- Data source 2D-table
			row: ARRAY[STRING]                     -- One row of data			
			rows_count: INTEGER                    -- Number of rows in table
			columns_count: INTEGER                 -- Number of columns in table
		do
			-- Set table dimensions
			rows_count := 3
			columns_count := 4

			-- Create and fill table
			-- Start
			create row.make_filled ("", 1, columns_count)
			create table.make_filled ("", rows_count, columns_count)

			table.item(1,1) := "Orange";     table.item(1,2) := "Banana"; table.item(1,3) := "Apple"; table.item(1,4) := "Melom"
			table.item(2,1) := "Eiffel";     table.item(2,2) := "Java";   table.item(2,3) := "C++";   table.item(2,4) := "C#"
			table.item(3,1) := "Stepanov";   table.item(3,2) := "Wirth";  table.item(3,3) := "B. Meyer"; table.item(3,4) := "Stroustrup"

			-- End - Create and fill table			

			-- Render table
			{FLAT_RENDERER}.dump_01 (table)

		end

	run_test_4
			-- Test using a 3-dimensional data structure of DOUBLEs
		local
			block: ARRAY[LINKED_LIST[ARRAY[DOUBLE]]] -- Data source 3D
			page: LINKED_LIST[ARRAY[DOUBLE]]         -- One page
			row: ARRAY[DOUBLE]                       -- One row		

			rows_count: INTEGER
			columns_count: INTEGER
			pages_count: INTEGER           -- Number of items per dimension						
		do
			-- Set dimensions			

			columns_count := 3
			rows_count    := 2
			pages_count   := 3

			-- Create and fill data structure
			-- Start
			create row.make_filled (0.0, 1, columns_count)
			create page.make
			create block.make_filled (page, 1, pages_count)

			across 1 |..| pages_count as ipage loop
				create page.make
				across 1 |..| rows_count as irow loop
					create row.make_filled (0.0, 1, columns_count)
					page.force (row)
				end
				block.put (page, ipage.item)
			end

			block[1].i_th(1).item (1) := 1.11;  block[1].i_th(1).item(2) := 1.12; block[1].i_th(1).item(3) := 1.13;
			block[1].i_th(2).item (1) := 1.21;  block[1].i_th(2).item(2) := 1.22; block[1].i_th(2).item(3) := 1.23;

			block[2].i_th(1).item (1) := 2.11;  block[2].i_th(1).item(2) := 2.12; block[2].i_th(1).item(3) := 2.13;
			block[2].i_th(2).item (1) := 2.21;  block[2].i_th(2).item(2) := 2.22; block[2].i_th(2).item(3) := 2.23;

			block[3].i_th(1).item (1) := 3.11;  block[3].i_th(1).item(2) := 3.12; block[3].i_th(1).item(3) := 3.13;
			block[3].i_th(2).item (1) := 3.21;  block[3].i_th(2).item(2) := 3.22; block[3].i_th(2).item(3) := 3.23;

			-- End - Create and fill table

			-- Render table
			{FLAT_RENDERER}.dump_01 (block)

		end

	run_test_5
			-- First test using a 2-dimensional data structure using HASH_TABLE
		local
			table: ARRAY[HASH_TABLE[INTEGER, STRING]]  -- Data source 2D-table
			row: HASH_TABLE[INTEGER, STRING]           -- One row of data			
			rows_count: INTEGER                       -- Number of rows in table
			columns_count: INTEGER                    -- Number of columns in table
		do
			-- Set table dimensions
			rows_count := 2
			columns_count := 4

			-- Create and fill table
			-- Start
			create row.make (columns_count)
			create table.make_filled (row, 1, rows_count)

			across 1 |..| rows_count as ic loop
				create row.make (columns_count)
				table.put (row, ic.item)
			end

			table[1].put(400,"Zurich"); table[1].put(198,"Geneva"); table[1].put(176,"Basel"); table[1].put(146,"Lausanne")
			table[2].put(1894,"Balzer"); table[2].put(1893,"Duryea Car"); table[2].put(1889,"Daimler-Maybach Stahlradwagen");
			table[2].put(1884,"La Marquise")

			-- End - Create and fill table

			-- Render table
			{FLAT_RENDERER}.dump_01 (table)

		end

end
