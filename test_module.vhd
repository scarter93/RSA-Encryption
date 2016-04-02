library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.math_real.all;
library lpm;
use lpm.lpm_components.all;

entity test_module is
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
end entity;


architecture structural of test_module is

signal result : real;
signal result2 : unsigned(WIDTH_IN*WIDTH_IN-1 downto 0);
begin


--divide: LPM_DIVIDE
--	generic map( 
--		LPM_WIDTHN => 2*WIDTH_IN,
--		LPM_WIDTHD => WIDTH_IN 
--	);
--	port map(
--		numer => ,
--		denom => ,
--		remain => 
--	);
--
--
-- mult : LPM_MULT
-- generic(LPM_WIDTHA : WIDTH_IN;
-- 	LPM_WIDTHB : WIDTH_IN;
-- 	LPM_WIDTHS : natural := 1;
-- 	LPM_WIDTHP : 2*WIDTH_IN;
--	LPM_REPRESENTATION : string := "UNSIGNED";
--	LPM_TYPE: string := L_MULT;
--	LPM_HINT : string := "UNUSED"
--	);
--	port(DATAA : in std_logic_vector(LPM_WIDTHA-1 downto 0);
--	DATAB : in std_logic_vector(LPM_WIDTHB-1 downto 0);
--	ACLR : in std_logic := '0';
--	CLOCK : in std_logic := '0';
--	CLKEN : in std_logic := '1';
--	SUM : in std_logic_vector(LPM_WIDTHS-1 downto 0) := (OTHERS => '0');
--	RESULT : out std_logic_vector(LPM_WIDTHP-1 downto 0)
--);
--

result <= N**Exp;
result2 <= to_unsigned(integer(result), WIDTH_IN*WIDTH_IN);
C <= result2 mod M;


end architecture;