-- Entity name: modular_exponentiation
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 8th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library lpm;
use lpm.lpm_components.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
--use work.mod_exp_package.all;


entity modular_exponentiation is

	generic(WIDTH_IN : integer := 128
	);
	port(	N :	  in unsigned(WIDTH_IN-1 downto 0); --Number
		Exp :	  in unsigned(WIDTH_IN-1 downto 0); --Exponent
		M :	  in unsigned(WIDTH_IN-1 downto 0); --Modulus
		--latch_in: in std_logic;
		clk :	  in std_logic;
		reset :	  in std_logic;
		C : 	  out unsigned(WIDTH_IN-1 downto 0) --Output
		--C : out std_logic
	);
end entity;

architecture behavior of modular_exponentiation is 


signal temp_A1,temp_A2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_B1, temp_B2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
signal temp_d_ready, temp_d_ready2 : std_logic := '0';
signal temp_M1, temp_M2 : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');

signal latch_in, latch_in2 : std_logic := '0';

signal temp_M : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
--signal temp_Exp : unsigned(WIDTH_IN-1 downto 0);
signal temp_C : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
--signal temp_C : std_logic;
signal K_1 : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
signal K : std_logic_vector (WIDTH_IN-1 downto 0) := (others => '0');

type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7);
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
		LPM_WIDTHN => WIDTH_IN,
		LPM_WIDTHD => WIDTH_IN )
	port map(
		numer => std_logic_vector(K_1),
		denom => std_logic_vector(temp_M),
		remain => K
		);



C <= temp_C;

sqr_mult : Process(clk, reset, N, Exp, M)

variable index : integer := 0;
variable count : integer := 0;
variable y : integer range 0 to 3;
variable z : integer range 0 to 1;
variable temp_N : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable P : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable R : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
variable temp_K_1 : unsigned(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
--variable temp_M : unsigned(WIDTH_IN-1 downto 0) := (WIDTH_IN-1 downto 0 => '0');
variable temp_Exp : unsigned(WIDTH_IN-1 downto 0);

begin

if reset = '1' then

--		--temp_N <= (others => '0');
--		temp_A1 <= (others => '0');
--		temp_B1 <= (others => '0');
--		temp_A2 <= (others => '0');
--		temp_B2 <= (others => '0');
--		temp_M <= (others => '0');
--		temp_M1 <= (others => '0');
--		temp_M2 <= (others => '0');
--		temp_C <= (others => '0');	
		--temp_C <= '0';
elsif rising_edge(clk) then

case state is 
	
	when s0 =>
	
	temp_K_1 := shift_left(to_unsigned(2,WIDTH_IN),(2*WIDTH_IN));
	
	if(((to_integer(M)/=0) OR (to_integer(Exp)/=0)) AND (to_integer(temp_K_1)/= 0)) then
		temp_M <= M;
		K_1 <= temp_K_1;
		temp_Exp := Exp;
		temp_N := N;
		state <= s1;
	else
		state <= s0;
	end if;

	when s1 => 
	
	if(to_integer(unsigned(K)) /= 0)then
		temp_A1 <= unsigned(K);
		temp_B1 <= temp_N;
	
		temp_A2 <= unsigned(K);
		temp_B2 <= to_unsigned(1,WIDTH_IN);	
	
		latch_in <= '1';
		latch_in2 <= '1';
		
		state <= s2;
	else
		state <= s1;
	end if;

	when s2 =>
	latch_in <= '0';
	latch_in2 <= '0';
	
		if((temp_d_ready = '1') AND (temp_d_ready2 = '1')) then
			P := temp_M1;
			R := temp_M2;
			state <= s3;
		else
			state <= s2;
		end if;
		
	
--	if((to_integer(M)/=0) OR (to_integer(Exp)/=0)) then
--		temp_M <= M;
--		temp_Exp := Exp;
--		state <= s1;
--	else
--		state <= s0;
--	end if;
	
--	when s1=>
--		if temp_Exp(WIDTH_IN-1) = '1' then
--			temp_N := N;
--			temp_Exp := (shift_left(temp_Exp, natural(1)));
--			count := count + 1;
--			state <= s2;
--		else
--			temp_N := to_unsigned(1, WIDTH_IN);				
--			temp_Exp := (shift_left(temp_Exp, natural(1)));
--			count := count + 1;
--			state <= s2;
--		end if;
	
	when s3 =>
		temp_A1 <= P;
		temp_B1 <= P;
		latch_in <= '1';
		state <= s4;
	
	when s4 =>
		latch_in <= '0';

		if(temp_d_ready = '1') then
			
			if(temp_Exp(WIDTH_IN -1) = '1') then
				temp_A1 <= temp_M1;
				temp_B1 <= R;
				latch_in <= '1';
				state <= s5;
			else 
				P := temp_M1;
				state <= s6;
			end if;
		else
			state <= s4;
		end if;
	
	
	when s5 => 
		latch_in <= '0';

		if(temp_d_ready = '1') then
			P := temp_M1;
			state <= s6;
		else
			state <= s5;	
		end if;
				
	when s6 =>
		if count = WIDTH_IN-1 then
				--temp_C <= temp_M1;
			temp_A1 <= to_unsigned(1,WIDTH_IN);
			temp_B1 <= R;
			latch_in <= '1';
			state <= s7;	
		else
			temp_Exp := (shift_left(temp_Exp, natural(1)));
			count := count + 1;
			state <= s3;
		end if;	
	
	when s7 =>
		latch_in <= '0';
		if(temp_d_ready = '1') then
			temp_C <= temp_M1;
		else
			state <= s7;
		end if;
			
		--state <= s0;
	end case;
end if;		

end process sqr_mult;
 
end behavior; 