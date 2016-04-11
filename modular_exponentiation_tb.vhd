-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: April 11, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;

entity modular_exponentiation_tb is
end entity;

architecture test of modular_exponentiation_tb is
-- define the ALU compontent to be tested
component modular_exponentiation is
 	generic(
		WIDTH_IN : integer := 32
	);
	port(	N :	in unsigned(WIDTH_IN-1 downto 0); --Number
		enc_dec : std_logic;
		--Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		--M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
		--latch_in: in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out unsigned(WIDTH_IN-1 downto 0) --Output
		--C : out std_logic
	);

end component;

CONSTANT WIDTH_IN : integer := 32;

CONSTANT clk_period : time := 1 ns;

Signal M_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal N_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal Exp_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal latch_in : std_logic := '0';
signal enc_dec : std_logic;

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
--signal c_out : std_logic;

Begin
-- device under test
dut: modular_exponentiation 
			generic map(WIDTH_IN => WIDTH_IN)
			PORT MAP(	N	=> 	N_in,
					enc_dec => 	enc_dec,
					--Exp 	=> 	Exp_in,
					--M 	=> 	M_in,
					--latch_in => latch_in,
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

	REPORT "Begin test case for base=1314923968, exp=65537, mod=3816753671";
	REPORT "Expected output is 2260331515, 10000110101110011110101111111011";
	N_in <= "01001110011000000010010111000000";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "11100011011111110000101000000111";
	wait for 2500 * clk_period;
	ASSERT(C_out = "10000110101110011110101111111011") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=2260331515, exp=114200489, mod=3816753671";
	REPORT "Expected output is 1314923968, 01001110011000000010010111000000";
	N_in <= "10000110101110011110101111111011";
	Exp_in <= "00000110110011101000111110101001";
	M_in <= "11100011011111110000101000000111";
	wait for 2500 * clk_period;
	ASSERT(C_out = "01001110011000000010010111000000") REPORT "test failed" SEVERITY NOTE;

	wait;

end process;
end;
