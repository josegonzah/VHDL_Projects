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

entity mult32bits is
    Port ( NUMBER : in  STD_LOGIC_VECTOR (15 downto 0);
	 			NUMBER2 : in std_logic_vector(15 downto 0);
				START : in std_logic;
				RESULT : out STD_LOGIC_vector(31 downto 0);
				clk : in std_logic
				);
			  

end mult32bits;

architecture Behavioral of mult32bits is

type estadosmult is(loading, calcline, sumline, sumline2, sumline3, sumline4);
signal multstate: estadosmult := loading;

signal alllines :std_logic_vector((46*23)-1 downto 0);
type t_Row_Col is array (16 downto 0) of std_logic_vector(30 downto 0);

begin-----------------------------------------------------------------
 
 
---------------------mantisas aunmentadas un bit-----


multiplicacion:process(clk, multstate)
variable array_mant : t_Row_Col;
variable mult1: std_logic_vector(15 downto 0);
variable mult2: std_logic_vector(15 downto 0);
variable tempmult1: std_logic_vector(23 downto 0);
variable tempmult2: std_logic_vector(23 downto 0);



begin
	if(rising_edge(clk))then
		if(start = '1') then
				case multstate is	
					when loading =>
						multstate <= calcline;
					when calcline =>
						mult1 := NUMBER;
						mult2 := NUMBER2;
						if(mult1 < x"0" and mult2 < x"0") then
							mult1 := not(mult1) + 1;
							mult2 := not(mult2) + 1;
						elsif(mult1 < x"0") then
							mult1 := not(mult1) + 1;
						elsif(mult2 < x"0") then
							mult2 := not(mult2) + 1;
						else 
							mult1 := mult1;
							mult2 := mult2;
						end if;
						RESULT(31) <= NUMBER(15) XOR NUMBER2(15); 
					--Ciclo para calcular las lineas a sumar
						array_mant := (others =>(others=> '0'));
						for i in 0 to 14 loop
							--primer ciclo que va por bits del mult1
							if(mult1(i) = '0') then
								--variable temporal que almacena los datos de cada linea
								array_mant(i) := (others => '0');
							else
								--En el vestor alllines tengo todos los sumandos y las tres instrucciones son las
								--instrucciones que rellenan lo que necesitamos, los primeros ceros tanto como los ultimos ceros
								--tanto como los valores que son iguales al multiplicando 2
								array_mant(i)(i+14 downto i) := (mult2(14 downto 0));
								--Ya tengo todos los sumandos listos
								multstate <= sumline;
							end if;
						end loop;
								
						when sumline =>
							--Voy a sumar todos los sumandos
							array_mant(16) := (others => '0');
							for k in 0 to 3 loop
								array_mant(16) := ((array_mant(k))+ (array_mant(16)));
							end loop;
							multstate <= sumline2;
					------------------------------------------------------------------
						when sumline2 =>
							for k in 4 to 7 loop
								array_mant(16) := ((array_mant(k))+ (array_mant(16)));
							end loop;
							multstate <= sumline3;
				  --------------------------------------------------------------
						when sumline3 =>
							for k in 8 to 11 loop
								array_mant(16) := ((array_mant(k))+ (array_mant(16)));
							end loop;
							multstate <= sumline4;
					-----------------------------------------------------------					
						when sumline4 =>
							for k in 12 to 14 loop
								array_mant(16) := ((array_mant(k))+ (array_mant(16)));
							end loop;
							if(NUMBER < x"0" or NUMBER2 < x"0") then
								RESULT(30 DOWNTO 0) <= not(array_mant(16)) + 1;
								multstate <= calcline;
							else
								RESULT(30 DOWNTO 0) <= array_mant(16);
								multstate <= calcline;
						----------------------------------------------------------
					---------------------------------------------------------------
					end case;
			end if;
		end if;
   end process;
	
	
end Behavioral;

