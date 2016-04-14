-- Entity name: modular_exponentiation
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 28th, 2016
-- Description:
-- Module responsible of performing encryption and decryption. It uses the
-- montgomery_comparison.vhd to perform multiplication and modulo operations.


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lpm;
use lpm.lpm_components.all;


entity mod_exp_comparison is

	generic(WIDTH_IN : integer := 32
	);
	port(	
		   N :	  in unsigned(WIDTH_IN-1 downto 0); --Number
		   --Exp :	  in unsigned(WIDTH_IN-1 downto 0); --Exponent
		   --M :	  in unsigned(WIDTH_IN-1 downto 0); --Modulus
		   enc_dec:  in std_logic;
		   clk :	  in std_logic;
		   reset :	  in std_logic;
		   C : 	  out unsigned(WIDTH_IN-1 downto 0) 
	);
end entity;

architecture behavior of mod_exp_comparison is 

constant zero : unsigned(WIDTH_IN-1 downto 0) := (others => '0');

--------------------------------------32 bit constants------------------------------------------------
--constant K : unsigned (WIDTH_IN-1 downto 0) := "00000110010001101110000100100000101111011101110010111101100011001010101111001011011010101000010100001011000100011101101000011110";
constant M : unsigned (WIDTH_IN-1 downto 0) := "10000100010001111000010010000101";
constant dec_Exp : unsigned(WIDTH_IN-1 downto 0) := "00101010110001011001000101000101";
constant enc_Exp : unsigned(WIDTH_IN-1 downto 0) := "00000000000000010000000000000001";
-------------------------------------------------------------------------------------------------------

signal temp_A1,temp_A2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_B1, temp_B2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_d_ready, temp_d_ready2 : std_logic := '0';
signal temp_M1, temp_M2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

signal latch_in, latch_in2 : std_logic := '0';

signal temp_M : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_C : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');

type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
signal state: STATE_TYPE := s0;

component montgomery_comparison
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
end component;

begin


mont_mult_1: montgomery_comparison
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A1, 
		B => temp_B1, 
		N => temp_M,
		latch => latch_in, 
		clk => clk, 
		reset => reset,
		data_ready => temp_d_ready, 
		M => temp_M1 
		);

mont_mult_2: montgomery_comparison
	generic map(WIDTH_IN => WIDTH_IN)
	port map(
		A => temp_A2, 
		B => temp_B2, 
		N => temp_M, 
		latch => latch_in2, 
		clk => clk, 
		reset => reset,
		data_ready => temp_d_ready2,  
		M => temp_M2 
		);


C <= temp_C;

sqr_mult : Process(clk, reset, N)

variable count : integer := 0;
variable shift_count : integer := 0;
variable temp_N : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable P : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable P_old : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable R : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable temp_Exp : unsigned(WIDTH_IN-1 downto 0);
variable temp_mod : unsigned(WIDTH_IN-1 downto 0);

begin

if reset = '1' then
	count := 0;
	shift_count := 0;
	temp_N := (others => '0');
	P := (others => '0');
	R := (others => '0');
	temp_Exp := (others => '0');
	temp_mod := (others => '0');	
	temp_M <= (others => '0');
	
	state <= s0;
	
elsif rising_edge(clk) then

case state is 
	
	when s0 =>
	
	--(M = zero) OR (Exp = zero) OR
	if((N = zero)) OR ((temp_M = M)  AND (temp_N = N)) then
		state <= s0;
	else
		
		temp_mod := M;
		state <= s1;
	end if;

	when s1 =>
	
	if(temp_mod(WIDTH_IN-1) = '1')then	
		if(enc_dec = '1')then
			temp_Exp := enc_Exp;
		else
			temp_Exp := dec_Exp;
		end if;
		--temp_Exp := Exp;
		temp_M <= M;
		temp_N := N;
		state <= s2;
	else
		temp_mod := (shift_left(temp_mod,natural(1)));
		shift_count := shift_count + 1;
		state <= s1;
	end if;

	when s2 =>
		P_old := temp_N;
		R := to_unsigned(1,WIDTH_IN);
		state <= s3;

	when s3 =>
		temp_A1 <= P_old;
		temp_B1 <= P_old;
		latch_in <= '1';

		if(temp_d_ready = '0')then
			state <= s4;
		end if;

	when s4 =>
	latch_in <= '0';
	
	if(temp_d_ready = '1')then
		P := temp_M1;
		if(temp_Exp(0) = '1')then
			state <= s5;
		else
			state <= s7;
		end if;
	end if;

	when s5 => 
		temp_A2 <= R;
		temp_B2 <= P_old;
		latch_in2 <= '1';

		if(temp_d_ready2 = '0')then
			state <= s6;
		end if;
		
	when s6 =>
		latch_in2 <= '0';
		if(temp_d_ready2 = '1') then
			R := temp_M2;
			state <= s7;
		end if;
	
	when s7 =>
		if (count = (WIDTH_IN-1)-shift_count) OR (temp_Exp = zero) then
			temp_C <= R;			
			state <= s8;
			
		else
			temp_Exp := (shift_right(temp_Exp, natural(1)));
			P_old := P;
			count := count + 1;
			state <= s3;
		end if;	
	
	when s8 =>
		count := 0;
		shift_count := 0;
		P := (others => '0');
		R := (others => '0');
		temp_mod := (others => '0');	
			
		state <= s0;

			
	end case;
end if;		

end process sqr_mult;
 
end behavior;  