Lab2- Pong
=========

C2C John Miller

VHDL Code to play the classic game of pong on the Atlys Board

The game takes on the following form
![Thrilling gameplay of pong](pong_game.jpg)


This code also supports the use of the switches on the Atlys board for modifying the speed of the ball.

The major problems that this project dealt with were:
* Utilizing the already made vga modules and creating a dynamic image as opposed to a static one
* Implementing multiple state machines within the same module
* Finding a hardware based solution to debouncing, as opposed to a software based on that would be available in a programming language.
* Being able to use a clock that updates in a matter of nanoseconds to create a game that is playable by humans.


Version
----

1.2 -Implements the addition of "hot zones" on the paddle, which reflect the ball at different angles

Previous Versions
----
* 1.1 - Added support for manipulating ball speed via switches on the atlys board
* 1.0 - Basic pong functionality

Implementation
-----------
This project relied heavily on the use of a finite state machine [FSM], which uses a mix of next state logic, memory, and output logic in order to determine the state of the machine, as well as 

The following basic constructs were used:

Flip-flop (memory element):

```Vhdl
process(clk, reset)
   begin
      if (reset='1') then
         state_reg <= move;
      elsif rising_edge(clk) then
            state_reg <= state_next;
      end if;
end process;
```

Next State logic:

```Vhdl
process(count, state_reg)
    begin
		
		state_next <= state_reg;
	
		case state_reg is
			when ActiveVideo =>
				if (count = 639) then
					state_next <= FrontPorch;
				end if;
			when FrontPorch =>
				if (count = 15) then
					state_next <= Sync;
				end if;
			when Sync =>
				if (count = 95) then
					state_next <= BackPorch;
				end if;
			when BackPorch =>
				if (count = 46) then
					state_next <= Complete;
				end if;
			when Complete =>
				state_next <= ActiveVideo;	
		end case;
	end process;

```
Output logic

```Vhdl
process(state_next, count_next)
    
   begin
		h_sync <= '0';
		blank <='0';
		completed <='0';
		column <= (others => '0');
       
      case state_next is
         when ActiveVideo =>
            h_sync <= '1';
				blank <='0';
				completed <='0';
				column <= count_next;
         when FrontPorch =>
            h_sync <= '1';
				blank <='1';
				completed <='0';
				column <= (others => '0');
         when Sync =>
            h_sync <= '0';
				blank <='1';
				completed <='0';
				column <= (others => '0');
         when BackPorch =>
            h_sync <= '1';
				blank <='1';
				completed <='0';
				column <= (others => '0');
			when Complete =>
			   h_sync <= '1';
				blank <='1';
				completed <='1';
				column <= (others => '0');
      end case;
   end process;
```

The following modules were to implement the game
* h_sync_gen.vhd - Synchronizes the horizontal aspect of the signal
* v_sync_gen.vhd - Synchronizes the vertical aspect of the signal
* vga_sync.vhd - Synchronizes the h_sync and v_sync signals to specify a specific pixel 
* button_module.vhd - Debounces the button inputs to make sure that each button press is only accounted for once.
* pong_control.vhd - Updates the game state based on ball position, paddle position, as well as external inputs to the board.
* pixel_gen.vhd - Displays the game based on the outputs of the pong_control module
* atlys_lab_video.vhd - Top-shell module
* dvid.vhd - Outputs the HDMI signal (converted by hardware to vga)

The modules are connected as shown below:

![block diagram](block_diagram.jpg)

State transition diagram

Ball states :

 ![Ball state transitions](ball_state.jpg)

Paddle states:

![Paddle state transitions](ball_state.jpg)


Troubleshooting
--------------

The biggest troubles I had can be separated by module:



Confirming functionality
--------------

Although they would have been a more robust method of testing, testbenches were not used in debugging the code, instead, it was done in incremental stages.

1. the AF logo was created, which was changed by modifying the pixel_gen module slightly each time until the output matched the design requirements

2. The paddle and ball were drawn to make sure that their proportions were correct

3. The paddle was tested until it met movement requirements. This meant changing lines of code at a time until the paddle moved at a reliable rate
    1. Within the creation of this module, the button debounce was implemented, which was tested by confirming paddle functionality.

4. The ball was incrementally tested, first for horizontal movement, then for vertical movement. Then the ball was tested to make sure it would bounce off the walls, and then that it would bounce off of the paddle and that it would freeze if it hit the left hand wall.

5. Once the core gameplay was created, the code was modified to support ball speeds and "hot zones" on the paddle. 
    
The hardest thing to test was the ball movement. The ball would work for periods of time and then it would "teleport", instantly moving to a different section of the screen.

Lessons Learned
---

* The main lesson was to have thorough testbenches, looking through mine, I didn't put quite as much effort in as I should have
* Don't assume that clock cycles will match up just because the waveform "looks right". With things like this, the timing needs to be immaculate.
* Write synthasizable code. The synthasizer is not psychic, it can't make good hardware out of bad code.




##### TODO

* implement a look-ahead buffer
* convert code to use generics
* test reset cases

Documentation
----

C2C Ryan Good was a great help in helping me debug my V_sync module

