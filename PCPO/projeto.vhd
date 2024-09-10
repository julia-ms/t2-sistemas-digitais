-- Nomes: Julia Mombach da Silva e Henry Ribeiro Piceni
-- Explorando o paralelismo do Hardware: uma comparação entre algoritmo PCxPO E HLS.



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;



entity ParallelHardware is
    Port ( start : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           entrada : in STD_LOGIC_VECTOR (0 to 511);
           done : out STD_LOGIC;
           MatrizResposta : out STD_LOGIC_VECTOR (0 to 63));
end ParallelHardware;

architecture Behavioral of ParallelHardware is
-- tipos de dados personalizados
type estados is (S0,S1,S2);
type Matriz_4x4 is array (0 to 3, 0 to 3) of signed(7 downto 0);
type Matriz_2x2 is array (0 to 1, 0 to 1) of signed(7 downto 0);
type MatrizF is array (0 to 1, 0 to 1) of signed(15 downto 0);

-- sinais
signal MatrizA, MatrizB, MatrizC, MatrizD : Matriz_4x4;
signal MatrizAc : Matriz_2x2;
signal MatrizFinal : MatrizF;
signal atual, prox : estados;

signal rstA, rstB, rstC, rstD, rstSomas : STD_LOGIC;
signal loadA, loadB, loadC, loadD : STD_LOGIC;
signal doneA, doneB, doneC, doneD : boolean := false;
signal multiplica, pronto : STD_LOGIC := '0';

begin

-- responsável por atualizar o estado atual
process(clk, rst) 
begin 
    if rst = '1' then 
        atual <= S0;
    elsif rising_edge(clk) then 
        atual <= prox;
    end if;
end process;

-- lógica combinacional que controla os estados
process(atual, start, doneA, doneB, doneC, doneD)
begin
    case atual is
        when S0 => 
                   rstA <= '1';
                   rstB <= '1';
                   rstC <= '1';
                   rstD <='1';                  
                   loadA <= '0';
                   loadB <= '0';
                   loadC <= '0';
                   loadD <= '0';                 
                   multiplica <= '0';
                   
                   if start = '0' then 
                        prox <= S0; 
                   elsif start = '1' then
                        prox <= S1;
                   end if;
                   
        when S1 => 
                   rstA <= '0';
                   rstB <= '0';
                   rstC <= '0';
                   rstD <='0';                   
                   loadA <= '1';
                   loadB <= '1';
                   loadC <= '1';
                   loadD <= '1';     
                   multiplica <= '0';                  
                   if doneA = true and doneB = true and doneC = true and doneD = true then 
                        prox <= S2;
                   else 
                        prox <= S1;
                   end if;
                        
        when S2 => 
                   rstA <= '0';
                   rstB <= '0';
                   rstC <= '0';
                   rstD <='0';                    
                   loadA <= '0';
                   loadB <= '0';
                   loadC <= '0';
                   loadD <= '0';     
                   multiplica <= '1';       
                   if pronto = '1' then
                        prox <= S2;
                   elsif start = '0' then 
                        prox <= S0;
                   end if;   
    end case;
end process;

-- Matriz A
process(clk, rstA)
    variable acumulador : signed(7 downto 0);
begin 
    if rstA = '1' then -- reseta a matriz 
    
        doneA <= false;
        acumulador := (others => '0');        
        MatrizAc(0,0) <= (others => '0');   
            
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                MatrizA(i,j) <= (others => '0');
            end loop;
        end loop;      
        
    elsif rising_edge(clk) then 
        if loadA = '1' then -- preenche a matriz de entrada
            acumulador := (others => '0');
            for i in 0 to 3 loop
                for j in 0 to 3 loop      
                    MatrizA(i,j) <= to_signed(to_integer(unsigned( entrada(8 * (i * 4 + j) to 8 * (i * 4 + j) + 7))), 8);
                    acumulador := acumulador + MatrizA(i,j);               
                end loop;
            end loop;           
            MatrizAc(0,0) <= acumulador / 16; 
            doneA <= true;
        else -- senão, recebe ela mesma
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    MatrizA(i,j) <= MatrizA(i,j);
                end loop;
            end loop;
        end if;
        
    end if;    
end process;

-- Matriz B
process(clk, rstB)
    variable acumulador : signed(7 downto 0);
