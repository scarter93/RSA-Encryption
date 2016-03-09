-- Entity name: modular_exponentiation
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity modular_exponentiation is

	generic(WIDTH_IN : integer := 128
	);
	port(	N :	in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned((2*WIDTH_IN)-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out unsigned((2*WIDTH_IN)-1 downto 0) --Output
	);
end entity;

architecture behavior of modular_exponentiation is 

signal x : integer := 0;
signal y : integer := 0;

signal temp_A : unsigned(WIDTH_IN-1 downto 0);
signal temp_B : unsigned(WIDTH_IN-1 downto 0);

signal temp_M : unsigned((2*WIDTH_IN)-1 downto 0);
signal temp_N : unsigned(WIDTH_IN-1 downto 0);
signal temp_C : unsigned((2*WIDTH_IN)-1 downto 0);

component montgomery_multiplier
	generic(WIDTH_IN : integer := 128
	);
	port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned((2*WIDTH_IN)-1 downto 0);
		clk :	in std_logic;
		reset :	in std_logic;
		M : 	out unsigned((2*WIDTH_IN)-1 downto 0)
	);
end component;

begin

mont_mult: montgomery_multiplier
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A, 
		B => temp_B, 
		N => M, 
		clk => clk, 
		reset => reset, 
		M => temp_M 
		);

C <= temp_C;

sqr_mult : Process(clk, reset, N, Exp)

variable index : integer := 0;
--variable number : unsigned(WIDTH_IN-1 downto 0);

begin
	if reset = '1' then
		temp_N <= (others => '0');
		temp_M <= (others => '0');
		temp_C <= (others => '0');	
	
	elsif(clk'EVENT) then

	L1: for x in (WIDTH_IN-1) to 0 loop
		if(Exp(x) = '1') then
			temp_N <= N;
			index := x;
			exit L1;
		end if;
	end loop;
	
	L2: for x in index to 0 loop
		if(Exp(x) = '1') then
			L2_1: for y in 0 to 2 loop
				case y is
					when 0 =>
						temp_A <= temp_N;
						temp_B <= temp_N;
					when 1 =>
						temp_A <= temp_M;
						temp_B <= N;
					when 2 =>
						temp_N <= temp_M;
						temp_C <= temp_M;
				end case;
			end loop;
		else
			L2_2: for y in 0 to 1 loop
				case y is
					when 0 =>
						temp_A <= temp_N;
						temp_B <= temp_N;
					when 1 =>
						temp_N <= temp_M;
						temp_C <= temp_M;
				end case;
			end loop;
		end if;
	end loop;
end if;		

end process sqr_mult;
 
end behavior; 