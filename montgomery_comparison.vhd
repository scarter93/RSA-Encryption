-- Entity name: montgomery_comparison
-- Author: LuisGallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: March 28th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library lpm;
use lpm.lpm_components.all;

entity montgomery_comparison is
	Generic(WIDTH_IN : integer := 8
	);
	Port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned(WIDTH_IN-1 downto 0);
		latch : in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		data_ready : out std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end entity;

architecture behavioral of montgomery_comparison is

signal A_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal B_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal N_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal M_temp : std_logic_vector(WIDTH_IN-1 downto 0):= (others => '0');

signal M_temp_old : std_logic_vector(WIDTH_IN-1 downto 0):= (others => '0');


signal mult_zero : std_logic_vector(2*WIDTH_IN-1 downto 0) := (others => '0');
signal mult_undefined : std_logic_vector(2*WIDTH_IN-1 downto 0) := (others => 'U');
signal rem_zero : std_logic_vector(WIDTH_IN-1 downto 0) := (others => '0');
signal rem_undefined : std_logic_vector(WIDTH_IN-1 downto 0) := (others => 'U');

signal mult_result : std_logic_vector(2*WIDTH_IN-1 downto 0) := (others => '0');
signal temp_mult_result : std_logic_vector(2*WIDTH_IN-1 downto 0) := (others => '0');

signal state : integer := 0;

Begin
 
mult: LPM_MULT
		generic map(
			LPM_WIDTHA => WIDTH_IN,
			LPM_WIDTHB => WIDTH_IN,
			LPM_WIDTHP => 2*WIDTH_IN,
			LPM_PIPELINE => 2*WIDTH_IN
		)
		port map(
			DATAA => std_logic_vector(A_temp),
			DATAB => std_logic_vector(B_temp),
			CLOCK => clk,
			RESULT => mult_result
		);

divide: LPM_DIVIDE
		generic map( 
			LPM_WIDTHN => 2*WIDTH_IN,
			LPM_WIDTHD => WIDTH_IN,
			LPM_PIPELINE => WIDTH_IN 	 
		)
		port map(
			numer => temp_mult_result,
			denom => std_logic_vector(N_temp),
			clock => clk,
			remain => M_temp
		);

	compute: process(clk, A, B, N, latch, reset)
	Begin
		if reset = '0' and rising_edge(clk) then
			case state is
				when 0 =>
					if latch = '1' then
						data_ready <= '0';
						B_temp <= B;
						A_temp <= A;
						N_temp <= N;
						state <= 1;
					end if;
		
				when 1 =>
					if(mult_result = mult_zero) OR (mult_result = mult_undefined) OR (mult_result = temp_mult_result)then
						state <= 1;
					else
						temp_mult_result <= mult_result;
						state <= 2;
					end if;
			
				when 2 =>

					if(M_temp = rem_zero) OR (M_temp = rem_undefined) OR (M_temp = M_temp_old) then
						data_ready <= '0';
						state <= 2;
					else
						data_ready <='1';
						M_temp_old <= M_temp;
						M <= unsigned(M_temp);
						state <= 0;
					end if;		
				
				when others =>
					state <= 0;
		end case;
	end if;
end process;



end architecture;
