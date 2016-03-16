-- Entity name: montgomery_multiplier
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: March 10th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
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

Signal M_temp : unsigned(WIDTH_IN downto 0) := (others => '0');
Signal temp : unsigned(WIDTH_IN downto 0) := (others => '0');
Signal temp_s : unsigned(WIDTH_IN downto 0) := (others => '0'); 
--Signal B_i : integer := 0;
Signal temp_i : std_logic := '0';
Signal state : integer := 0;
Signal count : integer := 0;
Signal B_reg : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal A_reg : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Signal B_zeros : unsigned(WIDTH_IN-1 downto 0) := (others => '0');
Begin


compute_M : Process(clk,latch,reset)
Begin
	if reset = '0' and rising_edge(clk) then
		case state is
			when 0 =>
				if latch = '1' then
					data_ready <= '0';
					M_temp <= (others => '0');
					count <= '0';
					B_reg <= B;
					A_reg <= A;
					state <= 1;
				end if;
			when 1 =>
				if B_reg(0) = '1'then
					if (M_temp(0) xor A_reg(0)) = '1' then
						M_temp <= unsigned(shift_right(unsigned(M_temp + A_reg), integer(1)));
					else
						M_temp <= unsigned(shift_right(unsigned(M_temp + A_reg + N), integer(1)));
					end if;
				else

					if M_temp(0) = '1' then
						M_temp <= unsigned(shift_right(unsigned(M_temp), integer(1)));
					else
						M_temp <= unsigned(shift_right(unsigned(M_temp + N), integer(1)));
					end if;
				end if;
				if count = WIDTH_IN-1 then
					state <= 2;
				else
					B_reg <= unsigned(shift_right(unsigned(B_reg), integer(1)));
					count <= count + 1;
					state <= 1;
				end if;
			when 2 =>
				M <= M_temp(WIDTH_IN-1 downto 0);
				data_ready <= '1';
				state <= 0;
			when others =>
				state <= 0;
			end case;
	end if;
--		temp <= M_temp + N;
--		M_temp <= unsigned(shift_right(unsigned(temp), integer(1)));

end Process;

end architecture;
