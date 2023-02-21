library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PC is
    port (
        clk  : in std_logic;
        reset: in std_logic;
        start: in std_logic;
        inf  : in std_logic;
        egal : in std_logic;
        getA : out std_logic;
        getB : out std_logic;
        subBA: out std_logic;
        ldA  : out std_logic;
        ldB  : out std_logic;
        done : out std_logic
    );
end PC;

architecture mixte of PC is
  type Etat_type is (sInit,sTest,AminusB,BminusA,sEnd,sWait);
  -- Définir ici le nécessaire pour la réalisation de l'automate.
  -- Attention à ne pas utiliser pour les noms des états des mots clés du langage comme
  -- wait, end, init... Par exemple nommer l'état "wait" sWait (comme "state Wait")
  signal Etat_courant, Etat_futur: Etat_type;
begin
-- A completer
-- Ici pour la partie bascules D
  Registre : process (clk) 
  begin
    if rising_edge(clk) then
            if reset='1' then
              Etat_courant <= sWait; 
        -- n n'étant pas connu. On ne peut plus utiliser l'initialisation avec une constante. 
        -- Le mot clé "others" permet de définir tous les valeurs d'un vecteur qui n'ont pas encore été définis.
          -- Ici, chaque bit du vecteur prendra la valeur '0'
            else
            Etat_courant <= Etat_futur;
            end if;
          end if;
  end process;
-- Ici pour la description des transition (état futur en fonction de l'état courant et des entrées)
-- et pour déterminer les sorties pour chaque état
  Combinatoire : process (Etat_courant,egal,start,inf
    -- Liste de sensibilité à compléter avec tous les signaux entrants des fonctions combinatoires
    )
  begin
    getA <= '0';
    ldA <= '0';
    getB <= '0';
    ldB <= '0';
    subBA <= '0';
    done <= '0';
    case Etat_courant is  -- Dans un process, on peut utiliser une structure de type case (mots clés :  case et is)
      when sWait => -- comprendre : quand Etat_courant vaut A faire ...
        getA <= '0';
        ldA <= '0';
        getB <= '0';
        ldB <= '0';
        subBA <= '0';
        done <= '0';
        if start = '0' then -- Dans un process, on peut aussi utiliser un if/then/else
          Etat_futur <= sWait;
        else
          Etat_futur <= sInit;
        end if;
      when sInit =>
        getA <= '1';
        ldA <= '1';
        getB <= '1';
        ldB <= '1';
        subBA <= '0';
        done <= '0';
        Etat_futur <= sTest;
      when sTest =>
        getA <= '0';
        ldA <= '0';
        getB <= '0';
        ldB <= '0';
        subBA <= '0';
        done <= '0';
        if egal = '1' then -- Dans un process, on peut aussi utiliser un if/then/else
          Etat_futur <= sEnd;
        else
          if inf ='1' then
            Etat_futur <= BminusA;
          else
            Etat_futur <= AminusB;
          end if;
        end if;
      when BminusA =>
        getA <= '0';
        ldA <= '0';
        getB <= '0';
        ldB <= '1';
        subBA <= '1';
        done <= '0';
        Etat_futur <= sTest;
      when AminusB =>
        getA <= '0';
        ldA <= '1';
        getB <= '0';
        ldB <= '0';
        subBA <= '0';
        done <= '0';
        Etat_futur <= sTest;
      when sEnd =>
        getA <= '0';
        ldA <= '0';
        getB <= '0';
        ldB <= '0';
        subBA <= '0';
        done <= '1';
        Etat_futur <= sWait;
  -- A vous de jouer
    end case; -- fin de la structure case
  end process;
end mixte;
