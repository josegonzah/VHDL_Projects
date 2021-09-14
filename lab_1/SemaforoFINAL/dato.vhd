----------------------------------------------------------------------------------
-- Company: LERA
-- Engineer: LERA
-- 
-- Create Date:    14:27:42 06/28/2019 
-- Design Name: 
-- Module Name:    dato - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dato is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           boton : in  STD_LOGIC;
           orden : in  STD_LOGIC;
           output : out  STD_LOGIC:='0');
end dato;

architecture Behavioral of dato is
signal enable:std_logic:='1';
signal salida:std_logic:='0';
begin
--------------------------------------------
	process(clk,reset)
	begin
		if(reset='1')then
			salida<='0';

		elsif(rising_edge(clk))then
			if(orden='1')then
				salida<='0';
			elsif(boton='1')then
				salida<='1';
			elsif(enable='0')then
				salida<='1';
			else
				salida<='0';
			end if;
		end if;
	end process;
---------------------------------------------
-----------------------------------------------	
	process(clk)
	begin
	   if(rising_edge(clk))then
			if(salida='1')then
				enable<='0';
			else
				enable<='1';
			end if ;
		end if;
	end process;
	output<=salida;
-------------------------------------------------
end Behavioral;

