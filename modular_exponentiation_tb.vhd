-- Entity name: modular_exponentiation_tb
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
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
		WIDTH_IN : integer := 128
	);
	port(	N :	in std_logic_vector(WIDTH_IN-1 downto 0); --Number
		Exp :	in std_logic_vector(WIDTH_IN-1 downto 0); --Exponent
		M :	in std_logic_vector(WIDTH_IN-1 downto 0); --Modulus
		clk :	in std_logic;
		reset :	in std_logic;
		C : 	out std_logic_vector(WIDTH_IN-1 downto 0) --Output
	);

end component;

CONSTANT WIDTH_IN : integer := 8;

CONSTANT clk_period : time := 1 ns;

Signal M_in : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal N_in : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
Signal Exp_in : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';

Signal C_out : std_logic_vector(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

CONSTANT NUM_12 : std_logic_vector(WIDTH_IN-1 downto 0) := "00001100";
CONSTANT NUM_2	: std_logic_vector(WIDTH_IN-1 downto 0) := "00001001";--9
CONSTANT N_5	: std_logic_vector(WIDTH_IN-1 downto 0) := "00000101";


Begin
-- device under test
dut: modular_exponentiation 
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
	wait for 1.5 * clk_period;


	REPORT "begin test case for A=12, B=2, N=5";
	REPORT "expected output is 4 00001000";
	N_in <= NUM_12;
	Exp_in <= NUM_2;
	M_in <= N_5;
	wait for 1 * clk_period;
	ASSERT(C_out = "00001000") REPORT "test passed" SEVERITY NOTE;
	ASSERT(C_out /= "00001000") REPORT "test failed" SEVERITY ERROR;

	wait;

end process;
end;
