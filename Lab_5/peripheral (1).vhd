-- ***************************************************************************************
-- LC3 Processor
-- Digital Electronics Lab Course
-- 2019
-- Module: Peripheral for Console Emulation Through Serial Communication Module
-- ***************************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity peripheral_uart is
generic(   
			ADDR_LC3_WIDTH  : natural := 16;	
			DATA_LC3_WIDTH  : natural := 16);
port (
		CLK				: in  std_logic;
		RST				: in  std_logic;
		-- Signals to/from fsm_serial
		ChrReadyFromPC : in  std_logic;						
		Data_Rx			: in  std_logic_vector(7 downto 0);
		Rx_Ack 			: out std_logic;
		ChrReadyToPC	: out std_logic;								
		Data_Tx			: out std_logic_vector (7 downto 0);		
		Tx_Ack			: in std_logic;
		-- Interface for the peripheral
		start_RW_P		: in  std_logic;
		R_W_Per			: in  std_logic;
		AddrP				: in  std_logic_vector(ADDR_LC3_WIDTH-1 downto 0);
		data_WPer		: in  std_logic_vector(DATA_LC3_WIDTH-1 downto 0);	-- From LC3
		data_RPer		: out std_logic_vector(DATA_LC3_WIDTH-1 downto 0);
		PerOpDone		: out std_logic;
		-- Signals to/from multiplication and division units
	   startmult     	: out  STD_LOGIC; 
	   finishmult	  		: in   STD_LOGIC;
	   resmul1   	  	: in   STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0);	
	   resmul2     	: in   STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0);
		
		-- Signal division
		startdiv		: out  STD_LOGIC;
		finishdiv	  		: in   STD_LOGIC;
		residue    		: in   STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0);
		coc 		: in   STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0);
		-- seales de entrada
		IN_A   	   : out  STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0);
	   IN_B  		: out  STD_LOGIC_VECTOR (DATA_LC3_WIDTH-1 downto 0)
		
		
	);
end peripheral_uart;

architecture Behavioral of peripheral_uart is
	-- To interface with fsm_lc3_comp
	type fsm_machine is (init, s0, s1);
	signal peripheral_state	: fsm_machine := init;
	
	-- To interface with serial module
	type fsm_uart_tx is (tx_uart0, tx_uart1, tx_uart2);
	signal tx_chr_state : fsm_uart_tx := tx_uart0;
	type fsm_uart_rx is (rx_uart0, rx_uart1, rx_uart2);
	signal rx_chr_state : fsm_uart_rx := rx_uart0;
	signal lc3_rx_ready : std_logic := '0';
	signal lc3_tx_ready : std_logic := '0';
	signal lc3_rx_data  : std_logic_vector(7 downto 0) := x"00";
	signal lc3_tx_data  : std_logic_vector(7 downto 0) := x"00";
	signal lc3_rx_next  : std_logic := '0';
	signal lc3_tx_write : std_logic := '0';
	--Where operand and results for multiplication
	signal oper1   :std_logic_vector(DATA_LC3_WIDTH-1 downto 0) := x"0000";
	signal res1  :std_logic_vector(DATA_LC3_WIDTH-1 downto 0) := x"0000";
	signal res2  :std_logic_vector(DATA_LC3_WIDTH-1 downto 0) := x"0000";
	-- Seal para almacenar el operando A y resultados de la divisin
	signal scoc  :std_logic_vector(DATA_LC3_WIDTH-1 downto 0) := x"0000";
	signal sresidue  	:std_logic_vector(DATA_LC3_WIDTH-1 downto 0) := x"0000";	
	-- Addresses to be used in ASM code to access to the serial peripheral
	constant PER_ADDRESS_BASE : std_logic_vector := x"FE00";
	constant PER_ADDRESS_KBSR : std_logic_vector := x"FE00";
	constant PER_ADDRESS_KBDR : std_logic_vector := x"FE02";
	constant PER_ADDRESS_DSR  : std_logic_vector := x"FE04";
	constant PER_ADDRESS_DDR  : std_logic_vector := x"FE06";
	-- Addresses to be used in ASM code to access to the multiplicacin peripherals
	constant PER_ADDRESS_MSR   : std_logic_vector := x"FE01";		--MULTIPLICATION STATUS REGISTER
	constant PER_ADDRESS_MIR1    : std_logic_vector := x"FE03";		--MULTIPLICATION INPUT REGISTER1
	constant PER_ADDRESS_MIR2   : std_logic_vector := x"FE05";     --MULTIPLICATION INPUT REGISTER2
	constant PER_ADDRESS_DIR   : std_logic_vector := x"FE0C";     --DIVISION INPUT REGISTER
	constant PER_ADDRESS_MRR1 : std_logic_vector := x"FE07";		--MULTIPLICATION RESULT REGISTER1
	constant PER_ADDRESS_MRR2 : std_logic_vector := x"FE08";		--MULTIPLICATION RESULT REGISTER2
	
	-- Addresses to be used in ASM code to access to the divisin peripherals
	constant PER_ADDRESS_DIVSR     : std_logic_vector := x"FE09";		--DIVISION STATUS REGISTER
	constant PER_ADDRESS_DCR : std_logic_vector := x"FE0A";	   --DIVISION COCIENT REGISTER
	constant PER_ADDRESS_DRR  : std_logic_vector := x"FE0B";		--DIVISION RESIDUE REGISTER
