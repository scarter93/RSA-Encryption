-- Entity name: modular_exponentiation
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.mod_exp_package.all;


entity modular_exponentiation is

	generic(WIDTH_IN : integer := 128
	);
	port(	N :	in std_logic_vector(WIDTH_IN-1 downto 0); --Number
		Exp :	in std_logic_vector(WIDTH_IN-1 downto 0); --Exponent
		M :	in std_logic_vector(WIDTH_IN-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out std_logic_vector(WIDTH_IN-1 downto 0) --Output
	);
end entity;

architecture behavior of modular_exponentiation is 


signal temp_A1,temp_A2 : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_B1, temp_B2 : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_d_ready, temp_latch, temp_latch2 : std_logic := '0';
signal temp_M1, temp_M2 : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');



signal temp_M : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_C : std_logic_vector(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');



component montgomery_multiplier
Generic(WIDTH_IN : integer := 128
	);
	Port(	A :	in std_logic_vector(WIDTH_IN-1 downto 0);
		B :	in std_logic_vector(WIDTH_IN-1 downto 0);
		N :	in std_logic_vector(WIDTH_IN-1 downto 0);
		latch : in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		d_ready : out std_logic;
		M : 	out std_logic_vector(WIDTH_IN-1 downto 0)
	);
end component;

begin

temp_M <= M;

mont_mult_1: montgomery_multiplier
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A1, 
		B => temp_B1, 
		N => temp_M,
		latch => temp_latch, 
		clk => clk, 
		reset => reset,
		d_ready => temp_d_ready, 
		M => temp_M1 
		);

mont_mult_2: montgomery_multiplier
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A2, 
		B => temp_B2, 
		N => temp_M, 
		latch => temp_latch2, 
		clk => clk, 
		reset => reset,
		d_ready => temp_d_ready,  
		M => temp_M2 
		);

C <= temp_C;

sqr_mult : Process(clk, reset, N, Exp)

variable index : integer := 0;
variable y : integer range 0 to 2;
variable z : integer range 0 to 1;
variable temp_N : std_logic_vector(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');


begin

if reset = '1' then

		--temp_N <= (others => '0');
--		temp_A1 <= (others => '0');
--		temp_B1 <= (others => '0');
--		temp_A2 <= (others => '0');
--		temp_B2 <= (others => '0');
--		temp_M <= (others => '0');
--		temp_M1 <= (others => '0');
--		temp_M2 <= (others => '0');
--		temp_C <= (others => '0');	

elsif clk'event then



	L1: for i in (Exp'length)-1 downto 0 loop
		if(Exp(i) = '1') then
			temp_N := N;
			index := i;
		exit L1 when (index /= 0);
		end if;
	end loop L1;
	

	if(index > 0) then
	
		L2: for x in index downto 0 loop
			if(Exp(x) = '1') then
		
					case y is
						when 0 =>
							
							temp_latch <= '1';
							temp_A1 <= temp_N;
							temp_B1 <= temp_N;
											
							if(temp_d_ready = '1') then
								temp_latch <= '0';
								y := 1;
							end if;
						when 1 =>
							temp_latch2 <= '1';
							temp_A2 <= temp_M1;
							temp_B2 <= N;
							
							if(temp_d_ready = '1') then
								temp_latch2 <= '0';
								y := 2;
							end if;
	
						when 2 =>
							temp_N := temp_M2;
							temp_C <= temp_M2;
					end case;
				
			else
					case z is
						when 0 =>
							
							temp_latch <= '1';
							temp_A1 <= temp_N;
							temp_B1 <= temp_N;

							if(temp_d_ready = '1') then
								temp_latch <= '0';
								z := 1;
							end if;
						when 1 =>
							temp_N := temp_M2;
							temp_C <= temp_M2;
					end case;
			
			end if;
		
		end loop L2;
		
	end if;
	
end if;		

end process sqr_mult;
 
end behavior; 