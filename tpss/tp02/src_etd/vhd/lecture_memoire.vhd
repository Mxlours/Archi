library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lecture_memoire is
    port (data : out unsigned(31 downto 0);
          clk : in std_logic;
          rst : in std_logic);
end lecture_memoire;

architecture mixte of lecture_memoire is

  component Compteur is
	  generic (n: positive := 15);
	  port (cpt : out unsigned(n-1 downto 0);
	        max : in unsigned(n-1 downto 0);
	        clk : in std_logic;
	        rst : in std_logic);
  end component;

  component RAM_Video is
    port (
      clk  : in    std_logic; -- horloge
      addr : in    unsigned(14 downto 0); -- bus d'adresse
      do   : out   unsigned(31 downto 0); -- bus de données 
      we   : in    std_logic -- sélecteur lecture (0) /écriture (1)
      );
  end component;

  signal adresse : unsigned(14 downto 0);
  signal contenu : unsigned(31 downto 0);
  -- Ajouter ici les signaux internes nécessaires
  -- Utiliser les mêmes types de signaux en interne que vu en externe
  
begin
-- Quelques indices sur la représentation des constantes :
-- Les constantes pour le type std_logic s'exprime entre simple quote : '0' ou '1'.
-- Pour les types vecteurs de bits (comme le type unsigned), on utilise des guillements.
-- Par exemple, "000" pour un vecteur 3 bits.
-- Il est possible d'utiliser une notation hexadécimale pour faire plus compacte.
-- x"0D" représente ainsi une constante correspondant à un vecteur de 8 bits.
-- Cette notation ne supporte que les vecteurs d'une taille multiple de 4.
-- On peut utiliser l'opérateur de concaténation & pour s'adapter aux autres tailles.
-- Par exemple, "00"&x"0D" sera sur 10 bits.
-- Rappelons aussi que la structure (others => Une_valeur_binaire ) peut être utilisée pour fixer tous les bits d'un vecteur à la même valeur.
-- A COMPLETER
  Clock: Compteur
    -- completer pour decrire le branchement des ports :
    port map (
      cpt => adresse,
      max => "111"&X"FFF",
      clk => clk,
      rst => rst
    );

  Memoire: RAM_Video
    port map (
      we => '0',
      clk => clk,
      addr => adresse,
      do => contenu);
  data <= contenu;
end mixte;
