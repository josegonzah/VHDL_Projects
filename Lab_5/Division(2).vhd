----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:13:33 07/18/2019 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DIVISION is
    Port ( NUMBER : in  STD_LOGIC_VECTOR (15 downto 0);
	 			NUMBER2 : in std_logic_vector(15 downto 0);
				START : in std_logic;
				RESULT : out STD_LOGIC_vector(15 downto 0);
				RESIDUE: out STD_LOGIC_VECTOR(15 downto 0);
				FINISH: out STD_LOGIC;
				clk : in std_logic
				);
			  

end DIVISION;

architecture Behavioral of DIVISION is

type estadosdiv is(loading, calcline);
signal divstate: estadosdiv := loading;
begin-----------------------------------------------------------------
 


division:process(clk, divstate)
variable div1: std_logic_vector(15 downto 0);
variable div2: std_logic_vector(15 downto 0);
variable counter: std_logic_vector(15 downto 0);
variable parcial: std_logic_vector(15 downto 0);

begin
	if(rising_edge(clk))then
		if(start = '1') then
				case divstate is	
					when loading =>
						divstate <= calcline;
						FINISH <= '0';
					when calcline =>
						counter := "0000000000000000";
						div1 := NUMBER;
						div2 := NUMBER2;
						if(div1(15) = '1' and div2(15) =  '1') then
							div1 := not(div1) + '1';
							div2 := not(div2) + '1';
							parcial := div1;
						elsif(div1(15) = '1') then
							div1 := not(div1) + '1';
							parcial := div1;
						elsif(div2(15) = '1') then
							div2 := not(div2) + '1';
							parcial := div1;
						else
							div1 := div1;
							div2 := div2;
							parcial := div1;
						end if;
						if(div1 < div2) then
							RESULT <= "0000000000000000";
							RESIDUE <= div2;
							FINISH <= '1';
						elsif(div2 = "000000000000000" or div2 = "100000000000000") then
							RESULT <= "1111111111111111";
							RESIDUE <= "1111111111111111";
							FINISH <= '1';
						elsif(div1 = "000000000000000" or div2 = "100000000000000") then
							RESULT <= "0000000000000000";
							RESIDUE <= "0000000000000000";
							FINISH <= '1';
						else
							--Ciclo para calcular las lineas a sumar
							while(parcial(15) = '0' and parcial /= "0000000000000000") loop
								parcial := parcial - div2;
								counter := counter + '1';
							end loop;
					
							if(parcial = x"0") then
							
								if(NUMBER(15) = '1' xor NUMBER2(15) = '1') then
								
									RESULT <= not(counter)+ '1';
									RESIDUE <= "0000000000000000";
									FINISH <= '1';
								else
									RESULT <= counter;
									RESIDUE <= "0000000000000000";
									FINISH <= '1';
								end if;
							else
								counter := counter + 1;
								if(NUMBER(15) = '1' xor NUMBER2(15) = '1') then
									RESULT <= not(counter) +'1';
									RESIDUE <= not(parcial + div2) + '1';
									FINISH <= '1';
								else
									RESULT <= counter;
									RESIDUE <= parcial + div2;
									FINISH <= '1';
								end if;
								divstate <= calcline;
							end if;
						end if;
						----------------------------------------------------------
					---------------------------------------------------------------
					end case;
			end if;
		end if;
   end process;
	
	
end Behavioral;

