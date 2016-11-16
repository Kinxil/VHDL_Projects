//Author : Anthony MAYOR-SERRA

//This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.

//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
//    GNU General Public License for more details.

//See <http://www.gnu.org/licenses/>. 

using System;
using System.IO;


namespace Colorgen
{
    class Program
    {
        static string[] Entete = { "library IEEE;",
            "use IEEE.STD_LOGIC_1164.ALL;",
            "use IEEE.NUMERIC_STD.ALL;\n",
            "library WORK;",
            "use WORK.CONSTANTS.ALL;\n",
            "entity Colorgen is",
            "\tPort ( iters : in STD_LOGIC_VECTOR (ITER_RANGE-1 downto 0);",
            "\tcolor: out STD_LOGIC_VECTOR (bit_per_pixel-1 downto 0));",
            "end Colorgen;\n",
            "architecture Behavioral of Colorgen is",
            "\ttype  rom_type is array (0 to ITER_MAX - 1) of std_logic_vector (bit_per_pixel-1 downto 0);",
            "\tconstant color_scheme : rom_type := (" };

        static string[] Pied = {");\n",
              "begin",
              "\tcolor <= color_scheme(to_integer(unsigned(iters)));",
              "end Behavioral;"};

        static void Main(string[] args)
        {
            int i, iters;
            float tempcolor = 0.0f;

            File.WriteAllLines(Directory.GetCurrentDirectory() + "\\Colorgen.vhd", Entete);
            Console.WriteLine("Nombre d'itérations ?\n");
            iters = Convert.ToInt32(Console.ReadLine());

            for (i = 0; i < iters; i++)
            {
                if (i < (iters / 6))
                    tempcolor = i * 6.0f / iters * 15.0f; //augmentation bleu

                else if (i < (iters / 3))
                    tempcolor = (float)Math.Ceiling((i * 6.0f / iters - 1) * 15.0f) * 16.0f + 15.0f;//bleu max, augmentation vert

                else if (i < (iters / 2))
                    tempcolor = 255.0f - (i - iters / 3.0f) * 6.0f / iters * 15.0f; //vert max, diminution bleu

                else if (i < (2 * iters / 3))
                    tempcolor = 240.0f + (float)Math.Ceiling(3.0f * (i * 2.0f / iters - 1.0f) * 15.0f) * 256.0f; //vert max, augmentation rouge

                else if (i < (5 * iters / 6))
                    tempcolor = 4080.0f - (float)Math.Ceiling((i - 2.0f * iters / 3.0f) * 6.0f / iters * 15.0f) * 16.0f; //rouge max, diminution vert

                else if (i < iters) { 
                tempcolor = 3840.0f + (float)Math.Ceiling(6.0f/iters * (i - 5 * iters / 6) * 15.0f); //rouge max, augmentation bleu
                    Console.WriteLine((float)Math.Ceiling(6.0f/iters * (i - 5 * iters / 6) * 15.0f));
                }
                else
                    tempcolor = 0;

                File.AppendAllText(Directory.GetCurrentDirectory() + "\\Colorgen.vhd",
                    "\t\t\"" + Convert.ToString(Convert.ToInt32(tempcolor), 2).PadLeft(12, '0') + "\"");

                if (i < (iters - 1))
                    File.AppendAllText(Directory.GetCurrentDirectory() + "\\Colorgen.vhd", ",");
                File.AppendAllText(Directory.GetCurrentDirectory() + "\\Colorgen.vhd", "\n");
            }

            File.AppendAllLines(Directory.GetCurrentDirectory() + "\\Colorgen.vhd", Pied);

            File.AppendAllText(Directory.GetCurrentDirectory() + "\\Colorgen.vhd",
                "\n\n--Cut and paste following lines into Shared.vhd.\n"
                + "--\tconstant ITER_MAX : integer := " + iters + ";\n"
                + "--\tconstant ITER_RANGE : integer := " + Math.Ceiling(Math.Log(iters,2)) + ";\n"
                );

            Console.WriteLine("La ROM a été créée, appuyer sur une touche pour fermer le programme.");
            Console.ReadKey();
        }
    }
}
