----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:49:21 02/10/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

entity pong_control is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           v_completed : in  STD_LOGIC;
           up : in  STD_LOGIC;
           down : in  STD_LOGIC;
           ball_x : out  unsigned(10 downto 0);
           ball_y : out  unsigned(10 downto 0);
           paddle_y : out  unsigned(10 downto 0));
end pong_control;

architecture Behavioral of pong_control is
	COMPONENT button_debounce
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		btn_in : IN std_logic;          
		btn_out : OUT std_logic
		);
	END COMPONENT;
signal paddle_y_reg, paddle_y_next, count, count_next : unsigned(10 downto 0);
signal down_sig, up_sig : std_logic;

begin

	up_button_debounce: button_debounce PORT MAP(
		clk => clk ,
		reset => reset,
		btn_in => up,
		btn_out => up_sig
	);
	down_button_debounce: button_debounce PORT MAP(
		clk => clk ,
		reset => reset,
		btn_in => down,
		btn_out => down_sig
	);
--count register
process(clk,reset)
   begin
      if (reset='1') then
			count <= (others => '0');
      elsif rising_edge(clk) then
         count <= count_next;
      end if;
end process;



--count logic
count_next <= (others => '0') when (count = 9999) else
				  count + 1 when v_completed = '1' else
				  count;
				  
process(clk, reset)
begin
		if (reset = '1') then
			paddle_y_reg <= to_unsigned(45,11);
		elsif rising_edge(clk) then
			paddle_y_reg <= paddle_y_next;
		end if;

end process;

process(up, down, paddle_y_reg, paddle_y_next)
begin 

paddle_y_next <= paddle_y_reg;

	if (up_sig = '1' and  down_sig = '0' and paddle_y_next > 44) then
		paddle_y_next <= paddle_y_reg - 5;	
	elsif (up_sig = '0' and down_sig = '1' and paddle_y_next <436 ) then
		paddle_y_next <= paddle_y_reg + 5;
	end if;

end process;

paddle_y <= paddle_y_reg;

end Behavioral;

