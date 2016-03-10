-- Entity name: montgomery_multiplier
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity montgomery_multiplier is
	Generic(WIDTH_IN : integer := 8
	);
	Port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned(WIDTH_IN-1 downto 0);
		clk :	in std_logic;
		reset :	in std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end entity;

architecture behavioral of montgomery_multiplier is

Signal M_temp : unsigned(WIDTH_IN downto 0) := (others => '0');
Signal temp : unsigned(WIDTH_IN downto 0) := (others => '0');
Signal temp_s : unsigned(WIDTH_IN downto 0) := (others => '0'); 
Signal B_i : integer := 0;
Signal temp_i : std_logic := '0';
Begin


compute_M : Process(clk, reset, A, B, N)
Begin
	--if(rising_edge(clk) and reset = '0') then
		for i in 0 to (WIDTH_IN-1) loop
			
			if B(i) = '1' then
				M_temp <= M_temp + A;
			end if;

			if M_temp(0) = '1' then
				temp <= M_temp;
				M_temp <= unsigned(shift_right(unsigned(temp), integer(1)));
			else
				temp <= M_temp + N;
				M_temp <= unsigned(shift_right(unsigned(temp), integer(1)));
			end if;
--			temp <= M_temp + N;
--				M_temp <= unsigned(shift_right(unsigned(temp), integer(1)));
		end loop;
		M <= M_temp(WIDTH_IN-1 downto 0);

end Process;

end architecture;
