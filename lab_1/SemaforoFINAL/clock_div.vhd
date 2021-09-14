----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:03:03 06/10/2019 
-- Design Name: 
-- Module Name:    clock_div - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all; -- to use BUFG

entity clock_div is
	 Generic (MAXCOUNT : INTEGER := 16);
    Port ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           divclk : out  STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is
signal divcounter : INTEGER RANGE 0 to MAXCOUNT-1 := 0;
signal tmpclk : STD_LOGIC := '0';
begin
	-- Port mapping clk using bufg
	clkbuf : bufg PORT MAP(
		I => tmpclk,
		O => divclk);

	main: process(clk, reset)
	begin
		if (reset = '1') then
			divcounter <= 0;
			tmpclk <= '1';
		elsif RISING_EDGE(clk) then	
			divcounter <= divcounter + 1;
			if divcounter = MAXCOUNT-1 then
				divcounter <= 0;
				tmpclk <= NOT tmpclk;
			end if;
		end if;
	end process;
end Behavioral;

