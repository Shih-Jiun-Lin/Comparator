library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity carry_lookahead_adder is
	Port( 
		x: in std_logic_vector(3 downto 0);
		
      y: in std_logic_vector(3 downto 0);
		
      sel: in std_logic; --signal to do addition or subtraction
		
      s: out std_logic_vector(3 downto 0);
		
      co: out std_logic; --carry from last bit
		overflow: out std_logic; --to check if overflow occurs
		sign: out std_logic; --to display the sign of the result
		zero: out std_logic
	);
end carry_lookahead_adder;

architecture behavioral of carry_lookahead_adder is

signal sum_temp, sum, y_final: std_logic_vector(3 downto 0) := "0000";
signal c : std_logic_vector(4 downto 0) := "00000"; --c4 for last carry(cout)
signal p : std_logic_vector(3 downto 0) := "0000"; 
signal g : std_logic_vector(3 downto 0) := "0000"; 

begin
	y_to_2s: process(y) --to do 2's complement if sel is 1
		begin
			if(sel='1') then
				y_final <= not(y) + sel; 
			else
				y_final <= y;
			end if;
	end process;
	
	sum_temp <= x xor y_final; 
   
	g <= x and y_final; --to generate term g
   p <= x or y_final; --to generte term p
	
	c(0) <= '0'; --assign 0 to c(0)
	
   cla: process(c, p, g)
		begin
			clc: for i in 0 to 3 loop --carry lookahead circuits
				c(i+1) <= g(i) or (p(i) and c(i)); 
		end loop;
	end process;
	 
   co <= c(4); 
   sum <= sum_temp xor c(3 downto 0); 
	s <= sum;
	overflow <= c(4) xor c(3);
	sign <= sum(3);
	zero <= not (sum(0) or sum(1) or sum(2) or sum(3));
end behavioral;