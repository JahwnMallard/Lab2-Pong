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

type ball_dx is
(left, right );

type ball_dy is
(ball_up, ball_down);

signal count, count_next : unsigned (10 downto 0);
signal ball_x_pos, ball_y_pos :  unsigned(10 downto 0);

signal dx_reg, dx_next : ball_dx;
signal dy_reg, dy_next : ball_dy;

begin
 --ball_X state register
process(clk, reset)
   begin
      if (reset='1') then
         dx_reg <= left;
      elsif rising_edge(clk) then
			dx_reg <= dx_next;
      end if;
end process;

process(clk, reset)
   begin
      if (reset='1') then
         dy_reg <= ball_up;
      elsif rising_edge(clk) then
			dy_reg <= dy_next;
      end if;
end process;


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
count_next <= (others => '0') when (count = 999) else
				  count when (v_completed = '0') else
				  count + 1;

process(count_next)
	begin
	
	if(count_next = 0) then
		case ball_x_pos is
			when ("1001111111") => 
			if(dx_reg = right) then
				dx_next <= left;
			else 
				dx_next <=right;
			end if;
			
			when (others=> '0') =>
			if(dx_reg = left) then
				dx_next <= right;
			else 
				dx_next <=left;
			end if;
			
			when others =>
				dx_next <= dx_reg;
			end case;
			
	end if;
	
end process;


process(dx_next, reset)
begin
	if (Reset= '1') then
		ball_x_pos<= ("00110010010");
	elsif (dx_next = left) then
		ball_x_pos <= ball_x_pos-1;
	else
		ball_x_pos <= ball_x_pos+1;
	end if;	
end process;

process(reset, count_next)
	begin
	   ball_x<= ("00110010010");
	if (reset = '1') then
		ball_x<= ("00110010010");
		ball_x_pos<= ("00110010010");
	elsif (count_next = 0) then
		 ball_x <= ball_x_pos;
	else
		ball_x <= ball_x;
	end if;
end process;	
end Behavioral;

