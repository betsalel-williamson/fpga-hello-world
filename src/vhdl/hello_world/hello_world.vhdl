--  Hello world program
  use std.textio.all; -- Imports the standard textio package.

--  Defines a design entity, without any ports.

entity hello_world is
end entity hello_world;

architecture behaviour of hello_world is

begin

  p_hello_world : process is

    variable l : line;

  begin

    write (l, String'("Hello world VHDL!"));
    writeline (output, l);
    wait;

  end process p_hello_world;

end architecture behaviour;
