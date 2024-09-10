-- Nomes: Julia Mombach da Silva e Henry Ribeiro Piceni
-- Explorando o paralelismo do Hardware: uma comparação entre algoritmo PCxPO E HLS.
-- TESTBENCH



library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ParallelHardware_tb is
end;

architecture bench of ParallelHardware_tb is

  component ParallelHardware
      Port ( start : in STD_LOGIC;
             clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             --A : in STD_LOGIC_VECTOR (0 to 127);
             --B : in STD_LOGIC_VECTOR (0 to 127);
             --C : in STD_LOGIC_VECTOR (0 to 127);
             --D : in STD_LOGIC_VECTOR (0 to 127);
             entrada : in STD_LOGIC_VECTOR (0 to 511);
             done : out STD_LOGIC;
             MatrizResposta : out STD_LOGIC_VECTOR (0 to 63));
  end component;

  signal start: STD_LOGIC;
  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  --signal A: STD_LOGIC_VECTOR (0 to 127);
  --signal B: STD_LOGIC_VECTOR (0 to 127);
  --signal C: STD_LOGIC_VECTOR (0 to 127);
  --signal D: STD_LOGIC_VECTOR (0 to 127);
  signal entrada : STD_LOGIC_VECTOR (0 to 511);
  signal done: STD_LOGIC;
  signal MatrizResposta: STD_LOGIC_VECTOR (0 to 63);
  --signal rstA, loadA : std_logic;
  --signal atual, prox;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: ParallelHardware port map ( start          => start,
                                   clk            => clk,
                                   rst            => rst,
                                   --A              => A,
                                  -- B              => B,
                                   --C              => C,
                                   --D              => D,
                                   entrada => entrada,
                                   done           => done,
                                   MatrizResposta => MatrizResposta 
                                   );

  stimulus: process
  begin
  
    -- Put initialisation code here

    rst <= '1';
    wait for 5 ns;
    rst <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here
    --A <= "00000001000000100000001100000100111111111111111011111101111111000000000100000010000000110000010011111111111111101111110111111100";
    --C <= "00000001000000100000001100000100111111101111111011111110111111100000000100000010000000110000010011111110111111101111111011111110";
    --B <= "00000101000001010000010100000101111110111111101011111001111110000000010100000101000001010000010111111011111110101111100111111000";
    --D <= "00000101000001100000011100001000111111101111111011111110111111100000010100000110000001110000100011111110111111101111111011111110";
    --entrada <= "00000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001100000011000000110000001100000011000000110000001100000011000000110000001100000011000000110000001100000011000000110000001100000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100";
    entrada <= "00000001000000100000001100000100111111111111111011111101111111000000000100000010000000110000010011111111111111101111110111111100000001010000010100000101000001011111101111111010111110011111100000000101000001010000010100000101111110111111101011111001111110000000000100000010000000110000010011111110111111101111111011111110000000010000001000000011000001001111111011111110111111101111111000000101000001100000011100001000111111101111111011111110111111100000010100000110000001110000100011111110111111101111111011111110";
    wait for 5ns;
    start <= '1';
    --report "Valor de MatrizAc(0,0) = " & to_string(MatrizAc(0,0));
    wait until done = '1';
    start <= '0';
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;
  