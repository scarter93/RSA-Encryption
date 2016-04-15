-- Entity name: montgomery_multiplier
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: March 10th, 2016
-- Description: Performs modular multiplication. See paper for more information. Designed for use with RSA Encryption. 

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity montgomery_multiplier is
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

architecture behavioral of montgomery_multiplier is
-- Signals
Signal M_temp : unsigned(WIDTH_IN+1 downto 0) := (others => '0');
Signal state : integer := 0;
Signal count : integer := 0;
Signal B_reg : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal A_reg : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal B_zeros : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal N_temp : unsigned(WIDTH_IN-1 downto 0);

Begin
-- Process to perform mod mult operation
compute_M : Process(clk,latch,reset)
Begin
	if reset = '0' and rising_edge(clk) then
		case state is
			when 0 =>
				-- latch data when latch high
				if latch = '1' then
					data_ready <= '0';
					M_temp <= (others => '0');
					count <= 0;
					B_reg <= B;
					A_reg <= A;
					N_temp <= N;
					state <= 1;
				end if;
			when 1 =>
				-- perform appropriate add and shift	
				-- check to see if we add B or not		
				if A_reg(0) = '1' then
					-- check to see if we add N and B
					if (M_temp(0) xor B_reg(0)) = '1' then
						M_temp <= unsigned(shift_right(unsigned(M_temp + B_reg + N), integer(1)));
					else
						M_temp <= unsigned(shift_right(unsigned(M_temp + B_reg), integer(1)));

					end if;
				else
					--check to see if we need to add modulus
					if M_temp(0) = '1' then
						M_temp <= unsigned(shift_right(unsigned(M_temp + N), integer(1)));
					else
						M_temp <= unsigned(shift_right(unsigned(M_temp), integer(1)));
					end if;
				end if;
				-- check to see if multiply is complete
				if N_temp = to_unsigned(integer(1), WIDTH_IN) then
					state <= 2;
				else
					state <= 1;
				end if;
				-- Update the A and N value used to update values
				N_temp <= unsigned(shift_right(unsigned(N_temp), integer(1)));
				A_reg <= unsigned(shift_right(unsigned(A_reg), integer(1)));
				
			when 2 =>
				--update output values and return to default state
				if( M_temp > N) then
					M <= M_temp(WIDTH_IN-1 downto 0) - N;
				else
					M <= M_temp(WIDTH_IN-1 downto 0);
				end if;
				data_ready <= '1';
				state <= 0;
			when others =>
				state <= 0;
			end case;
	end if;
end Process;
end architecture;
