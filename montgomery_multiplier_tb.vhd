-- Entity name: montgomery_multiplier_tb
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: March 8th, 2015
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity montgomery_multiplier_tb is
end entity;

architecture test of montgomery_multiplier_tb is
-- define the ALU compontent to be tested
Component montgomery_multiplier is
 	Generic(
		WIDTH_IN : integer := 8
	);
	Port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned(WIDTH_IN-1 downto 0);
		latch : in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end component;

CONSTANT WIDTH_IN : integer := 8;

CONSTANT clk_period : time := 1 ns;

Signal N_in : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal A_in : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal B_in : unsigned(WIDTH_IN-1 downto 0) := (others => '0');

Signal clk : std_logic := '0';
Signal reset_t : std_logic := '0';
Signal latch_in : std_logic := '0';

Signal M_out : unsigned(WIDTH_IN-1 downto 0) := (others => '0');

CONSTANT NUM_12 : unsigned(WIDTH_IN-1 downto 0) := "00000010";
CONSTANT NUM_2	: unsigned(WIDTH_IN-1 downto 0) := "00000010";
CONSTANT N_5	: unsigned(WIDTH_IN-1 downto 0) := "00000101";


Begin
-- device under test
dut: montgomery_multiplier PORT MAP(	A	=> 	A_in,
					B 	=> 	B_in,
					N 	=> 	N_in,
					latch	=>	latch_in,
					clk	=> 	clk,
					reset 	=>	reset_t,
					M	=>	M_out);
  
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


	REPORT "begin test case for A=12, B=2, N=5";
	REPORT "expected output is 4 00000100";
	A_in <= NUM_12;
	B_in <= NUM_2;
	N_in <= N_5;
	latch_in <= '1';
	wait for 2 * clk_period;
	latch_in <= '0';
	wait for 4 * clk_period;
	ASSERT(M_out = "00000100") REPORT "test failed" SEVERITY ERROR;

	wait;

end process;
end architecture;