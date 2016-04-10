-- Entity name: modular_exponentiation
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

----------------------------------------------------------
-- Not sure if the variables need to be reset, 
-- I think they get reset every time we access the process
----------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lpm;
use lpm.lpm_components.all;


entity modular_exponentiation is

	generic(WIDTH_IN : integer := 512
	);
	port(	N :	  in unsigned(WIDTH_IN-1 downto 0); --Number
		--Exp :	  in unsigned(WIDTH_IN-1 downto 0); --Exponent
		--M :	  in unsigned(WIDTH_IN-1 downto 0); --Modulus
		enc_dec:  in std_logic;
		clk :	  in std_logic;
		reset :	  in std_logic;
		C : 	  out unsigned(WIDTH_IN-1 downto 0) --Output
	);
end entity;

architecture behavior of modular_exponentiation is 

constant zero : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
signal one : unsigned(WIDTH_IN-1 downto 0);


--constant K : unsigned (WIDTH_IN-1 downto 0) := "01010110000011111111111011010011010101100101010111100001110011001110110111000001111011011000011011000010010111101001000101000001"; --change to std_logic_vector

------------------------------------128 bit constants------------------------------------------------
--constant K : unsigned (WIDTH_IN-1 downto 0) := "00000110010001101110000100100000101111011101110010111101100011001010101111001011011010101000010100001011000100011101101000011110";
--constant M : unsigned (WIDTH_IN-1 downto 0) := "10000100010001111000010010000101100100110110101010010001101011001100101110000000001011000101001110000111011101010010011111010001";
--constant dec_Exp : unsigned(WIDTH_IN-1 downto 0) := "00101010110001011001000101000101001110111100100001111110101101000110111111011111100000001110100100110111010101101011010111000001";
--constant enc_Exp : unsigned(WIDTH_IN-1 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000001";
-------------------------------------------------------------------------------------------------------

------------------------------------256 bit constants------------------------------------------------
--constant K : unsigned (WIDTH_IN-1 downto 0) := "0000101101110010100110101100001100101001101001111100011111101000011000101001011001001110110101000001110010010010110001100111001111100100010101001011111110111011111000111100011011101001010001101001011000100000011101110000101101010010100110001110010001001100";
--constant M : unsigned (WIDTH_IN-1 downto 0) := "1001010000001011000100100011011110000011010001100011101100010101010001101101100111111101101100110101101111101011000010101101111101001001011010101011110111000100100101000011101110001111010010000110101011011000011111010110111001010111001101100011101010000011";
--constant dec_Exp : unsigned(WIDTH_IN-1 downto 0) := "0011001000110111010001110010100010011001010110001011101100110101110011100110000010100111000100111010110110111100000111100001111101010111110101000010000111110110111111011101010001100011111000011111101111000110100110110101111111110010100000111111100100100001";
--constant enc_Exp : unsigned(WIDTH_IN-1 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000001";
-------------------------------------------------------------------------------------------------------

-----------------------------------512 bit constants------------------------------------------------
constant K : unsigned (WIDTH_IN-1 downto 0) := "01000001000100010101100011101011101101011111101101111100001011010111110011010011000111000011011001011101011110011110101110110010011100011010111001110111101110000010100001001011101100000001010010010001010100010110010000111000011111111100000000011000111011010000100010000010110010001000010000001101110010010001001001100110100100110000010010000101011101111110000111001010111001000001110110100110000000100000110001000001011000111001010111111101010111111100011100100000100010100100010000110000011110101000010101111011";
constant M : unsigned (WIDTH_IN-1 downto 0) := "10000011010000010011110100010110101100001100010010011111110101011001010111110100011000111101001110110100010101111110010110101001010000100101110110110011010111100111100001101010111001100011010001001001100001011011110101100000110011101001110010101101000100000011000100000111010000000001010000100101001011111111101010110100110011101100011000111011110100110001111010000101100000101010111110111001101100111110001001000111011101101110000111100100011010111000000011110110010110111000101111000111100100000000000001011011";
constant enc_Exp : unsigned(WIDTH_IN-1 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000001";
constant dec_Exp : unsigned(WIDTH_IN-1 downto 0) := "00100001111011111100111101001100101110111001110111001011001110011101110101010000110110000011001011010111110100010101011000110111010000100100101010011001111000110001011000111101100001011001001000000101011001001000100000000111101011001100010000010110100100011111010101111100011101111001100011001001101001100111111011101011010110110111011110011010011000100011100111100000111001001101001111011111100011101010000010011111010111101011101101010111001100100111000111011111101101011110010011001000111011000111111110001001";
-----------------------------------------------------------------------------------------------------

signal temp_A1,temp_A2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_B1, temp_B2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_d_ready, temp_d_ready2 : std_logic := '0';
signal temp_M1, temp_M2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

signal latch_in, latch_in2 : std_logic := '0';

signal temp_M : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_C : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');

signal K_1 : unsigned(2*WIDTH_IN downto 0) := (others => '0');
--signal K : unsigned (WIDTH_IN-1 downto 0) := (others => '0'); --change to std_logic_vector

type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
signal state: STATE_TYPE := s0;

component montgomery_multiplier
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

one <= zero(WIDTH_IN-1 downto 1) & '1';	

mont_mult_1: montgomery_multiplier
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

mont_mult_2: montgomery_multiplier
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

--divide: LPM_DIVIDE
--	generic map( 
--		LPM_WIDTHN => 2*WIDTH_IN+1,
--		LPM_WIDTHD => WIDTH_IN,
--		LPM_PIPELINE => 2*WIDTH_IN+1 )
--	port map(
--		numer => std_logic_vector(K_1),
--		denom => std_logic_vector(temp_M),
--		clock => clk,
--		remain => K
--		);
--



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
	K_1 <= (others => '0');	

	state <= s0;
	
elsif rising_edge(clk) then

case state is 
	
	when s0 =>
	--(M = zero) OR (Exp = zero) OR
	if( (N = zero)) OR ((temp_M = M)  AND (temp_N = N)) then
		state <= s0;
	else
		
		temp_mod := M;
		state <= s1;
	end if;

	when s1 =>
	
	if(temp_mod(WIDTH_IN-1) = '1')then	
		K_1 <= shift_left(to_unsigned(1,2*WIDTH_IN+1),(2*(WIDTH_IN-shift_count)));
		
		if(enc_dec = '1')then
			temp_Exp := enc_Exp;
		else
			temp_Exp := dec_Exp;
		end if;
	
		temp_M <= M;
		temp_N := N;
		state <= s2;
	else
		temp_mod := (shift_left(temp_mod,natural(1)));
		shift_count := shift_count + 1;
		state <= s1;
	end if;

	when s2 => 
	
	if(unsigned(K) > zero)then
		temp_A1 <= unsigned(K);
		temp_B1 <= temp_N;
	
		temp_A2 <= unsigned(K);
		temp_B2 <= to_unsigned(1,WIDTH_IN);	
	
		latch_in <= '1';
		latch_in2 <= '1';
		
		if(temp_d_ready = '0') AND (temp_d_ready2 = '0')then
			state <= s3;
		end if;
	else
		state <= s2;
	end if;

	when s3 =>
	latch_in <= '0';
	latch_in2 <= '0';
	
	if((temp_d_ready = '1') AND (temp_d_ready2 = '1')) then
		P_old := temp_M1;
		R := temp_M2;
		state <= s4;
	end if; 


	when s4 =>
		temp_A1 <= P_old;
		temp_B1 <= P_old;
		latch_in <= '1';

		if(temp_d_ready = '0')then
			state <= s5;
		end if;

	when s5 =>
	latch_in <= '0';
	
	if(temp_d_ready = '1')then
		P := temp_M1;
		if(temp_Exp(0) = '1')then
			state <= s6;
		else
			state <= s8;
		end if;
	end if;

	when s6 => 
		temp_A2 <= R;
		temp_B2 <= P_old;
		latch_in2 <= '1';

		if(temp_d_ready2 = '0')then
			state <= s7;
		end if;
		
	when s7 =>
		latch_in2 <= '0';
		if(temp_d_ready2 = '1') then
			R := temp_M2;
			state <= s8;
		end if;
	
	when s8 =>
		if (count = (WIDTH_IN-1)-shift_count) OR (temp_Exp = (zero)) then
			temp_A1 <= to_unsigned(1,WIDTH_IN);
			temp_B1 <= R;			
			state <= s9;
			
		else
			temp_Exp := (shift_right(temp_Exp, natural(1)));
			P_old := P;
			count := count + 1;
			state <= s4;
		end if;	
	
	when s9 =>
		
		latch_in <= '1';
		if(temp_d_ready ='0')then
			state <= s10;
		end if;

	when s10 =>
		latch_in <= '0';
		if(temp_d_ready = '1') then
			temp_C <= temp_M1;
			temp_Exp := (others => '0');
			count := 0;
			shift_count := 0;
			P := (others => '0');
			R := (others => '0');
			temp_mod := (others => '0');	
			K_1 <= (others => '0');		
			
			state <= s0;
		end if;
		
	end case;
end if;		

end process sqr_mult;
 
end behavior;  