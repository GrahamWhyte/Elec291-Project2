@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\Graham\Documents\GitHub\Elec291-Project2\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.c"
if not exist hex2mif.exe goto done
if exist Reciever.ihx hex2mif Reciever.ihx
if exist Reciever.hex hex2mif Reciever.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\Graham\Documents\GitHub\Elec291-Project2\Reciever.hex
