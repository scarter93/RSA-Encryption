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
	port(	N :	in integer := 0; --Number
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out integer := 0 --Output


--N :	in unsigned(WIDTH_IN-1 downto 0); --Number
--		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
--		M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
--		clk :	in std_logic;
--		reset :	in std_logic;
--		C : 	out unsigned(WIDTH_IN-1 downto 0) --Output
	);
end entity;

architecture behavior of modular_exponentiation is 

signal x : integer := 0;
signal y : integer := 0;
signal i : integer := 0;

signal temp_A1,temp_A2 : unsigned(WIDTH_IN-1 downto 0);
signal temp_B1, temp_B2 : unsigned(WIDTH_IN-1 downto 0);
signal temp_M1, temp_M2 : unsigned(WIDTH_IN-1 downto 0);

--signal temp_N : unsigned(WIDTH_IN-1 downto 0);
signal temp_N : integer := 0;
--signal temp_N2 : unsigned(WIDTH_IN-1 downto 0);
signal temp_N2 : integer := 0;
signal temp_N3 : integer := 0;
--signal temp_N3 : unsigned((2*WIDTH_IN)-1 downto 0);

signal temp_M : unsigned(WIDTH_IN-1 downto 0);
--signal temp_C : unsigned(WIDTH_IN-1 downto 0);
signal temp_C : integer :=0;
component montgomery_multiplier
	generic(WIDTH_IN : integer := 128
	);
	port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned(WIDTH_IN-1 downto 0);
		clk :	in std_logic;
		reset :	in std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end component;

begin

mont_mult_1: montgomery_multiplier
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A1, 
		B => temp_B1, 
		N => temp_M, 
		clk => clk, 
		reset => reset, 
		M => temp_M1 
		);

mont_mult_2: montgomery_multiplier
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A2, 
		B => temp_B2, 
		N => temp_M, 
		clk => clk, 
		reset => reset, 
		M => temp_M2 
		);

--C <= temp_C;

sqr_mult : Process(clk, reset, N, Exp)

variable index : integer := 0;

begin

if reset = '1' then
--		temp_N <= (others => '0');
--		temp_M <= (others => '0');
--		temp_M1 <= (others => '0');
--		temp_M2 <= (others => '0');
--		temp_C <= (others => '0');	

elsif rising_edge(clk) then

temp_M <= M;
temp_N <= N;
--
--	L1: for i in (WIDTH_IN-1) downto 0 loop
--		if(Exp(i) = '1') then
--			temp_N <= N;
--			index := i;
--		exit L1 when (index /= 0);
--		end if;
--	end loop L1;

	--if(index /= 0) then
		L2: for x in (WIDTH_IN-1) downto 0 loop
			if(Exp(x) = '1') then
				L2_1: for y in 0 to 2 loop
					case y is
						when 0 =>
							temp_N2 <= temp_N*temp_N;
--							temp_A1 <= temp_N;
--							temp_B1 <= temp_N;
						when 1 =>
							temp_N3 <= temp_N2*N;
--							temp_A2 <= temp_M1;
--							temp_B2 <= N;
						when 2 =>
							temp_N <= temp_N3;
							C <= temp_N3;
					end case;
				end loop L2_1;
			else
				L2_2: for y in 0 to 1 loop
					case y is
						when 0 =>
							temp_N2 <= temp_N*temp_N;
--							temp_A1 <= temp_N;
--							temp_B1 <= temp_N;
						when 1 =>
							temp_N <= temp_N2;
							C <= temp_N2;
					end case;
				end loop L2_2;
			end if;
		end loop L2;
	end if;
end if;		

end process sqr_mult;
 
end behavior; 