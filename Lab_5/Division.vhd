----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:20:25 09/23/2019 
-- Design Name: 
-- Module Name:    Division - Behavioral 
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

entity Division is
	 Generic(BITS_D   : integer := 16);
    Port ( CLK 				: in   STD_LOGIC;
           START		: in   STD_LOGIC;
           NUMBER1	 		: in   STD_LOGIC_VECTOR (BITS_D-1 downto 0);
           NUMBER2	 		: in   STD_LOGIC_VECTOR (BITS_D-1 downto 0);
			  FINISH	  		: out  STD_LOGIC;
			  RES      	: out  STD_LOGIC_VECTOR (BITS_D-1 downto 0);
			  COC			: out  STD_LOGIC_VECTOR (BITS_D-1 downto 0));
end Division;

architecture Behavioral of Division is
signal dividendo	: STD_LOGIC_VECTOR (BITS_D-1 downto 0) := (others => '0');
signal divisor  	: STD_LOGIC_VECTOR (BITS_D-1 downto 0) := (others => '0');
signal sresiduo  	: STD_LOGIC_VECTOR (BITS_D-1 downto 0) := (others => '0');
signal sCOC 	: STD_LOGIC_VECTOR (BITS_D-1 downto 0) := (others => '0');
--Seal que tipo bandera
signal flag 	 	: STD_LOGIC := '0'; --Indica que los opernado ya fuero revisados si son positivos o negativos
signal flag_signo : STD_LOGIC := '0'; --Indica si el resultado de la division es del mismo signo o diferente signo
signal flag_modulo : STD_LOGIC := '0'; --Indica si el resultado de la division es del mismo signo o diferente signo						
signal sFINISH   : STD_LOGIC := '0'; --Indica que la divisin termino

begin
	div : process(CLK)
	begin
		if START = '0' then
			sFINISH  <= '0';
			sCOC  <= x"0000"; 
			sresiduo   <= x"0000";
			flag       <= '0';
		else
			if (RISING_EDGE(CLK)) then
				if flag = '0' then
					if (NUMBER1(BITS_D-1) ='1' and NUMBER2(BITS_D-1) ='1') then
						dividendo  <= not(NUMBER1) + 1;
						divisor    <= not(NUMBER2) + 1;
						flag_signo <= '0';
						flag_modulo <= '1';

					elsif (NUMBER2(BITS_D-1) ='1') then
						dividendo <= NUMBER1;
						divisor	  <= not(NUMBER2) + 1; 
						flag_signo <= '1';
						flag_modulo <= '0';
						
					elsif (NUMBER1(BITS_D-1) ='1') then
						dividendo  <= not(NUMBER1) + 1;
						divisor	  <= NUMBER2; 
						flag_signo <= '1';
						flag_modulo <= '1';
					else
						dividendo  <= NUMBER1;
						divisor	  <= NUMBER2; 
						flag_signo <= '0';
						flag_modulo <= '0';
					end if;
					flag       <= '1';
					sFINISH   <= '0';
					
				elsif dividendo >= divisor then
						dividendo <= dividendo - divisor;
						sFINISH  <= '0';
						sCOC  <= sCOC + 1;
				elsif (sFINISH = '0') then 
					if flag_signo = '1' then
						sCOC  <= not(sCOC) + 1;
						if flag_modulo = '1' then
							sresiduo    <= not(dividendo) + 1;
						else
							sresiduo    <= dividendo;
						end if;	
					else
						sCOC  <= sCOC;
						if flag_modulo = '1' then
							sresiduo    <= not(dividendo) + 1;
						else
							sresiduo    <= dividendo;
						end if;	
					end if;
					sFINISH <= '1';
				else
					sFINISH <= '1';
				end if;
			end if;
		end if;
	end process;
	
	RES   <= sresiduo;
	COC  <= sCOC;
	FINISH   <= sFINISH;

end Behavioral;

