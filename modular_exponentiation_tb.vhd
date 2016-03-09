-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity modular_exponentiation_tb is
end entity;

architecture test of modular_exponentiation_tb is
-- define the ALU compontent to be tested
component modular_exponentiation is
 	generic(
		WIDTH_IN : integer := 8
	);
	port(	N :	in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	in unsigned((2*WIDTH_IN)-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out unsigned((2*WIDTH_IN)-1 downto 0) --Output
	);
end component;

CONSTANT WIDTH_IN : integer := 8;

CONSTANT clk_period : time := 1 ns;

Signal M_in : unsigned((2*WIDTH_IN)-1 downto 0) := (others => '0');
Signal N_in : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal Exp_in : unsigned(WIDTH_IN-1 downto 0) := (others => '0');

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : unsigned(2*(WIDTH_IN)-1 downto 0) := (others => '0');

CONSTANT NUM_12 : unsigned(WIDTH_IN-1 downto 0) := "00001100";
CONSTANT NUM_2	: unsigned(WIDTH_IN-1 downto 0) := "00000010";
CONSTANT N_5	: unsigned((2*WIDTH_IN)-1 downto 0) := "0000000000000101";


Begin
-- device under test
dut: modular_exponentiation PORT MAP(	N	=> 	N_in,
					Exp 	=> 	Exp_in,
					M 	=> 	M_in,
					clk	=> 	clk,
					reset 	=>	reset_t,
					C	=>	C_out);
  
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
	wait for 2 * clk_period;


	REPORT "begin test case for A=12, B=2, N=5";
	REPORT "expected output is 4 00001000";
	N_in <= NUM_12;
	Exp_in <= NUM_2;
	M_in <= N_5;
	wait for 1 * clk_period;
	ASSERT(C_out = "0000000000001000") REPORT "test passed" SEVERITY NOTE;
	ASSERT(C_out /= "0000000000001000") REPORT "test failed" SEVERITY ERROR;

	wait;

end process;
end;
