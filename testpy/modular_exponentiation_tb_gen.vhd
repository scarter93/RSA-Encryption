-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: April 06, 2016
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


	REPORT "Begin test case for base=2060537757, exp=65537, mod=2681534753";
	REPORT "Expected output is 45950664, 00000010101111010010011011001000";
	N_in <= "01111010110100010100111110011101";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "10011111110101001111100100100001";
	wait for 2209 * clk_period;
	ASSERT(C_out = "00000010101111010010011011001000") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=45950664, exp=2194759313, mod=2681534753";
	REPORT "Expected output is 2060537757, 01111010110100010100111110011101";
	N_in <= "00000010101111010010011011001000";
	Exp_in <= "10000010110100010101111010010001";
	M_in <= "10011111110101001111100100100001";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01111010110100010100111110011101") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for base=1511821503, exp=65537, mod=2162454509";
	REPORT "Expected output is 1044350148, 00111110001111111000010011000100";
	N_in <= "01011010000111001001000010111111";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "10000000111001000110111111101101";
	wait for 2209 * clk_period;
	ASSERT(C_out = "00111110001111111000010011000100") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=1044350148, exp=1076860673, mod=2162454509";
	REPORT "Expected output is 1511821503, 01011010000111001001000010111111";
	N_in <= "00111110001111111000010011000100";
	Exp_in <= "01000000001011111001011100000001";
	M_in <= "10000000111001000110111111101101";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01011010000111001001000010111111") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for base=1203607754, exp=65537, mod=3181061419";
	REPORT "Expected output is 1822525015, 01101100101000011000011001010111";
	N_in <= "01000111101111011001100011001010";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "10111101100110110010010100101011";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01101100101000011000011001010111") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=1822525015, exp=2679302897, mod=3181061419";
	REPORT "Expected output is 1203607754, 01000111101111011001100011001010";
	N_in <= "01101100101000011000011001010111";
	Exp_in <= "10011111101100101110101011110001";
	M_in <= "10111101100110110010010100101011";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01000111101111011001100011001010") REPORT "test failed" SEVERITY NOTE;


	REPORT "Begin test case for base=1706894603, exp=65537, mod=2236939321";
	REPORT "Expected output is 1830148727, 01101101000101011101101001110111";
	N_in <= "01100101101111010010010100001011";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "10000101010101001111110000111001";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01101101000101011101101001110111") REPORT "test failed" SEVERITY NOTE;

	REPORT "Begin test case for base=1830148727, exp=883273837, mod=2236939321";
	REPORT "Expected output is 1706894603, 01100101101111010010010100001011";
	N_in <= "01101101000101011101101001110111";
	Exp_in <= "00110100101001011011000001101101";
	M_in <= "10000101010101001111110000111001";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01100101101111010010010100001011") REPORT "test failed" SEVERITY NOTE;




	wait;

end process;
end;
