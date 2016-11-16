library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;
use work.CONFIG_MANDELBROT.all;
use WORK.FUNCTIONS.ALL;

use IEEE.NUMERIC_STD.ALL;


entity increment is
	Port ( clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		start : in  STD_LOGIC;
		x_start : in STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		y_start : in STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		step : in STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		y : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x2 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x3 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x4 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x5 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x6 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x7 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		x8 : out  STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		stop : out std_logic);
end increment;

architecture Behavioral of increment is

signal xs, ys : signed(XY_RANGE-1 downto 0);
signal xcount : integer range 0 to XRES-1:=0;
signal ycount : integer range 0 to YRES-1:=0;

begin

process(clock, reset,start,x_start,y_start,step)
begin
if reset='1' then 
	xcount<=0;
	ycount<=0;
	xs<= signed(x_start);
	ys<= signed(y_start);
	stop<='0';
elsif rising_edge(clock) then
	if(start='1') then
	if xcount >= XRES-8 then
		if ycount >= YRES-1 then
			xcount <= 0;
			ycount <= 0;
			xs<=signed(x_start);
			ys<=signed(y_start);
			stop<='1';
		else
			xcount <= 0;
			ycount <= ycount+1;
			ys<=ys+signed(step);
			xs<=signed(x_start);
			stop<='0';
		end if;
	else
			stop<='0';
			xs<=xs+(signed(step) sll 3);
			xcount<=xcount+8;
		end if;
	end if;
end if;
end process;



x<=std_logic_vector(xs);
y<=std_logic_vector(ys);
x2 <= std_logic_vector(xs + signed(step));
x3 <= std_logic_vector(xs + mult(signed(step),X"20000000",FIXED));
x4 <= std_logic_vector(xs + mult(signed(step),X"30000000",FIXED));
x5 <= std_logic_vector(xs + mult(signed(step),X"40000000",FIXED));
x6 <= std_logic_vector(xs + mult(signed(step),X"50000000",FIXED));
x7 <= std_logic_vector(xs + mult(signed(step),X"60000000",FIXED));
x8 <= std_logic_vector(xs + mult(signed(step),X"70000000",FIXED));

end Behavioral;