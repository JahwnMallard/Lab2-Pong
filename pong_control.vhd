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
			  speed : in std_logic;
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
	
	
type ball_movement is
(move, right, left, top, bottom,  paddle_hit_hi, paddle_hit_lo);

signal ball_reg, ball_next : ball_movement;	
signal paddle_y_reg, paddle_y_next, count, count_next: unsigned(10 downto 0);
signal down_sig, up_sig : std_logic;
signal velocity : unsigned(10 downto 0);
signal x_reg,x_next, y_reg, y_next : unsigned(10 downto 0);
signal stop_reg, stop_next, dx_reg, dx_next, dy_reg, dy_next : std_logic;
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
--ball state register
process(clk, reset)
begin
		if (reset = '1') then
			ball_reg <= move;
		elsif rising_edge(clk) then
			ball_reg <= ball_next;
		end if;

end process;

velocity <= 	to_unsigned(5000,11) when speed = '1' else
					to_unsigned(10000,11);

--ball position register
process(clk, reset)
begin
		if (reset = '1') then
			x_reg <= to_unsigned(400,11);
			y_reg <= to_unsigned(200,11);
		elsif rising_edge(clk) then
			x_reg <= x_next;
			y_reg <= y_next;
		end if;

end process;

--ball direction register
process(clk, reset)
begin
		if (reset = '1') then
			dx_reg <= '1';
			dy_reg <= '1';
			stop_reg <= '0';
		elsif rising_edge(clk) then
			dx_reg <= dx_next;
			dy_reg <= dy_next;
			stop_reg <= stop_next;
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
count_next <=	(others => '0') when count>= velocity else
					count+1 when v_completed = '1' else
					count;
				  
process(clk, reset)
begin
		if (reset = '1') then
			paddle_y_reg <= to_unsigned(200,11);
		elsif rising_edge(clk) then
			paddle_y_reg <= paddle_y_next;
		end if;

end process;


--ball next-state logic
process(ball_reg, ball_next, count_next, x_reg, y_reg, paddle_y_reg)
begin

	ball_next <= ball_reg;
	
	if(count_next = 0) then
		case ball_reg is
			when move =>
				if (x_reg = 639) then
					ball_next <= right;
				elsif (x_reg = 10) then
					ball_next <= left;
				elsif (y_reg = 5) then 
					ball_next <= top;
				elsif (y_reg = 479) then
					ball_next <= bottom;
				end if;
				
				if (x_reg >10 and x_reg < 20) then 
					if ( (y_reg > paddle_y_reg - 45) and (y_reg< paddle_y_reg) ) then
						ball_next <= paddle_hit_hi;
					elsif( (y_reg < paddle_y_reg + 45) and (y_reg> paddle_y_reg) ) then
						ball_next <= paddle_hit_lo;
					end if;
				end if;
			when 	right =>
				ball_next <= move;
			when left => 
				ball_next <= move;
			when top =>
				ball_next <= move;
			when bottom =>
				ball_next <= move;
			when paddle_hit_hi =>
				ball_next <= move;
			when paddle_hit_lo =>
				ball_next <= move;
		end case;
	end if;
end process;


--output logic
process(ball_next, count_next, dx_reg, dy_reg, stop_reg)
begin

	dx_next <= dx_reg;
	dy_next <= dy_reg;
	stop_next <=stop_reg;
	
	if(count_next = 0) then
		case ball_next is
			when move =>	
			dx_next <= dx_reg;
			dy_next<= dy_reg;
			when right =>
				dx_next <= '0';
			when left =>
				stop_next <= '1';			
			when top =>
				dy_next <= '0';
			when bottom =>
				dy_next <= '1';
			when paddle_hit_hi =>
				dx_next <= '1';
				dy_next <= '1';
			when paddle_hit_lo =>
				dx_next <= '1';
				dy_next <= '0';				
			end case;
		end if;
end process;

process( count_next)
begin
	x_next<= x_reg;
	y_next <= y_reg;

 if(count_next = 0 and v_completed = '1' and stop_reg ='0') then
		if(dx_reg = '1') then
			x_next <= x_reg +1;
		else 
			x_next <= x_reg -1;
		end if;
		
		if(dy_reg = '1') then
			y_next <= y_reg -1;
		else 
			y_next <= y_reg +1;
		end if;
end if;	
end process;

--output
ball_x <= x_next;
ball_y <= y_next;














--Paddle Register
process(clk, reset)
begin
		if (reset = '1') then
			paddle_y_reg <= to_unsigned(200,11);
		elsif rising_edge(clk) then
			paddle_y_reg <= paddle_y_next;
		end if;

end process;


--Paddle State Logic
process(up_sig, down_sig, paddle_y_reg, paddle_y_next)
begin 

	paddle_y_next <= paddle_y_reg;

	if (up_sig = '1' and  down_sig = '0' and paddle_y_reg > 80 ) then
		paddle_y_next <= paddle_y_reg - to_unsigned(10, 11);	
	elsif (up_sig = '0' and down_sig = '1' and paddle_y_reg <400) then
		paddle_y_next <= paddle_y_reg + to_unsigned(10,11);

	end if;

end process;

--Paddle output logic
paddle_y <= paddle_y_reg;	

end Behavioral;