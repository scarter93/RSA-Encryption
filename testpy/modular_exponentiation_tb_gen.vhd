-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: April 05, 2016
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
		WIDTH_IN : integer := 16
	);
	port(	N :	in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
		--latch_in: in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out unsigned(WIDTH_IN-1 downto 0) --Output
		--C : out std_logic
	);

end component;

CONSTANT WIDTH_IN : integer := 8;

CONSTANT clk_period : time := 1 ns;

Signal M_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal N_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal Exp_in : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal latch_in : std_logic := '0';

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
--signal c_out : std_logic;

--CONSTANT NUM_12 : unsigned(WIDTH_IN-1 downto 0) := "00001100";
--CONSTANT NUM_2	: unsigned(WIDTH_IN-1 downto 0) := "00001010";
--CONSTANT N_5	: unsigned(WIDTH_IN-1 downto 0) := "00000101";


Begin
-- device under test
dut: modular_exponentiation 
			generic map(WIDTH_IN => WIDTH_IN)
			PORT MAP(	N	=> 	N_in,
					Exp 	=> 	Exp_in,
					M 	=> 	M_in,
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


	REPORT "Begin test case for a=21563, b=65537, N=39407";
	REPORT "Expected output is 1635, 0000011001100011";
	M_in <= "0101010000111011";
	Exp_in <= "10000000000000001";
	N_in <= "1001100111101111";
	wait for 17 * clk_period;
	ASSERT(C_out = "0000011001100011") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for a=1635, b=21473, N=39407";
	REPORT "Expected output is 21563, 0101010000111011";
	M_in <= "0000011001100011";
	Exp_in <= "0101001111100001";
	N_in <= "1001100111101111";
	wait for 17 * clk_period;
	ASSERT(C_out = "0101010000111011") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for a=18808, b=65537, N=41917";
	REPORT "Expected output is 1325, 0000010100101101";
	M_in <= "0100100101111000";
	Exp_in <= "10000000000000001";
	N_in <= "1010001110111101";
	wait for 17 * clk_period;
	ASSERT(C_out = "0000010100101101") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for a=1325, b=7973, N=41917";
	REPORT "Expected output is 18808, 0100100101111000";
	M_in <= "0000010100101101";
	Exp_in <= "0001111100100101";
	N_in <= "1010001110111101";
	wait for 17 * clk_period;
	ASSERT(C_out = "0100100101111000") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for a=20040, b=65537, N=45173";
	REPORT "Expected output is 21266, 0101001100010010";
	M_in <= "0100111001001000";
	Exp_in <= "10000000000000001";
	N_in <= "1011000001110101";
	wait for 17 * clk_period;
	ASSERT(C_out = "0101001100010010") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for a=21266, b=37817, N=45173";
	REPORT "Expected output is 20040, 0100111001001000";
	M_in <= "0101001100010010";
	Exp_in <= "1001001110111001";
	N_in <= "1011000001110101";
	wait for 17 * clk_period;
	ASSERT(C_out = "0100111001001000") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for a=18826, b=65537, N=41449";
	REPORT "Expected output is 25730, 0110010010000010";
	M_in <= "0100100110001010";
	Exp_in <= "10000000000000001";
	N_in <= "1010000111101001";
	wait for 17 * clk_period;
	ASSERT(C_out = "0110010010000010") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for a=25730, b=9953, N=41449";
	REPORT "Expected output is 18826, 0100100110001010";
	M_in <= "0110010010000010";
	Exp_in <= "0010011011100001";
	N_in <= "1010000111101001";
	wait for 17 * clk_period;
	ASSERT(C_out = "0100100110001010") REPORT "test failed" SEVERITY NOTE;




	wait;

end process;
end;
