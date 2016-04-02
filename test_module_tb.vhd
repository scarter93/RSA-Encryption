library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.math_real.all;
library lpm;
use lpm.lpm_components.all;

entity test_module_tb is
	
end entity;

architecture test of test_module_tb is

CONSTANT WIDTH_IN : integer := 8;

CONSTANT clk_period : time := 1 ns;

signal N_in : integer;
signal Exp_in : real;
signal M_in : unsigned(WIDTH_IN-1 downto 0);
signal clk_in : std_logic;
signal reset_in : std_logic;
signal C_out : unsigned(WIDTH_IN-1 downto 0);

component test_module is
	Generic( WIDTH_IN : integer := 8
	);
	Port(	N :	  in integer; --Number
		Exp :	  in real; --Exponent
		M :	  in unsigned(WIDTH_IN-1 downto 0); --Modulus
		--latch_in: in std_logic;
		clk :	  in std_logic;
		reset :	  in std_logic;
		C : 	  out unsigned(WIDTH_IN-1 downto 0)
	);
end component;

begin

dut : test_module PORT MAP(N=>N_in, Exp=>Exp_in, M => M_in, clk => clk_in, reset => reset_in, C => C_out);

clk_process : Process
Begin
	clk_in <= '0';
	wait for clk_period/2;
	clk_in <= '1';
	wait for clk_period/2;
end process;

stim_process: process
Begin

	N_in <= integer(9);
	Exp_in <= real(7);
	M_in <= "10001111";
	reset_in <= '0';
	wait for 9 * clk_period;
	wait;
end process;

end architecture;
