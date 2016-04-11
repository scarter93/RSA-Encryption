-- Entity name: montgomery_comparison
-- Author: Jacob Barnett
-- Contact: jacob.barnett@mail.mcgill.ca
-- Date: March 28th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
library lpm;
use lpm.lpm_components.all;

entity montgomery_comparison is
	Generic(WIDTH_IN : integer := 8
	);
	Port(	A :	in unsigned(WIDTH_IN-1 downto 0);
		B :	in unsigned(WIDTH_IN-1 downto 0);
		N :	in unsigned(WIDTH_IN-1 downto 0);
		latch : in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		data_ready : out std_logic;
		M : 	out unsigned(WIDTH_IN-1 downto 0)
	);
end entity;

architecture behavioral of montgomery_comparison is

signal A_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal B_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal N_temp : unsigned(WIDTH_IN-1 downto 0):= (others => '0');
signal M_temp : std_logic_vector(WIDTH_IN-1 downto 0):= (others => '0');

signal M_out : unsigned(WIDTH_IN-1 downto 0):= (others => '0');


signal zero : unsigned(WIDTH_IN-1 downto 0) := (others => '0');

signal mult_result : std_logic_vector(2*WIDTH_IN-1 downto 0);
signal temp_mult_result : std_logic_vector(2*WIDTH_IN-1 downto 0);

signal state : integer := 0;

Begin
  
M <= M_out;

 --mult : LPM_MULT
	--generic(
	-- 	LPM_WIDTHA : WIDTH_IN;
	-- 	LPM_WIDTHB : WIDTH_IN;
	-- 	LPM_WIDTHS : natural := 1;
	-- 	LPM_WIDTHP : 2*WIDTH_IN;
	--	LPM_REPRESENTATION : string := "UNSIGNED";
	--	LPM_TYPE: string := L_MULT;
	--	LPM_HINT : string := "UNUSED"
	--	);
	--port(
	--	DATAA : in std_logic_vector(LPM_WIDTHA-1 downto 0);
	--	DATAB : in std_logic_vector(LPM_WIDTHB-1 downto 0);
	--	ACLR : in std_logic := '0';
	--	CLOCK : in std_logic := '0';
	--	CLKEN : in std_logic := '1';
	--	SUM : in std_logic_vector(LPM_WIDTHS-1 downto 0) := (OTHERS => '0');
	--	RESULT : out std_logic_vector(LPM_WIDTHP-1 downto 0)
	--);

	mult: LPM_MULT
		generic map(
			LPM_WIDTHA => WIDTH_IN,
			LPM_WIDTHB => WIDTH_IN,
			LPM_WIDTHP => 2*WIDTH_IN
		)
		port map(
			DATAA => std_logic_vector(A_temp),
			DATAB => std_logic_vector(B_temp),
			CLOCK => clk,
			RESULT => mult_result
		);

	divide: LPM_DIVIDE
		generic map( 
			LPM_WIDTHN => 2*WIDTH_IN,
			LPM_WIDTHD => WIDTH_IN 
		)
		port map(
			numer => temp_mult_result,
			denom => std_logic_vector(N_temp),
			remain => M_temp
		);

	compute: process(clk, A, B, N, latch, reset)
	Begin
		if reset = '0' and rising_edge(clk) then
			case state is
				when 0 =>
					if latch = '1' then
						data_ready <= '0';
						--M_temp <= (others =>'0');
						--count <= 0;
						--q <= 0;
						B_temp <= B;
						A_temp <= A;
						N_temp <= N;
						temp_mult_result <= mult_result;
						state <= 1;
					end if;
		
				when 1 =>

					if(unsigned(M_temp) = zero)then
						data_ready <= '0';
						state <= 1;
					else
						data_ready <='1';
						M_out <= unsigned(M_temp);
						state <= 0;
					end if;		

				when others =>
					state <= 0;
		end case;
	end if;
end process;



end architecture;
