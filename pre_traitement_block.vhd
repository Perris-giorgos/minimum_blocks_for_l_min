library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pre_traitement_block is
generic (n : integer := 6);
port (clock : in std_logic;
		clear : in std_logic;
		load : in std_logic;
		new_info : in std_logic_vector(n-1 downto 0);
		new_pos : in std_logic_vector(2 downto 0);
		min0 : out std_logic_vector(n-1 downto 0);
		min1 : out std_logic_vector(n-1 downto 0);
		min2 : out std_logic_vector(n-1 downto 0);
		pos0 : out std_logic_vector(2 downto 0);
		pos1 : out std_logic_vector(2 downto 0);
		pos2 : out std_logic_vector(2 downto 0)
		);
end pre_traitement_block;

architecture Behavioral of pre_traitement_block is
type cell is array (0 to 2) of std_logic_vector(n-1 downto 0);
type pcell is array (0 to 2) of std_logic_vector(2 downto 0);
signal cells : cell;
signal pcells : pcell;
signal a,b,c : std_logic;
--signal t : std_logic_vector(n-1 downto 0);
begin
compare0 : process (new_info)
begin
		if load = '1' then
		 if cells(0) > new_info then
			a <= '1';
		 else
			a <= '0';
		 end if;
		end if;
end process;
compare1 : process (new_info)
begin
		if load = '1' then
			if cells(1) > new_info then
				b <= '1';
			 else
				b <= '0';
			 end if;
		 end if;
end process;

compare2 : process (new_info)
begin
		if load = '1' then
		 if cells(2) > new_info then
			c <= '1';
		 else
			c <= '0';
		 end if;
		end if;
end process;

cell_update : process(clock)
begin 

if (CLocK'event and CLocK='1') then
	if clear = '1' then
			cells(0) <= (others => '1');
			cells(1) <= (others => '1');
			cells(2) <= (others => '1');
			
	else
		if a ='1' and b = '1' and c = '1' then
			cells(0) <= new_info;
			cells(1) <= cells(0);
			cells(2) <= cells(1);
			pcells(0) <= new_pos;
			pcells(1) <= pcells(0);
			pcells(2) <= pcells(1);
		elsif a ='0' and b = '1' and c = '1' then
			cells(0) <= cells(0);
			cells(1) <= new_info;
			cells(2) <= cells(1);
			pcells(0) <= pcells(0);
			pcells(1) <= new_pos;
			pcells(2) <= pcells(1);
		elsif a ='0' and b = '0' and c = '1' then
			cells(0) <= cells(0);
			cells(1) <= cells(1);
			cells(2) <= new_info;
			pcells(0) <= pcells(0);
			pcells(1) <=pcells(1);
			pcells(2) <= new_pos;
		else
			cells(0) <= cells(0);
			cells(1) <= cells(1);
			cells(2) <= cells(2);
		end if;
	end if;
end if;
end process;
min0 <= cells(0);
min1 <= cells(1);
min2 <= cells(2);
pos0 <= pcells(0);
pos1 <= pcells(1);
pos2 <= pcells(2);

end Behavioral;