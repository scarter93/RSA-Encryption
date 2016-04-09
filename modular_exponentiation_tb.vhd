-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet, Jacob Barnett
-- Contact: luis.galletzambrano@mail.mcgill.ca, jacob.barnett@mail.mcgill.ca
-- Date: April 07, 2016
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
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned(WIDTH_IN-1 downto 0); --Modulus
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

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
--signal c_out : std_logic;

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


	REPORT "Begin test case for base=1094051021, exp=65537, mod=3322225339";
	REPORT "Expected output is 1953609531, 01110100011100011011011100111011";
	N_in <= "01000001001101011110010011001101";
	Exp_in <= "00000000000000010000000000000001";
	M_in <= "11000110000001010010001010111011";
	wait for 2209 * clk_period;
	ASSERT(C_out = "01110100011100011011011100111011") REPORT "test failed" SEVERITY NOTE;

--	REPORT "Begin test case for base=1953609531, exp=1294474697, mod=3322225339";
--	REPORT "Expected output is 1094051021, 01000001001101011110010011001101";
--	N_in <= "01110100011100011011011100111011";
--	Exp_in <= "01001101001010000001110111001001";
--	M_in <= "11000110000001010010001010111011";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01000001001101011110010011001101") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1632172378, exp=65537, mod=2568551201";
--	REPORT "Expected output is 1237636355, 01001001110001001101010100000011";
--	N_in <= "01100001010010001111100101011010";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10011001000110001111101100100001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01001001110001001101010100000011") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=1237636355, exp=643392005, mod=2568551201";
--	REPORT "Expected output is 1632172378, 01100001010010001111100101011010";
--	N_in <= "01001001110001001101010100000011";
--	Exp_in <= "00100110010110010110001000000101";
--	M_in <= "10011001000110001111101100100001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01100001010010001111100101011010") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1925066499, exp=65537, mod=2307066997";
--	REPORT "Expected output is 1866141686, 01101111001110110000111111110110";
--	N_in <= "01110010101111100010111100000011";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10001001100000110000110001110101";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01101111001110110000111111110110") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=1866141686, exp=398083233, mod=2307066997";
--	REPORT "Expected output is 1925066499, 01110010101111100010111100000011";
--	N_in <= "01101111001110110000111111110110";
--	Exp_in <= "00010111101110100100010010100001";
--	M_in <= "10001001100000110000110001110101";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01110010101111100010111100000011") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1205726530, exp=65537, mod=2214150403";
--	REPORT "Expected output is 308258767, 00010010010111111010011111001111";
--	N_in <= "01000111110111011110110101000010";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10000011111110010100000100000011";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "00010010010111111010011111001111") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=308258767, exp=91653745, mod=2214150403";
--	REPORT "Expected output is 1205726530, 01000111110111011110110101000010";
--	N_in <= "00010010010111111010011111001111";
--	Exp_in <= "00000101011101101000011001110001";
--	M_in <= "10000011111110010100000100000011";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01000111110111011110110101000010") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1741131592, exp=65537, mod=2311115783";
--	REPORT "Expected output is 2102301444, 01111101010011101001001100000100";
--	N_in <= "01100111110001111000111101001000";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10001001110000001101010000000111";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01111101010011101001001100000100") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=2102301444, exp=2075097281, mod=2311115783";
--	REPORT "Expected output is 1741131592, 01100111110001111000111101001000";
--	N_in <= "01111101010011101001001100000100";
--	Exp_in <= "01111011101011110111100011000001";
--	M_in <= "10001001110000001101010000000111";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01100111110001111000111101001000") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1842346154, exp=65537, mod=2368304801";
--	REPORT "Expected output is 356092734, 00010101001110011000101100111110";
--	N_in <= "01101101110011111111100010101010";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10001101001010010111011010100001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "00010101001110011000101100111110") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=356092734, exp=289371521, mod=2368304801";
--	REPORT "Expected output is 1842346154, 01101101110011111111100010101010";
--	N_in <= "00010101001110011000101100111110";
--	Exp_in <= "00010001001111110111010110000001";
--	M_in <= "10001101001010010111011010100001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01101101110011111111100010101010") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1113958272, exp=65537, mod=2570856647";
--	REPORT "Expected output is 2374647821, 10001101100010100100000000001101";
--	N_in <= "01000010011001011010011110000000";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10011001001111000010100011000111";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "10001101100010100100000000001101") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=2374647821, exp=1606651433, mod=2570856647";
--	REPORT "Expected output is 1113958272, 01000010011001011010011110000000";
--	N_in <= "10001101100010100100000000001101";
--	Exp_in <= "01011111110000111000111000101001";
--	M_in <= "10011001001111000010100011000111";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01000010011001011010011110000000") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1316141679, exp=65537, mod=2170091881";
--	REPORT "Expected output is 63879130, 00000011110011101011011111011010";
--	N_in <= "01001110011100101011101001101111";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10000001010110001111100101101001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "00000011110011101011011111011010") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=63879130, exp=1313896585, mod=2170091881";
--	REPORT "Expected output is 1316141679, 01001110011100101011101001101111";
--	N_in <= "00000011110011101011011111011010";
--	Exp_in <= "01001110010100000111100010001001";
--	M_in <= "10000001010110001111100101101001";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01001110011100101011101001101111") REPORT "test failed" SEVERITY NOTE;
--
--
--	REPORT "Begin test case for base=1351805575, exp=65537, mod=2750797477";
--	REPORT "Expected output is 270864138, 00010000001001010000111100001010";
--	N_in <= "01010000100100101110101010000111";
--	Exp_in <= "00000000000000010000000000000001";
--	M_in <= "10100011111101011101011010100101";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "00010000001001010000111100001010") REPORT "test failed" SEVERITY NOTE;
--
--	REPORT "Begin test case for base=270864138, exp=1202137793, mod=2750797477";
--	REPORT "Expected output is 1351805575, 01010000100100101110101010000111";
--	N_in <= "00010000001001010000111100001010";
--	Exp_in <= "01000111101001110010101011000001";
--	M_in <= "10100011111101011101011010100101";
--	wait for 2209 * clk_period;
--	ASSERT(C_out = "01010000100100101110101010000111") REPORT "test failed" SEVERITY NOTE;




	wait;

end process;
end;
