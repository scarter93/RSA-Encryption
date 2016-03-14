-- Entity name: montgomery_multiplier
-- Author: Stephen Carter
-- Contact: stephen.carter@mail.mcgill.ca
-- Date: March 10th, 2016
-- Description:

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity montgomery_multiplier is
	Generic(WIDTH_IN : integer := 128
	);
	Port(	A :	in std_logic_vector(WIDTH_IN-1 downto 0);
		B :	in std_logic_vector(WIDTH_IN-1 downto 0);
		N :	in std_logic_vector(WIDTH_IN-1 downto 0);
		latch : in std_logic;
		clk :	in std_logic;
		reset :	in std_logic;
		d_ready : out std_logic;
		M : 	out std_logic_vector(WIDTH_IN-1 downto 0)
	);
end entity;

architecture behavioral of montgomery_multiplier is

signal m_reg: std_logic_vector(WIDTH_IN-1 downto 0):= (WIDTH_IN-1 downto 0 => '0');
signal shift_reg, shift_reg1, shift_reg2: std_logic_vector(WIDTH_IN+1 downto 0):= (WIDTH_IN+1 downto 0 => '0');
signal mod_reg1, mod_reg2: std_logic_vector(WIDTH_IN+1 downto 0):= (WIDTH_IN+1 downto 0 => '0');
signal result_reg, result_reg1, result_reg2, result_reg3, result_reg4: std_logic_vector(WIDTH_IN+1 downto 0):= (WIDTH_IN+1 downto 0 => '0');

signal current_mod : std_logic_vector(1 downto 0):= (1 downto 0 => '0');;
signal first: std_logic;

Begin

M <= result_reg4(WIDTH_IN-1 downto 0);

with m_reg(0) select
	result_reg1 <= 	result_reg + shift_reg when '1',
			result_reg when others;
result_reg2 <= result_reg1 - mod_reg1;
result_reg3 <= result_reg1 - mod_reg2;

current_mod <= result_reg3(WIDTH_IN+1) & result_reg2(WIDTH_IN+1);

with current_mod select
	result_reg4 <= 	result_reg1 when "11",
			result_reg2 when "10",
			result_reg3 when others;

shift_reg1 <= shift_reg -mod_reg1;

with shift_reg1(WIDTH_IN) select
	shift_reg2 <= 	shift_reg when '1',
			shift_reg1 when others;

d_ready <= first;


compute_M : Process(clk, reset, first, Latch, m_reg)
Begin
	if reset = '1' then
		first <= '1';
	elsif(rising_edge(clk) and reset = '0') then
		if first = '1' then
			if latch = '1' then
				m_reg <= B;
				shift_reg <= "00" & A;
				mod_reg1 <= "00" & N;
				mod_reg2 <= '0' & N & '0';
				result_reg <= (others => '0');
				first <= '0';
			end if;
		else
		-- when all bits have been shifted out of the multiplicand, operation is over
		-- Note: this leads to at least one waste cycle per multiplication
			if m_reg = 0 then
				first <= '1';
			else
			-- shift the multiplicand left one bit
				shift_reg <= shift_reg2(WIDTH_IN downto 0) & '0';
			-- shift the multiplier right one bit
				m_reg <= '0' & m_reg(WIDTH_IN-1 downto 1);
			-- copy intermediate product
				result_reg <= result_reg4;
			end if;
		end if;
	end if;

end Process;

end architecture;
