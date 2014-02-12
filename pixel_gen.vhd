----------------------------------------------------------------------------------
-- Company: USAF Academy
-- Engineer: C2C John Miller
-- 
-- Create Date:    15:32:14 02/03/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
-- Project Name:   Atlys Video - Lab1
-- Target Devices: 
-- Tool versions: 
-- Description: Code to generate pixel pattern for the top shell
--	
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
--use work.helpful_functions.vhd;

entity pixel_gen is
    Port ( row : in unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
			  ball_x   : in unsigned(10 downto 0);
           ball_y   : in unsigned(10 downto 0);
           paddle_y : in unsigned(10 downto 0);
           r : out  std_logic_vector (7 downto 0);
           g : out  std_logic_vector (7 downto 0);
           b : out  std_logic_vector (7 downto 0)
			  );
end pixel_gen;

architecture Behavioral of pixel_gen is
-- signal AF : std_logic;
begin

process(blank, row, column)
begin 

--	AF <= isAF(row,column);

	r <= ( others=>'0');
	g <= ( others=>'0');
	b <= ( others=>'0');
	
	if (blank = '1') then
	r <= ( others=>'0');
	g <= ( others=>'0');
	b <= ( others=>'0');

--I very much guessed the RGB values here, I was just looking for 4 distinct patterns
	
	else 
	-- bottom third of the screen
			if ( ( (row < "00010001100") or (row > "00101000000")) or  --top and bottom
				 ( (column< "00011010101") or (column > "00110101010")) or	--middle section	
				 ( (column>455 and column< 180) or  --left and right
				 ((column>209 and column<290) and ((row>240 and row<320) or (row>160 and row <216))) or -- A 
				 ((column>370 and column<426) and ((row>240 and row<320 ) or (row>160 and row<216)))))  then
				r <= ( others=>'0');
				g <=(others => '0');
				b <= (others => '1');	
			else 
				r <= ( others=>'0');
				g <= ( others=>'0');
				b <= (others => '0');
			end if;
	end if;				
	 			
end process;


end Behavioral;

