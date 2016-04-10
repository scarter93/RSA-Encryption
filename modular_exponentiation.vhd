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

	generic(WIDTH_IN : integer := 8
	);
	port(	N :	  in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	  in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	  in unsigned(WIDTH_IN-1 downto 0); --Modulus
		clk :	  in std_logic;
		reset :	  in std_logic;
		C : 	  out unsigned(WIDTH_IN-1 downto 0) --Output
	);
end entity;

architecture behavior of modular_exponentiation is 

constant zero : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
signal one : unsigned(WIDTH_IN-1 downto 0);

signal temp_A1,temp_A2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_B1, temp_B2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_d_ready, temp_d_ready2 : std_logic := '0';
signal temp_M1, temp_M2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

signal latch_in, latch_in2 : std_logic := '0';

signal temp_M : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_C : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');

signal K_1 : unsigned(2*WIDTH_IN downto 0) := (others => '0');
signal K : std_logic_vector (WIDTH_IN-1 downto 0) := (others => '0'); --change to std_logic_vector

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

divide: LPM_DIVIDE
	generic map( 
		LPM_WIDTHN => 2*WIDTH_IN+1,
		LPM_WIDTHD => WIDTH_IN,
		LPM_PIPELINE => 2*WIDTH_IN+1 )
	port map(
		numer => std_logic_vector(K_1),
		denom => std_logic_vector(temp_M),
		clock => clk,
		remain => K
		);



--K <= K_1 mod temp_M;

C <= temp_C;

sqr_mult : Process(clk, reset, N, Exp, M)

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
	
	if((M = zero) OR (Exp = zero) OR (N = zero)) OR ((temp_M = M)  AND (temp_N = N)) then
		state <= s0;
	else
		
		temp_mod := M;
		state <= s1;
	end if;

	when s1 =>
	
	if(temp_mod(WIDTH_IN-1) = '1')then	
		K_1 <= shift_left(to_unsigned(1,2*WIDTH_IN+1),(2*(WIDTH_IN-shift_count)));
		temp_Exp := Exp;
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