-- Entity name: montgomery_multiplier
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: Feb 28th, 2015
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity montgomery_multiplier is
	Generic(WIDTH_IN : integer := 128
	);
	Port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned((2*WIDTH_IN)-1 downto 0);
		clk :	in std_logic;
		reset :	in std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end entity;

architecture behavioral of montgomery_multiplier is

Signal M_temp : unsigned(((2*WIDTH_IN)-1) downto 0) := (others => '0');
Signal A_shift : unsigned(WIDTH_IN-1 downto 0);
Signal B_i : std_logic;
Begin

compute_M : Process(clk, reset, A, B, N)
Begin
	for i in 0 to (WIDTH_IN-1) loop
		B_i <= B(i);
		A_shift <= unsigned(shift_right(unsigned(A), integer(B_i)));
		M_temp <= M_temp + (A*B);
		if M_temp(0) = '1' then
			M_temp <= unsigned(shift_right(unsigned(M_temp), integer(1)));
		else
			M_temp <= unsigned(shift_right(unsigned(M_temp + N), integer(1)));
		end if;
	end loop;

end Process;

end architecture;