begin
	-- Process to write/read to/from peripheral from/to LC3
	process(CLK, RST)
	begin
		if (RST = '1') then
			PerOpDone <= '0';
			data_RPer <= x"0000";
			peripheral_state <= init;
		elsif (rising_edge(CLK)) then
			-- Do the following always (a particular case can override them)
			PerOpDone <= '0';
			lc3_rx_next <= '0';
			lc3_tx_write <= '0';
			case peripheral_state is
				-- Waiting for LC3 to start a reading/writing
				when init =>	
					if (start_RW_P = '1')	then
						peripheral_state <= s0;
					else	
						peripheral_state <= init;					
					end if;
				-- LC3 has started a reading/writing, which one?
				when s0 =>	
					if (R_W_Per = '0') then -- read from peripheral
						if (AddrP = PER_ADDRESS_KBSR) then
							if (lc3_rx_ready = '1') then
								-- UART received data from PC that has not been processed yet
								data_RPer <= x"8000";	
							else
								-- UART hasn't received data from PC yet or previous data was already processed
								data_RPer <= x"0000";	
							end if;	
						elsif (AddrP = PER_ADDRESS_KBDR) then
							data_RPer <= lc3_rx_data;
							if (lc3_rx_ready = '1') then
								-- Clear KBSR register and allows a new char in UART
								lc3_rx_next <= '1';		
							end if;	
						elsif (AddrP = PER_ADDRESS_DSR) then
							if (lc3_tx_ready = '1') then
								-- UART ready to transmit data
								data_RPer <= x"8000";	
							else
								-- UART is busy transmitting a char
								data_RPer <= x"0000";	
							end if;	
						-- Pass values from mult/div units to LC3 from here
						elsif (AddrP = PER_ADDRESS_MSR) then
							--Multiplication is ready when x8000, when x0000 is not ready yet
							if (finishmult = '0') then
								data_RPer <= x"0000";
							else
								res1 <= resmul1;
								res2 <= resmul2;
								data_RPer   <= x"8000";
								startmult    <= '0'; 
							end if;
							
						
						elsif (AddrP = PER_ADDRESS_MRR2) then
							data_RPer   <= res2;
							res2 <= x"0000";
						
						-- Division
						elsif (AddrP = PER_ADDRESS_DIVSR) then
							--Divison logic is the same as multiplication
							if (finishdiv = '0') then
								data_RPer <= x"0000";
							else
								scoc  <= coc;
								sresidue	  <= residue;
								data_RPer  <= x"8000";
								startdiv <= '0'; 
							end if;
							
						elsif (AddrP = PER_ADDRESS_DCR) then
							data_RPer <= scoc;
							scoc <= x"0000";
						elsif (AddrP = PER_ADDRESS_DRR) then
							data_RPer <= sresidue;
							sresidue <= x"0000";
						end if;
					
					else	-- write to Peripheral
						if (AddrP = PER_ADDRESS_DDR) then
							if (lc3_tx_ready = '1') then
								-- Take the char from LC3 and send it to the UART
								lc3_tx_data <= data_WPer;
								lc3_tx_write <= '1';		
							end if;	

						-- Pass values from LC3 to mult/div units from here.
						elsif (AddrP = PER_ADDRESS_MIR1)then
							oper1   <= data_WPer;
						elsif (AddrP = PER_ADDRESS_MIR2)then
							IN_B      <= data_WPer;
							IN_A      <= oper1;
							startmult     <= '1';
						--Division
						elsif (AddrP = PER_ADDRESS_DIR)then
							IN_B      <= data_WPer;
							IN_A      <= oper1;
							startdiv   <= '1';
						end if;
					end if;
					PerOpDone <= '1';					-- For any peripheral address, ack the operation
					peripheral_state <= s1;
				when s1 =>	-- Wait one cycle (required by LC3)
					peripheral_state <= init;
			end case;
		end if;
	end process;							
				
	-- Process to send chrs to UART (if enabled: LC3Started = '1')
	process(CLK, RST)
	begin
		if (RST = '1') then
			lc3_tx_ready <= '0';
			ChrReadyToPC <= '0';
			Data_Tx <= x"00";
			
			tx_chr_state <= tx_uart0;
		elsif (rising_edge(CLK)) then
			-- Always do the following (a particular case might override them)
			lc3_tx_ready <= '0';							-- UART cannot send a new data (DSR = x0000)

			case tx_chr_state is
				when tx_uart0 =>
					lc3_tx_ready <= '1';					-- UART can send a new data (DSR = x8000)
					if (lc3_tx_write = '1') then
						Data_Tx <= lc3_tx_data;
						tx_chr_state <= tx_uart1;
					else
						tx_chr_state <= tx_uart0;
					end if;
				when tx_uart1 =>
					ChrReadyToPC <= '1';
					tx_chr_state <= tx_uart2;
				when tx_uart2 =>
					if Tx_Ack = '1' then 				-- Data sent through UART
						ChrReadyToPC <= '0';				-- UART waits for it to restart tx
						tx_chr_state <= tx_uart0;
					else
						tx_chr_state <= tx_uart2;
					end if;	
			end case;
		end if;
	end process;
	
	-- Process to get chrs from UART (if allowed: LC3Started = '1')
	process(CLK, RST)
	begin
		if (RST = '1') then
			lc3_rx_ready <= '0';
			lc3_rx_data <= x"00";
			Rx_Ack <= '0';
			
			rx_chr_state <= rx_uart0;
		elsif (rising_edge(CLK)) then
			-- Always do the following (a particular case might override them)
			lc3_rx_ready <= '0';
			Rx_Ack <= '0';

			case rx_chr_state is
				when rx_uart0 =>
					if (ChrReadyFromPC = '1') then	-- UART has received data
						lc3_rx_data <= Data_Rx;
						rx_chr_state <= rx_uart1;
					else
						rx_chr_state <= rx_uart0;
					end if;
				when rx_uart1 =>
					lc3_rx_ready <= '1';					-- Indicate a new data is available (KBSR = x8000)
					if (lc3_rx_next = '1') then
						lc3_rx_ready <= '0';				-- Data was read (KBSR = x0000)
						Rx_Ack <= '1';						-- Ack the data read to wait for a new one
						rx_chr_state <= rx_uart2;
					else
						rx_chr_state <= rx_uart1;
					end if;	
				when rx_uart2 =>
					if (ChrReadyFromPC = '0') then
						rx_chr_state <= rx_uart0;
					else
						rx_chr_state <= rx_uart2;
					end if;	
			end case;
		end if;
	end process;
	
	-- Processes to manage mult/div units
end Behavioral;

