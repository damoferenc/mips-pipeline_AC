----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 10:36:44 AM
-- Design Name: 
-- Module Name: mips - Behavioral
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

entity mips is
    Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end mips;

architecture Behavioral of mips is

component mpg is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;


component ssd is
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component i_f is
    Port ( clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       branchAddr : in STD_LOGIC_VECTOR (15 downto 0);
       jumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
       jump : in STD_LOGIC;
       PCSrc : in STD_LOGIC;
       instruction : out STD_LOGIC_VECTOR (15 downto 0);
       nextAddr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component id is
    Port ( clk : in STD_LOGIC;
       en : in STD_LOGIC;
       RegWrite : in STD_LOGIC;
       ExtOp : in STD_LOGIC;
       WD : in STD_LOGIC_VECTOR (15 downto 0);
       Instr : in STD_LOGIC_VECTOR (15 downto 0);
       writeAddr : in STD_LOGIC_VECTOR(2 downto 0);
       nextAddr : in STD_LOGIC_VECTOR(15 downto 0);
       RD1 : out STD_LOGIC_VECTOR (15 downto 0);
       RD2 : out STD_LOGIC_VECTOR (15 downto 0);
       Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
       func : out STD_LOGIC_VECTOR (2 downto 0);
       sa : out STD_LOGIC;
       jumpAddr : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component uc is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchOnEqual : out STD_LOGIC;
           BranchOnGreaterOrEqualToZero : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           SLTIU : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ex is
    Port ( nextAddress : in STD_LOGIC_VECTOR(15 downto 0);
       rd1 : in STD_LOGIC_VECTOR (15 downto 0);
       rd2 : in STD_LOGIC_VECTOR (15 downto 0);
       ALUSrc : in STD_LOGIC;
       Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
       sa : in STD_LOGIC;
       func : in STD_LOGIC_VECTOR (2 downto 0);
       ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
       Instr : in STD_LOGIC_VECTOR(15 downto 0);
       RegDst : in STD_LOGIC;
       Zero : out STD_LOGIC;
       greaterOrEqual : out STD_LOGIC;
       less : out STD_LOGIC;
       ALURes : out STD_LOGIC_VECTOR (15 downto 0);
       branchAddress : out STD_LOGIC_VECTOR(15 downto 0);
       wa : out STD_LOGIC_VECTOR(2 downto 0));
end component;

component mem is
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
end component;

component wb is
    Port ( MemtoReg : in STD_LOGIC;
       ALUResOut : in STD_LOGIC_VECTOR (15 downto 0);
       MemData : in STD_LOGIC_VECTOR (15 downto 0);
       SLTIU : in STD_LOGIC;
       greaterOrEqual : in STD_LOGIC;
       WD : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal enable, reset : STD_LOGIC := '0' ;
signal digits, do : STD_LOGIC_VECTOR (15 downto 0);
signal wd, rd1, rd2, Ext_Imm, jumpAddr, instruction, nextAddr : STD_LOGIC_VECTOR (15 downto 0);
signal func, wa2 : STD_LOGIC_VECTOR (2 downto 0);
signal RegDst :  STD_LOGIC;
signal ExtOp :  STD_LOGIC;
signal ALUSrc :  STD_LOGIC;
signal BranchOnEqual :  STD_LOGIC;
signal BranchOnGreaterOrEqualToZero :  STD_LOGIC;
signal Jump :  STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0);
signal MemWrite :  STD_LOGIC;
signal MemtoReg :  STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal sa : STD_LOGIC;
signal Zero : STD_LOGIC;
signal greaterOrEqual : STD_LOGIC;
signal less : STD_LOGIC;
signal ALURes, branchAddress, ALUResOut, MemData : STD_LOGIC_VECTOR(15 downto 0);
signal PCSrc, SLTIU : STD_LOGIC;

signal if_nextAddr, if_instr : STD_LOGIC_VECTOR(15 downto 0);
signal id_nextAddr, id_rd1, id_rd2, id_extImm : STD_LOGIC_VECTOR(15 downto 0);
signal id_func, writeAddr : STD_LOGIC_VECTOR(2 downto 0);
signal id_wb : STD_LOGIC_VECTOR(2 downto 0);
signal id_ex, id_m : STD_LOGIC_VECTOR(3 downto 0);
signal id_sa : STD_LOGIC;
signal id_instruction : STD_LOGIC_VECTOR(15 downto 0);
signal ex_branchAddr, ex_alu, ex_rd2 : STD_LOGIC_VECTOR(15 downto 0);
signal ex_m : STD_LOGIC_VECTOR(3 downto 0);
signal ex_wb : STD_LOGIC_VECTOR(2 downto 0);
signal ex_zero, ex_ge : STD_LOGIC;
signal ex_wa : STD_LOGIC_VECTOR(2 downto 0);
signal mem_memdata, mem_alu : STD_LOGIC_VECTOR(15 downto 0);
signal mem_wb : STD_LOGIC_VECTOR(2 downto 0);
signal mem_wa : STD_LOGIC_VECTOR(2 downto 0);
signal mem_ge : STD_LOGIC;

begin

 c1: mpg port map(btn(4),clk,enable);
 c4: mpg port map(btn(3),clk,reset);
 c2: ssd port map(clk, digits(3 downto 0), digits(7 downto 4), digits(11 downto 8), digits(15 downto 12), cat, an);
 c3: i_f port map(clk, enable, reset, ex_branchAddr, jumpAddr, Jump, PCSrc, instruction, nextAddr);
 c5: id port map(clk,enable, mem_wb(0), ExtOp, wd, if_instr, mem_wa, if_nextAddr, rd1, rd2, Ext_Imm, func, sa,jumpAddr );
 c6: uc port map(if_instr(15 downto 13), RegDst, ExtOp, ALUSrc, BranchOnEqual, BranchOnGreaterOrEqualToZero,
                 Jump, ALUOp, MemWrite, MemtoReg,SLTIU, RegWrite);
 c7: ex port map(id_nextAddr, id_rd1, id_rd2, id_ex(1), id_extImm, id_sa, id_func, id_ex(3 downto 2),
                 id_instruction,id_ex(0), Zero, greaterOrEqual, less, ALURes,branchAddress, wa2 );
 c8: mem port map(ex_m(2), clk, enable, ex_alu, ex_rd2,ex_m(1),ex_m(0),ex_zero,ex_ge, ALUResOut, MemData,PCSrc );
 c9: wb port map(mem_wb(1), mem_alu, mem_memdata, mem_wb(2), mem_ge, wd );

 process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if_nextAddr <= nextAddr;
                if_instr <= instruction;
                
                id_nextAddr <= if_nextAddr;
                id_rd1 <= rd1;
                id_rd2 <= rd2;
                id_extImm <= Ext_imm;
                id_func <= func;
                id_wb <= SLTIU & MemtoReg & RegWrite;
                id_m <= SLTIU & MemWrite & BranchOnEqual & BranchOnGreaterOrEqualToZero ;
                id_ex <= ALUOp & ALUSrc & RegDst;
                id_sa <= sa;
                id_instruction <= if_instr;
                
                ex_branchAddr <= branchAddress;
                ex_alu <= ALURes;
                ex_rd2 <= id_rd2;
                ex_wb <= id_wb;
                ex_m <= id_m;
                ex_zero <= Zero;
                ex_ge <= greaterOrEqual;
                ex_wa <=wa2;
                
                mem_memdata <= memData;
                mem_alu <= ALUResOut;
                mem_wb <= ex_wb;
                mem_wa <= ex_wa;
                mem_ge <= ex_ge;
            end if;
        end if;
 end process;
 
 
process(sw(7 downto 5))
    begin
        case sw(7 downto 5) is
            when "000" =>
                digits <= instruction;
            when "001" =>
                digits <= nextAddr;
            when "010" =>
                digits <= rd1;
            when "011" =>
                digits <= rd2;
            when "100" =>
                digits <= Ext_Imm;
            when "101" =>
                digits <= ALURes;
            when "110" =>
                digits <= MemData;
            when others =>
                digits <= wd;
        end case;
    end process;
 


led(0) <= RegDst;
led(1) <= ExtOp;
led(2) <= ALUSrc;
led(3) <=  BranchOnEqual;
led(4) <=  Jump;
led(5) <=  MemWrite;
led(6) <=  MemtoReg;
led(7) <=  RegWrite;
led(8) <= BranchOnGreaterOrEqualToZero;
led(9) <= SLTIU;
led(11 downto 10) <=  ALUOp;

end Behavioral;
