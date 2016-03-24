@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\Graham\Documents\GitHub\Elec291-Project2\Sample Code\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\Graham\Documents\GitHub\Elec291-Project2\Sample Code\freq_gen.c"
if not exist hex2mif.exe goto done
if exist freq_gen.ihx hex2mif freq_gen.ihx
if exist freq_gen.hex hex2mif freq_gen.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\Graham\Documents\GitHub\Elec291-Project2\Sample Code\freq_gen.hex
