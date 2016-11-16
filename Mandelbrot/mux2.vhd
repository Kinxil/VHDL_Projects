
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.CONSTANTS.all;
use work.CONFIG_MANDELBROT.all;

entity muxandcpt is
    Port ( clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		i_iters1 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters2 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters3 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters4 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters5 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters6 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters7 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		i_iters8 : in  STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		startVGA : in  STD_LOGIC;
		o_iters : out STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		doneVGA : out STD_LOGIC);
end muxandcpt;

architecture Behavioral of muxandcpt is

signal cpt : integer range 0 to 7;

begin
	process(clock, reset, startVGA, cpt)
	begin
		if reset='1' then
			cpt <= 0;
			doneVGA <= '0';
		elsif rising_edge(clock) then
			if startVGA='1' then
				if(cpt=7) then
					cpt<=0;
					doneVGA<='1';
				else
					cpt <= cpt + 1;
					doneVGA<='0';
				end if;
			end if;
		end if;
	end process;

	o_iters <= i_iters7 when (cpt = 7) else 
	i_iters6 when (cpt = 6) else 
	i_iters5 when (cpt = 5) else 
	i_iters4 when (cpt = 4) else 
	i_iters3 when (cpt = 3) else 
	i_iters2 when (cpt = 2) else 
	i_iters1 when (cpt = 1) else 
	i_iters8;

end Behavioral;

