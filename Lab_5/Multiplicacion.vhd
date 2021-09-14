----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:11:20 09/23/2019 
-- Design Name: 
-- Module Name:    Multiplicacion - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Multiplicacion is
	 Generic(BITS_M   : integer := 16);
    Port ( CLK         : in   STD_LOGIC;
           START    : in   STD_LOGIC; 
			  NUMBER1	  : in   STD_LOGIC_VECTOR (BITS_M-1 downto 0);
           NUMBER2 	  : in   STD_LOGIC_VECTOR (BITS_M-1 downto 0);
			  FINISH	  : out  STD_LOGIC;
			  RESULT1	  : out  STD_LOGIC_VECTOR (BITS_M-1 downto 0);	
			  RESULT2     : out  STD_LOGIC_VECTOR (BITS_M-1 downto 0));
end Multiplicacion;

architecture Behavioral of Multiplicacion is

TYPE matrix IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR((BITS_M+ BITS_M)-1 DOWNTO 0);
signal sumMat   : matrix := (others=>(others=>'0'));
signal sum1 : STD_LOGIC_VECTOR ((BITS_M+BITS_M)-1 downto 0):= (others =>'0');
signal sum2 : STD_LOGIC_VECTOR ((BITS_M+BITS_M)-1 downto 0):= (others =>'0');
signal ans  : STD_LOGIC_VECTOR (31 downto 0):= (others =>'0');
signal cont        : INTEGER RANGE 0 to 4 := 0; 


begin
		mult : process(START)
		begin
				
			if START = '1' then 
				for i in 0 to BITS_M-1 loop
					if (NUMBER2(i) = '1') then
						sumMat(i)((BITS_M-1)+i downto 0+i) <= NUMBER1;
					else
						sumMat(i)((BITS_M-1)+i downto 0+i) <= "0000000000000000";
					end if;
				end loop;
			end if;
		end process;

	sumar : process(CLK)
	begin
		if (RISING_EDGE(CLK))then
			if (cont < 3) then
				cont <= cont + 1;
			else
				cont <= 0;
			end if;
		end if;
	end process;
	
	sum_resul : process(cont)
	begin
		if (START = '0') then
			FINISH <= '0';
		else
			if cont = 0 then
				sum1 <= sumMat(0)+sumMat(1)+sumMat(2)+sumMat(3)+sumMat(4)+sumMat(5)+sumMat(6)+sumMat(7);
				FINISH <= '0';
			elsif cont = 1 then
				sum2 <= sumMat(8)+sumMat(9)+sumMat(10)+sumMat(11)+sumMat(12)+sumMat(13)+sumMat(14)+sumMat(15);
				FINISH <= '0';
			elsif cont = 2 then
				ans <= sum1 + sum2;
				FINISH <= '0';
			else
				FINISH <= '1';
				RESULT1 <= ans((BITS_M+BITS_M)-1 downto BITS_M);
				RESULT2	  <= ans(BITS_M-1 downto 0);
			end if;
		end if;
	end process;
end Behavioral;

