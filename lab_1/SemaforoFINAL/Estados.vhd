----------------------------------------------------------------------------------
-- Company: LERA
-- Engineer: LERA
-- 
-- Create Date:    21:50:39 06/20/2019 
-- Design Name: 
-- Module Name:    Estados - Behavioral 
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

entity Estados is
    Port ( clk : in  STD_LOGIC;
           boton : in  STD_LOGIC;
           sensor : in  STD_LOGIC;
           pri : out  STD_LOGIC_VECTOR (1 downto 0);
           sec : out  STD_LOGIC_VECTOR (1 downto 0);
           peat1 : out  STD_LOGIC;
           peat2 : out  STD_LOGIC;
           reset : in  STD_LOGIC);
	 -- Pins assingment
	 ATTRIBUTE LOC: STRING;
	 ATTRIBUTE LOC OF clk    : SIGNAL IS "B8";	-- system clock 50 MHz (Nexys2)
	 ATTRIBUTE LOC OF reset  : SIGNAL IS "H13";  -- BTN0
	 ATTRIBUTE LOC OF boton  : SIGNAL IS "E18";  -- BTN1
	 ATTRIBUTE LOC OF sensor : SIGNAL IS "G18";  -- SW0
	 ATTRIBUTE LOC OF pri   : SIGNAL IS "J15,J14";  --LD1,LD0
	 ATTRIBUTE LOC OF sec   : SIGNAL IS "K14,K15";  -- LD3,LD2
	 ATTRIBUTE LOC OF peat1   : SIGNAL IS "E17";  -- LD4
	 ATTRIBUTE LOC OF peat2   : SIGNAL IS "P15";  -- LD5
end Estados;

architecture Behavioral of Estados is
type estados is(s1,s2,s3,s4,s5,s6,s7);
signal state:estados:=s1;
signal nextstate:estados := s1;
signal tiempo:integer:=0;
signal newclk:std_logic;
signal rst_time:std_logic:='0';

signal ban:std_logic:='0';--seal para dar un aviso o un pulso de que paso hacia s7;
signal date:std_logic:='0'  ;

component clock_div 
	 Generic (MAXCOUNT : INTEGER :=25000000);
    Port ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           divclk : out  STD_LOGIC);
end component;

component dato
--Componente que guarda el dato del botón, recibe como señal el reloj de la tarjeta, el reset, la entrada del botón y una bandera que le 
--indica cuando ser leido
	    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           boton : in  STD_LOGIC;
           orden : in  STD_LOGIC;
           output : out  STD_LOGIC);
end component;

begin
	divisor:clock_div port map(clk=>clk,reset=>reset,divclk=>newclk);
	Dato_alm:dato port map(clk=>clk,reset=>reset,boton=>boton,orden=>ban,output=>date);
	reset_time:process(newclk) --Proceso que controla el conteo de segundos, se hace en paralelo con el proceso principal
	begin
		if(rising_edge(newclk))then
			if(rst_time ='1')then
				tiempo<=0;
			else
				tiempo<=tiempo+1;
			end if;
		end if;
	end process;
--------------------------------------------------------
 
 ------------------------------------------------------------
  process(clk,tiempo,state, reset)
  begin
		if(rising_edge(clk))then
			if(tiempo=0)then
				rst_time<='0';---para que deje de reiniciar el tiempo
			end if;
			ban<='0';
			if (reset = '1') then--el reset se lee en cada flanco del reloj, en caso de ser cierto se resetea el contador y se va al 
				state <= s1;--estado 1, esta m´aquina se utiliza principalmete para pasar de estado ya que el reset si solo se deja el de aca
				rst_time <= '1';--sera ejecutado pero no pasara a la secuencia de estados s1, s2 y asi, sino que ira al estado s1 y luego continuara 
				--en donde se dejo, ya que el cambio de estado esta en el else, por ello se debe de poner la opcion del reset como un conicional en cada caso
				--para que se respete la secuencia del programa
			else                         
				state <= nextstate;   --De lo contrario seguira al siguinte estado                                             
			end if;
			case state is	
				when s1 =>
					pri<="00";
					sec<="00";
					peat1<='0';
					peat2<='0';
					if(tiempo=3)then
						rst_time<='1';---reinicia el tiempo
						nextstate<=s2;
					else
						nextstate<=nextstate;
					end if;
				when s2 =>
					pri<="11";
					sec<="00";
					peat1<='0';
					peat2<='1';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=10)then
						if(sensor='1')then
							rst_time <= '1';
							nextstate<=s6;
						else
							nextstate<=s3;
							rst_time<='1';
						end if;
					else
						nextstate<=nextstate;
					end if;
					
				when s3 =>
					pri<="01";
					sec<="00";
					peat1<='0';
					peat2<='1';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=2)then
						rst_time<='1';
						if(date='1')then
							nextstate<=s7;
							ban<='1';---da el aviso de que pasa a s7 para asi habilite el pulso del boton 
						else
							nextstate<=s4;
							ban<='0';
						end if;
					else
						nextstate<=nextstate;
					end if;
				when s4 =>
					pri<="00";
					sec<="11";
					peat1<='1';
					peat2<='0';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=10)then
						nextstate<=s5;
						rst_time<='1';
					else
						nextstate<=nextstate;
					end if;
				when s5 =>
					pri<="00";
					sec<="01";
					peat1<='1';
					peat2<='0';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=2)then
						nextstate<=s2;
						rst_time<='1';
					else
						nextstate<=nextstate;
					end if;
				when s6 =>--tiempo extra
					pri<="11";
					sec<="00";
					peat1<='0';
					peat2<='1';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=5)then
						nextstate<=s3;
						rst_time<='1';
					else
						nextstate<=nextstate;
					end if ;
				when s7 =>    --tiempo para los peatones 
					pri<="00";
					sec<="00";
					peat1<='1';
					peat2<='1';
					if(reset = '1')then
						rst_time <= '1';
						nextstate <= s1;
					elsif(tiempo=4)then
						nextstate<=s4;
						rst_time<='1';
					else
						nextstate<=nextstate;
					end if ;				
				when others =>
					nextstate<=s1;
			end case;
		end if;
   end process;
-----------------------------------------------------------------------

end Behavioral;

