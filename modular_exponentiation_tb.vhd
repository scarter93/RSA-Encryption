-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: April 12, 2016
-- Description:
-- Testbench for modular_exponentiation.vhd and mod_exp_comparison.vhd

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity modular_exponentiation_tb is
end entity;

architecture test of modular_exponentiation_tb is

component mod_exp_comparison is
 	generic(
		WIDTH_IN : integer := 64
	);
	port(	N :	in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out unsigned(WIDTH_IN-1 downto 0) --Output
		
	);

end component;

CONSTANT WIDTH_IN : integer := 64;

CONSTANT clk_period : time := 1 ns;

Signal M_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal N_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal Exp_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal latch_in : std_logic := '0';

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');


Begin
-- device under test
dut: mod_exp_comparison 
			generic map(WIDTH_IN => WIDTH_IN)
			PORT MAP(	N	=> 	N_in,
					Exp 	=> 	Exp_in,
					M 	=> 	M_in,
					clk	=> 	clk,
					reset 	=>	reset_t,
					C	=>	C_out
				);
  
-- process for clock
clk_process : Process
Begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;

stim_process: process
Begin


	reset_t <= '1';
	wait for 1 * clk_period;
	reset_t <= '0';
	wait for 1 * clk_period;

	REPORT "Begin test case for base=9014435050856796582, exp=65537, mod=10976230439201618177";
	REPORT "Expected output is 10386396763144533567, 1001000000100011111001001101001110011011011111110011011000111111";
	N_in <= "0111110100011001101101001110101100010001001001100101000110100110";
	Exp_in <= "0000000000000000000000000000000000000000000000010000000000000001";
	M_in <= "1001100001010011011001110110111000001101011100010011100100000001";
	wait for 8513 * clk_period;
	ASSERT(C_out = "1001000000100011111001001101001110011011011111110011011000111111") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=10386396763144533567, exp=6302493663540011453, mod=10976230439201618177";
	REPORT "Expected output is 9014435050856796582, 0111110100011001101101001110101100010001001001100101000110100110";
	N_in <= "1001000000100011111001001101001110011011011111110011011000111111";
	Exp_in <= "0101011101110110111101001001100001001110011100111110000110111101";
	M_in <= "1001100001010011011001110110111000001101011100010011100100000001";
	wait for 8513 * clk_period;
	ASSERT(C_out = "0111110100011001101101001110101100010001001001100101000110100110") REPORT "test failed" SEVERITY NOTE;



	wait;

end process;
end;