begin 
    if rstB = '1' then -- reseta a matriz
        doneB <= false;
        acumulador := (others => '0');
        MatrizAc(0,1) <= (others => '0');
        
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                MatrizB(i,j) <= (others => '0');
            end loop;
        end loop;
        
    elsif rising_edge(clk) then 
        if loadB = '1' then -- preenche a matriz
            acumulador := (others => '0');
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    --MatrizB(i,j) <= to_signed(to_integer(unsigned( B(8 * (i * 4 + j) to 8 * (i * 4 + j) + 7))), 8);
                    MatrizB(i,j) <= to_signed(to_integer(unsigned( entrada(8 * (i * 4 + j) + 128 to 8 * (i * 4 + j) + 135))), 8);
                    acumulador := acumulador + MatrizB(i,j);
                end loop;
            end loop;
            MatrizAc(0,1) <= acumulador / 16;
            doneB <= true;
            
        else -- senão, recebe ela mesma
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    MatrizB(i,j) <= MatrizB(i,j);
                end loop;
            end loop;
        end if;
        
    end if;    
end process;

-- Matriz C
process(clk, rstC)
    variable acumulador : signed(7 downto 0);
begin 
    if rstC = '1' then -- reseta a matriz
        doneC <= false;
        acumulador := (others => '0');
        MatrizAc(1,0) <= (others => '0');
        
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                MatrizC(i,j) <= (others => '0');
            end loop;
        end loop;

    elsif rising_edge(clk)then 
        if loadC = '1' then -- preenche a matriz 
            acumulador := (others => '0');
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    --MatrizC(i,j) <= to_signed(to_integer(unsigned( C(8 * (i * 4 + j) to 8 * (i * 4 + j) + 7))), 8);
                    MatrizC(i,j) <= to_signed(to_integer(unsigned( entrada(8 * (i * 4 + j) + 256 to 8 * (i * 4 + j) + 263))), 8);
                    acumulador := acumulador + MatrizC(i,j);
                end loop;
            end loop;
            
            MatrizAc(1,0) <= acumulador / 16;
         
            doneC <= true;
            
        else -- senão, recebe ela mesma
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    MatrizC(i,j) <= MatrizC(i,j);
                end loop;
            end loop;
        end if;
        
    end if;    
end process;

-- Matriz D
process(clk, rstD)
    variable acumulador : signed(7 downto 0);
begin 
    if rstD = '1' then -- reseta a matriz
        doneD <= false;
        acumulador := (others => '0');
        MatrizAc(1,1) <= (others => '0');
        
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                MatrizD(i,j) <= (others => '0');
            end loop;
        end loop;
        
    elsif rising_edge(clk)then 
        if loadD = '1' then -- preenche a matriz 
            acumulador := (others => '0');
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    --MatrizD(i,j) <= to_signed(to_integer(unsigned( D(8 * (i * 4 + j) to 8 * (i * 4 + j) + 7))), 8);
                    MatrizD(i,j) <= to_signed(to_integer(unsigned( entrada(8 * (i * 4 + j) + 384 to 8 * (i * 4 + j) + 391))), 8);
                    acumulador := acumulador + MatrizD(i,j);
                    
                end loop;
            end loop;
            
            MatrizAc(1,1) <= acumulador / 16;
            
            doneD <= true;
            
        else -- senão, recebe ela mesma
            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    MatrizD(i,j) <= MatrizD(i,j);
                end loop;
            end loop;
        end if;
    end if;    
end process;

-- Quando tudo estiver pronto, multiplica a matriz "MatrizAc" por ela mesma
process(multiplica) 
begin
    if doneA = true and doneB = true and doneC = true and doneD = true then
        MatrizFinal(0,0) <= MatrizAc(0,0) * MatrizAc(0,0) + MatrizAc(1,0) * MatrizAc(0,1);
        MatrizFinal(0,1) <= MatrizAc(0,0) * MatrizAc(0,1) + MatrizAc(1,1) * MatrizAc(0,1);
        MatrizFinal(1,0) <= MatrizAc(1,0) * MatrizAc(0,0) + MatrizAc(1,1) * MatrizAc(1,0);
        MatrizFinal(1,1) <= MatrizAc(0,1) * MatrizAc(1,0) + MatrizAc(1,1) * MatrizAc(1,1);
        pronto <= '1';
    end if;
end process;

-- LIGANDO OS FIOS DE SAÍDA
done <= pronto;
MatrizResposta(0 to 15) <= STD_LOGIC_VECTOR(MatrizFinal(0,0));
MatrizResposta(16 to 31) <= STD_LOGIC_VECTOR(MatrizFinal(0,1));
MatrizResposta(32 to 47) <= STD_LOGIC_VECTOR(MatrizFinal(1,0));
MatrizResposta(48 to 63) <= STD_LOGIC_VECTOR(MatrizFinal(1,1));

end Behavioral;