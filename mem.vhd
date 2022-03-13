----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 08:34:05 PM
-- Design Name: 
-- Module Name: mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
    Port ( MemWrite : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           BranchOnEqual : in STD_LOGIC;
           BranchOnGreaterOrEqualToZero : in STD_LOGIC;
           Zero : in STD_LOGIC;
           greaterOrEqual : in STD_LOGIC;
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : out STD_LOGIC);
end mem;

architecture Behavioral of mem is


type ram_type is array (0 to 64) of std_logic_vector (15 downto 0);
signal memory: ram_type := (
x"0001",
x"0002",
x"0003",
x"0000",
x"0003",
others => x"0000" 
);

begin

PCSrc <= (BranchOnEqual and Zero) or (BranchOnGreaterOrEqualToZero and greaterOrEqual);

process(clk)
begin
    if rising_edge(clk) then
        if(en = '1') then
            if(MemWrite = '1') then
                memory(to_integer(unsigned(ALURes(5 downto 0)))) <= rd2;               
            end if;
        end if;
    end if;
end process;

MemData <= memory(to_integer(unsigned(ALURes(5 downto 0))));

ALUResOut <= ALURes;

end Behavioral;



