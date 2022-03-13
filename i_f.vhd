----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 11:14:07 AM
-- Design Name: 
-- Module Name: i_f - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity i_f is
    Port ( clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
       jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
       jump : in STD_LOGIC;
       PCSrc : in STD_LOGIC;
       instruction : out STD_LOGIC_VECTOR (15 downto 0);
       nextAddr : out STD_LOGIC_VECTOR (15 downto 0));
end i_f;

architecture Behavioral of i_f is

constant N : integer := 32; --256;
constant M : integer := 16;



type rom_type is array (0 to N-1) of std_logic_vector(M-1 downto 0);

signal ROM: rom_type := (
b"000_100_100_100_0_110", --xor $4, $4, $4 --1246
b"000_001_001_001_0_110", --xor $1, $1, $1 --0496
x"0000",
b"000_010_010_010_0_110", --xor $2, $2, $2 --0926
b"001_001_010_0001010", --addi $2, $1, 10  --250A
b"010_001_011_0000000", --lw $3, 0($1)     --4580
x"0000",
x"0000",
b"000_100_011_100_0_000", --add $4, $4, $3 --11C0
b"001_001_001_0000001", --addi $1, $1, 1   --2481
x"0000",
x"0000",
b"100_010_001_0000101", -- beq $1, $2, 1   --8881
x"0000",
x"0000",
x"0000",
b"111_0000000000101", --j 4                --E004
x"0000",
b"011_010_100_0000000", --sw $4, 0($2)     --6A00
b"010_010_001_0000000", --lw $1, 0($2)     --4880
x"0000",
x"0000",
b"110_001_101_0001010", --sltiu $5, $1, 10  --C68A
others => x"0000"
);

signal address, nextAddress, addrInc : STD_LOGIC_VECTOR(15 downto 0) := x"0000";

begin

PC_process: process(clk)
    begin
    if rising_edge(clk) then
        if reset = '1' then
            address <= x"0000";
        elsif enable = '1' then
            address <= nextAddress;
        end if;
     end if;
end process;

addrInc <= address + 1;

MUX_process : process(addrInc, branchAddr, jumpAddr)
    begin
        if jump = '1' then
            nextAddress <= jumpAddr;
        elsif PCSrc = '1' then
            nextAddress <= branchAddr;
        else
            nextAddress <= addrInc;
        end if;
    end process;
            

ROM_process: process(address)
    begin
        instruction <= rom(to_integer(unsigned(address(4 downto 0))));
    end process;
    
nextAddr <= addrInc;

end Behavioral;
