library ieee;
use ieee.std_logic_1164.all;

   entity comparator is
	port(
		
		input_x: in std_logic_vector(3 downto 0);
		
		input_y: in std_logic_vector(3 downto 0);
		
		u_above: out std_logic;
		u_below:	out std_logic;
		u_equal: out std_logic;
		
		s_above: out std_logic;
		s_below: out std_logic;
		s_equal:	out std_logic
	
	);
end comparator;

architecture behavioral of comparator is

signal co_temp, overflow_temp, sign_temp, zero_temp: std_logic;
signal sum_temp: std_logic_vector(3 downto 0); 

component carry_lookahead_adder is
	port( 
		x: in std_logic_vector(3 downto 0);
		
      y: in std_logic_vector(3 downto 0);
		
      sel: in std_logic; --signal to do addition or subtraction
		
      s: out std_logic_vector(3 downto 0);
		
      co: out std_logic; --carry from last bit
		overflow: out std_logic; --to check if overflow occurs
		sign: out std_logic; --to display the sign of the result
		zero: out std_logic
	);
end component;

begin 
	adder0: carry_lookahead_adder
		port map(
			x => input_x,
			
			y => input_y,
			
			sel => '1',
			
			s => sum_temp,
			
			co => co_temp,
			overflow => overflow_temp,
			sign => sign_temp,
			zero => zero_temp
		);
		
	process(zero_temp)
	begin 
		
		if(zero_temp ='0') then
			u_above <= co_temp;
			u_below <= not(co_temp);
			u_equal <= zero_temp;
			
			s_above <= not((sign_temp xor overflow_temp));
			s_below <= (sign_temp xor overflow_temp);
			s_equal <= zero_temp;
			
		else 
			u_above <= not(zero_temp);
			u_below <= not(zero_temp);
			u_equal <= zero_temp;
			
			s_above <= not(zero_temp);
			s_below <= not(zero_temp);
			s_equal <= zero_temp;
		end if;
	end process;
	
end behavioral;