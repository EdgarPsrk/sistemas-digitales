-- Definición de la entidad prom_initials
entity prom_initials is
    port (
        addr: in std_logic_vector(3 downto 0); -- Puerto de entrada para la dirección de lectura
        M: out std_logic_vector(0 to 31)       -- Puerto de salida para los datos leídos desde la ROM
    );
end prom_initials;

-- Implementación de la arquitectura Behavioral de la entidad prom_initials
architecture Behavioral of prom_initials is
    -- Tipo de arreglo para representar la memoria ROM
    type rom_array is array (NATURAL range <>) of std_logic_vector(0 to 31);
    
    -- Constante que define los datos almacenados en la ROM
    constant rom: rom_array := (
        "01111111100100000000011111111000", -- 0
        "00000100000100000000010000000100", -- 1
        "00000100000100000000010000000010", -- 2
        "00000100000100000000010000000010", -- 3
        "00000100000100000000010000000010", -- 4
        "00000100000100000000010000000100", -- 5
        "00000100000100000000010000001000", -- 6
        "00000100000100000000011111110000", -- 7
        "00000100000100000000010000001000", -- 8
        "00000100000100000000010000000100", -- 9
        "00000100000100000000010000000010", -- A
        "01000100000100000000010000000010", -- B
        "01000100000100000000010000000010", -- C
        "01000100000100000000010000000010", -- D
        "01000100000100000000010000000010", -- E
        "00111000000111111110011111111100"  -- F
    );
    -- Un "0" = pixel apagado
    -- Un "1" = el pixel correspondiente aparecerá en la pantalla
    
    -- Proceso para leer datos desde la ROM
    -- La salida M contiene el dato leído de la dirección dada por addr
    -- El proceso es sensitivo a cambios en la señal addr
    begin
    process (addr)
        variable j: integer;
    begin
        j := conv_integer(addr);  -- Convierte la dirección a un valor entero
        M <= rom(j);              -- Coloca el dato correspondiente en la salida M
    end process;
end Behavioral;
