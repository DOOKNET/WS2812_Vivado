@echo off
set xv_path=E:\\Softwares\\Vivado\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 865c2cc94ddd4dcba93ca6e7b48bc4a8 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_RZ_behav xil_defaultlib.tb_RZ xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
