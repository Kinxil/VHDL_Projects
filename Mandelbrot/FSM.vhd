library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONSTANTS.all;
use work.CONFIG_MANDELBROT.all;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
	Port ( clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		b_done : in STD_LOGIC_VECTOR (7 downto 0);
		stop : in std_logic;
		doneVGA : in std_logic;
		start : out STD_LOGIC;
		startVGA : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is
type type_etat is (init, inc,finish,writing,calcul);
Signal etat_present, etat_futur : type_etat;

begin

process(clock,reset)
begin
	if reset='1' then
		etat_present<=init;
	elsif rising_edge(clock) then
		etat_present<=etat_futur;
	end if;
end process;


process(etat_present, doneVGA, stop, b_done)
begin
	case etat_present is 
		when init=> etat_futur<=inc;
		when calcul=> 
			if stop='1' then		
				etat_futur<=finish;
			elsif b_done=X"FF" then --all iterators are done
				etat_futur<=writing;
			else
				etat_futur<=calcul;
			end if;
		 when writing=> 
		 	if doneVGA='1' then --all results have been written on VGA
				etat_futur<=inc;
			else
				etat_futur<=writing;
			end if;
		when inc=> etat_futur<=calcul;
		when finish=>etat_futur<=init;
	end case;
end process;


process(etat_present)
begin
	case etat_present is
		when init=> start<='0';
			startVGA<='0';

		when calcul=> start<='0';
			startVGA<='0';
		 
		when writing=> start<='0';
			startVGA<='1';
		  
		when inc=> start<='1';
			startVGA<='0';

		when finish=>start<='0';
			startVGA<='0';
	end case;
end process;				
end Behavioral;