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

signal dx, dy : std_logic;
begin
 --ball_X state register


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
 if(count_next= 0) then
	if(dx = '1') then
		ball_x_pos<= ball_x_pos+1;
	elsif (dx ='0') then
		ball_x_pos <= ball_x_pos - 1;
	end if;

end if;
end process;	


process(count_next)
begin
if(count_next = 0) then
	if( (ball_x_pos = 639) and (dx='1')) then
		dx <= '0';
	elsif ( (ball_x_pos = 0) and (dx='0')) then
		dx <= '1';
	else	
		dx <= dx;
	end if;
end if;	
end process;

process(reset, count_next)
	begin
		ball_x<= ("00110010010");
	if(reset = '0') then
		ball_x <= ball_x_pos;
	end if;	
	
	ball_x<= ball_x_pos;
	
end process;	
end Behavioral;

