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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MULT is
    Port ( NUMBER1 : in  STD_LOGIC_VECTOR (15 downto 0);
			  NUMBER2 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
			  CLK : in STD_LOGIC;
           RESULT : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
 -- Pins assingment
end MULT;

architecture Behavioral of MULT is
type estdosmult is(calcline, sumline);
type matrix is array (natural range <>, natural range <>) of std_logic_vector(31 downto 0);
signal mulstate: estadosmult := calcline;
signal multnextstate: estadosmult := calcline;
signal dato1: std_logic_vector (15 downto 0);
signal dato2:std_logic_vector(15 downto 0);
signal resultado:std_logic_vector(15 downto 0);
signal pasar: std_logic;
signal mult1: std_logic_vector(31 downto 0);
signal mult2: std_logic_vector(31 downto 0);
signal tempmult1: std_logic_vector(15 downto 0);
signal tempmult2: std_logic_vector(15 downto 0);
signal res: std_logic_vector(31 downto 0);
signal manttemp : std_logic(31 downto 0);
signal alllines :std_logic((46*23)-1 downto 0);
type t_Row_Col is array (0 to 31) of std_logic_vector(15 downto 0);


tempmult1 <= NUMBER1;
tempmult2 <= NUMBER2;
begin----------------------------------------
 
 ------------------------------------------------------------
multiplicacion:process(clk, topstate, multstate, reset, start)
variable array_mant : t_Row_Col;

begin
	if(rising_edge(clk))then
			multstate <= multnextstate;
			case multstate is	
				when calcline =>
						for i in 0 to 23 loop
							--primer ciclo que va por bits del mult1
							if(tempmult1[i] = '0') then
								--variable temporal que almacena los datos de cada linea
								array_mant(i) := (others => '0');
							else
								--En el vestor alllines tengo todos los sumandos y las tres instrucciones son las
								--instrucciones que rellenan lo que necesitamos, los primeros ceros tanto como los ultimos ceros
								--tanto como los valores que son iguales al multiplicando 2
								array_mant(i, (0 to i)) := (others => '0')
								array_mant(i, (i to i+7)) := (tempmult2);
								array_mant(i, (i+7 to 15)) := (others => '0');
								--Ya tengo todos los sumandos listos
								multstate <= sumline;
							end if;
						end loop;
						
					when sumline =>
						--Voy a sumar todos los sumandos
						for k in 0 to 15 loop
							array_mant(i+1) := array_mant(i)+ array_mant(i+1);
						end loop;
							if(array_mant(7,15) = '1')then
								res <= array_mant(46 downto 24);
							else
								pottemp := pottemp;
								res[22 downto 0] <= array_mant(45 downto 23);
							end if;
							
						
						
						
				end case;
		end if;
   end process;
	
mostrarResultado: process(clk, topstate, moststate, reset, start)
begin
		if(rising_edge(clk))then
			if (reset = '1') then
				 moststate<= mprim8;
			else                         
				moststate <= mostnextstate;   --De lo contrario seguira al siguinte estado                                             
			end if;
			if(topstate = mostrar)then
				case moststate is	
					when mprim8 =>
						if(start = '1')then
							RESULT <= res(31 downto 24);
							moststate <= mseg8;
						end if;
					when mseg8 =>
						if(start = '1')then
						RESULT <= res(23 downto 16);
						moststate <= mterc8;
						end if;
					when mterc8 =>
						if(start = '1')then
						RESULT <= res(15 downto 8);
						moststate <= mcuart8;
						end if;
					when mcuart8 =>
						if(start = '1')then
						RESULT <= res(7 downto 0);
						moststate <= mprim8;
						enable4 <= '1';
						end if;
				end case;
			end if;
		end if;
   end process;	
	
	

end Behavioral;

