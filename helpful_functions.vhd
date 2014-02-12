--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
package helpful_functions is

	constant ball_radius		: integer := 5;
   constant paddle_height 	: integer := 10;
--
-- Declare functions and procedure
--
function isAF  (signal row, col : in unsigned(10 downto 0 ) ) return std_logic;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end helpful_functions;

package body helpful_functions is

--- Example 1
    function isAF  (signal row, col : in unsigned(10 downto 0 ) ) return std_logic is
			variable AF: std_logic;
	begin
		AF :=  ( (row < "00010001100") or (row > "00101000000")) or  --top and bottom
				 ( (col < "00011010101") or (col > "00110101010")) or	--middle section	
				 ( integer(col)>455 and integer(col)< 180) or  --left and right
				 ((col>209 and col<290) and ((row>240 and row<320) or (row>160 and row <216))) or -- A 
				 ((col>370 and col<426) and ((row>240 and row<320 ) or (row>160 and row<216)));
		return  not AF; 
	end isAF;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end helpful_functions;
