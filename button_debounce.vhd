----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Miller
-- 
-- Create Date:    02:52:07 02/14/2014 
-- Design Name: 		
-- Module Name:    button_debounce - Behavioral 
-- Project Name:   Pong -Lab 2
-- Target Devices: 
-- Tool versions: 
-- Description: Takes in a button input and debounces it, producing a high output for only 1 clock cycle
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_debounce is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           btn_in : in  STD_LOGIC;
           btn_out : out  STD_LOGIC);
end button_debounce;

architecture Behavioral of button_debounce is

type button is
(stall, pressed, depressed);

signal button_reg, button_next : button;
signal count_reg, count_next : unsigned ( 19 downto 0);
signal button_out_buff, button_next_buff : std_logic;



begin

--count logic
count_next <= count_reg + 1 when button_next = pressed else
to_unsigned(0, 20);


--Count register
process(clk, reset)
	begin
			if (reset = '1') then
				count_reg <= to_unsigned(0,20);
			elsif rising_edge(clk) then
				count_reg <= count_next;
			end if;
	end process;


--state register
	process(clk, reset)
	begin
		if (reset='1') then
			button_reg <= stall;
		elsif (rising_edge(clk)) then
			button_reg <= button_next;
		end if;
	end process;
	
--output buffer
	process(clk)
	begin
		if (rising_edge(clk)) then
			button_out_buff <= button_next_buff;
		end if;
	end process;
	
--next-state logic	
	process(btn_in, count_reg, button_reg)
		begin
		
			button_next<=button_reg;
			case button_reg is
			 when stall =>
				if(btn_in = '1') then
					button_next <= pressed;
				end if;
				
			when pressed =>
				if(count_reg>50000 and btn_in = '0') then	
					button_next <=depressed;
				end if;
			when depressed =>
				button_next <= stall;
			end case;
		end process;
		
--ouptut logic		
	process(button_reg)
		begin
			case button_reg is
				when stall =>
					button_next_buff <= '0';
				when pressed =>
					button_next_buff <= '0';
				when depressed =>
					button_next_buff <= '1';				
			end case;
	end process;
	
	--output
	btn_out <= button_out_buff;
end behavioral;