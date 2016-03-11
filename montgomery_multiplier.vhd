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
	Generic(WIDTH_IN : integer := 128
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
Signal i : integer := 0;
Begin


--M <= M_temp(WIDTH_IN-1 downto 0);

compute_M : Process(clk, reset, A, B, N)
variable index : integer := 0;
Begin
if reset = '0' AND rising_edge(clk) then

	for i in 0 to (WIDTH_IN-1) loop
		if B(i) = '1' then
			M_temp <= M_temp + A;
		else
			M_temp <= M_temp;
		end if;
		if M_temp(0) = '1' then
			M_temp <= unsigned(shift_right(unsigned(M_temp), integer(1)));
		else
			M_temp <= unsigned(shift_right(unsigned(M_temp + N), integer(1)));
		end if;
		index := i;
	end loop;

	if (index = (WIDTH_IN-1)) then 
	M <= M_temp(WIDTH_IN-1 downto 0);
	end if;
	
end if;
end Process;

end architecture;
