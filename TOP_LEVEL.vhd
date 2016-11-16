library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;


entity TOP_LEVEL is
    Port ( clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		inib : in std_logic;
		bleft : in STD_LOGIC;
		bright : in STD_LOGIC;
		bup : in STD_LOGIC;
		bdwn : in STD_LOGIC;
		bctr : in STD_LOGIC;
		maxiter : in STD_LOGIC;
		VGA_hs       : out std_logic;   -- horisontal vga syncr.
		VGA_vs       : out std_logic;   -- vertical vga syncr.
		VGA_red      : out std_logic_vector(3 downto 0);   -- red output
		VGA_green    : out std_logic_vector(3 downto 0);   -- green output
		VGA_blue     : out std_logic_vector(3 downto 0);       
		data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0));
end TOP_LEVEL;

architecture Behavioral of TOP_LEVEL is
component cpt_iter
    Port ( clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;		
		inib : in std_logic;
		endcalcul : in  STD_LOGIC;
		maxiter : in STD_LOGIC;
		iter : out  STD_LOGIC_VECTOR(ITER_RANGE-1 downto 0));
end component;

component Colorgen 
    Port ( iters : in STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		itermax : in STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		color : out STD_LOGIC_VECTOR (bit_per_pixel-1 downto 0));
end component;

component FSM is
    Port ( clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		b_done : in STD_LOGIC_VECTOR (7 downto 0);
		stop : in std_logic;
		doneVGA : in std_logic;
		start : out STD_LOGIC;
		startVGA : out STD_LOGIC);
end component;

component Iterator 
    Port ( go : in STD_LOGIC;
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		x0 : in STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		y0 : in STD_LOGIC_VECTOR (XY_RANGE-1 downto 0);
		itermax : in std_logic_vector(ITER_RANGE-1 downto 0);
		iters : out STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
		done : out STD_LOGIC);
end component;

component increment is
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
end component;

component VGA_bitmap_640x480
  generic(grayscale     : boolean := false);           -- should data be displayed in grayscale
  port(clk          : in  std_logic;
		reset        : in  std_logic;
		VGA_hs       : out std_logic;   -- horisontal vga syncr.
		VGA_vs       : out std_logic;   -- vertical vga syncr.
		VGA_red      : out std_logic_vector(3 downto 0);   -- red output
		VGA_green    : out std_logic_vector(3 downto 0);   -- green output
		VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output

		-- ADDR         : in  std_logic_vector(13 downto 0);     
		endcalcul : in std_logic;

		data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0);
		data_write   : in  std_logic;
		data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0));
end component;

component Zoom
	port ( bleft : in STD_LOGIC;
		bright : in STD_LOGIC;
		bup : in STD_LOGIC;
		bdwn : in STD_LOGIC;
		bctr : in STD_LOGIC;
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		ce_param : in STD_LOGIC;
		x_start : out STD_LOGIC_VECTOR(XY_RANGE-1 downto 0);
		y_start : out STD_LOGIC_VECTOR(XY_RANGE-1 downto 0);
		step : out STD_LOGIC_VECTOR(XY_RANGE-1 downto 0));
end component;

component ClockManager 
    Port ( clock : in std_logic;
		reset : in std_logic;
		ce_param : out std_logic);
end component;

component muxandcpt is
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
end component;

Signal startS,stopS, xincS, yincS, s_param, startVGA, doneVGA : std_logic;
Signal xS,xS2,xS3,xS4,xS5,xS6,xS7,xS8, yS : std_logic_vector(XY_RANGE - 1 downto 0);
Signal s_xstart, s_ystart, s_step : std_logic_vector(XY_RANGE - 1 downto 0);
Signal colorS : STD_LOGIC_VECTOR (bit_per_pixel-1 downto 0);
Signal b_done : STD_LOGIC_VECTOR(7 downto 0);
Signal itersS,itersS1, itersS2, itersS3, itersS4, itersS5, itersS6, itersS7, itersS8, itermaxS : STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);
begin
InstColorgen : Colorgen
port map (itersS,itermaxS,colorS);

InstVGA: VGA_bitmap_640x480
Port map (clock,
	reset,
	VGA_hs,
	VGA_vs,
	VGA_red,
	VGA_green,
	VGA_blue,
	stopS,
	colorS,
	startVGA, 
	open); 
				
Instincrment: increment
Port map (clock,
	reset,
	startS,
	s_xstart,
	s_ystart,
	s_step,
	xS,
	yS,
	xS2,
	xS3,
	xS4,
	xS5,
	xS6,
	xS7,
	xS8,
	stopS);
			
instFSM : FSM
Port map (clock,
	reset,
	b_done,
	stopS,
	doneVGA,
	startS,
	startVGA);

instIterator : Iterator
	Port map ( startS, clock, reset, xS, yS, itermaxS, itersS1, b_done(0));

instIterator2 : Iterator
	Port map ( startS, clock, reset, xS2, yS, itermaxS, itersS2, b_done(1));

instIterator3 : Iterator
	Port map ( startS, clock, reset, xS3, yS, itermaxS, itersS3, b_done(2));

instIterator4 : Iterator
	Port map ( startS, clock, reset, xS4, yS, itermaxS, itersS4, b_done(3));

instIterator5 : Iterator
	Port map ( startS, clock, reset, xS5, yS, itermaxS, itersS5, b_done(4));
	
instIterator6 : Iterator
	Port map ( startS, clock, reset, xS6, yS, itermaxS, itersS6, b_done(5));
	
instIterator7 : Iterator
	Port map ( startS, clock, reset, xS7, yS, itermaxS, itersS7, b_done(6));
	
instIterator8 : Iterator
	Port map ( startS, clock, reset, xS8, yS, itermaxS, itersS8, b_done(7));
					
inst_cpt_iter: cpt_iter
port map ( clock,
	reset,
	inib,
	stopS,
	maxiter,
	itermaxS);

inst_zoom : Zoom
	port map (bleft, bright, bup, bdwn, bctr, clock, reset, s_param, s_xstart, s_ystart, s_step);

inst_clock_manager : ClockManager
	port map (clock, reset, s_param);
	
inst_mux : muxandcpt
	port map(clock, reset, itersS1,itersS2,itersS3,itersS4,itersS5,itersS6,itersS7,itersS8,startVGA,itersS,doneVGA);

end Behavioral;