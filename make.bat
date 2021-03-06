@echo off


set Path=%Path%;C:\Users\ragozini_a\Documents\SDCC\bin


rem set CCFLAGS=-mz80 --opt-code-speed --std-c11 --no-std-crt0 --nostdlib --max-allocs-per-node 20000 
set CCFLAGS=-mz80 --opt-code-speed --std-c11 --no-std-crt0 --nostdlib --max-allocs-per-node 200000 
set RAM_ADDR=0xc000
set BANK0_SIZE=0x3000
set BANKn_SIZE=0x4000

set  BANK0_ADDR=0x004100
set  BANK2_ADDR=0x028000
set  BANK4_ADDR=0x048000
set  BANK6_ADDR=0x068000
set  BANK8_ADDR=0x088000
set BANK10_ADDR=0x0a8000
set BANK12_ADDR=0x0c8000
set BANK14_ADDR=0x0e8000

set BANK16_ADDR=0x108000
set BANK18_ADDR=0x128000
set BANK20_ADDR=0x148000
set BANK22_ADDR=0x168000
set BANK24_ADDR=0x188000
set BANK26_ADDR=0x1a8000
set BANK28_ADDR=0x1c8000
set BANK30_ADDR=0x1e8000

set BANK32_ADDR=0x208000
set BANK34_ADDR=0x228000
set BANK36_ADDR=0x248000
set BANK38_ADDR=0x268000
set BANK40_ADDR=0x288000
set BANK42_ADDR=0x2a8000
set BANK44_ADDR=0x2c8000
set BANK46_ADDR=0x2e8000

set BANK48_ADDR=0x308000
set BANK50_ADDR=0x328000
set BANK52_ADDR=0x348000
set BANK54_ADDR=0x368000
set BANK56_ADDR=0x388000
set BANK58_ADDR=0x3a8000
set BANK60_ADDR=0x3c8000
set BANK62_ADDR=0x3e8000


set BANKS_ADDR=-Wl-b_BANK0=%BANK0_ADDR% -Wl-b_BANK2=%BANK2_ADDR% -Wl-b_BANK4=%BANK4_ADDR% -Wl-b_BANK6=%BANK6_ADDR% -Wl-b_BANK8=%BANK8_ADDR% -Wl-b_BANK10=%BANK10_ADDR% -Wl-b_BANK12=%BANK12_ADDR% -Wl-b_BANK14=%BANK14_ADDR% -Wl-b_BANK16=%BANK16_ADDR% -Wl-b_BANK18=%BANK18_ADDR% -Wl-b_BANK20=%BANK20_ADDR% -Wl-b_BANK22=%BANK22_ADDR% -Wl-b_BANK24=%BANK24_ADDR% -Wl-b_BANK26=%BANK26_ADDR% -Wl-b_BANK28=%BANK28_ADDR% -Wl-b_BANK30=%BANK30_ADDR% -Wl-b_BANK32=%BANK32_ADDR% -Wl-b_BANK34=%BANK34_ADDR% -Wl-b_BANK36=%BANK36_ADDR% -Wl-b_BANK38=%BANK38_ADDR% -Wl-b_BANK40=%BANK40_ADDR% -Wl-b_BANK42=%BANK42_ADDR% -Wl-b_BANK44=%BANK44_ADDR% -Wl-b_BANK46=%BANK46_ADDR% -Wl-b_BANK48=%BANK48_ADDR% -Wl-b_BANK50=%BANK50_ADDR% -Wl-b_BANK52=%BANK52_ADDR% -Wl-b_BANK54=%BANK54_ADDR% -Wl-b_BANK56=%BANK56_ADDR% -Wl-b_BANK58=%BANK58_ADDR% -Wl-b_BANK60=%BANK60_ADDR% -Wl-b_BANK62=%BANK62_ADDR% 

set BUILD=build\

set TMP=build\

rem needed for intermediate files

mkdir %TMP% >nul: 2>nul:

rem needed by openmsx config

mkdir dska >nul: 2>nul:

sdasz80 -o %BUILD%megarom.rel src\megarom.s 
sdasz80 -o %BUILD%audio.rel src\audio.s 

						
sdcc %CCFLAGS% -o	%BUILD%mytestrom.rel 	--codeseg BANK0 --code-size %BANK0_SIZE% -c src\mytestrom.c 	
										
sdcc %CCFLAGS% -o	%BUILD%L0data0.rel		--codeseg BANK2 --code-size %BANKn_SIZE% -c src\L0data0.c		
sdcc %CCFLAGS% -o	%BUILD%L0data1.rel		--codeseg BANK4 --code-size %BANKn_SIZE% -c src\L0data1.c		
sdcc %CCFLAGS% -o	%BUILD%L0data2.rel		--codeseg BANK6 --code-size %BANKn_SIZE% -c src\L0data2.c		
sdcc %CCFLAGS% -o	%BUILD%L0data3.rel		--codeseg BANK8 --code-size %BANKn_SIZE% -c src\L0data3.c		

sdcc %CCFLAGS% -o	%BUILD%L1data0.rel		--codeseg BANK10 --code-size %BANKn_SIZE% -c src\L1data0.c		
sdcc %CCFLAGS% -o	%BUILD%L1data1.rel		--codeseg BANK12 --code-size %BANKn_SIZE% -c src\L1data1.c		
sdcc %CCFLAGS% -o	%BUILD%L1data2.rel		--codeseg BANK14 --code-size %BANKn_SIZE% -c src\L1data2.c		
sdcc %CCFLAGS% -o	%BUILD%L1data3.rel		--codeseg BANK16 --code-size %BANKn_SIZE% -c src\L1data3.c		

sdcc %CCFLAGS% -o	%BUILD%L2data0.rel		--codeseg BANK18 --code-size %BANKn_SIZE% -c src\L2data0.c		
sdcc %CCFLAGS% -o	%BUILD%L2data1.rel		--codeseg BANK20 --code-size %BANKn_SIZE% -c src\L2data1.c		
sdcc %CCFLAGS% -o	%BUILD%L2data2.rel		--codeseg BANK22 --code-size %BANKn_SIZE% -c src\L2data2.c		
sdcc %CCFLAGS% -o	%BUILD%L2data3.rel		--codeseg BANK24 --code-size %BANKn_SIZE% -c src\L2data3.c		

sdcc %CCFLAGS% -o	%BUILD%L3data0.rel		--codeseg BANK26 --code-size %BANKn_SIZE% -c src\L3data0.c		
sdcc %CCFLAGS% -o	%BUILD%L3data1.rel		--codeseg BANK28 --code-size %BANKn_SIZE% -c src\L3data1.c		
sdcc %CCFLAGS% -o	%BUILD%L3data2.rel		--codeseg BANK30 --code-size %BANKn_SIZE% -c src\L3data2.c		
sdcc %CCFLAGS% -o	%BUILD%L3data3.rel		--codeseg BANK32 --code-size %BANKn_SIZE% -c src\L3data3.c		
										
sdcc %CCFLAGS% -o	%BUILD%L4data0.rel		--codeseg BANK34 --code-size %BANKn_SIZE% -c src\L4data0.c		
sdcc %CCFLAGS% -o	%BUILD%L4data1.rel		--codeseg BANK36 --code-size %BANKn_SIZE% -c src\L4data1.c		
sdcc %CCFLAGS% -o	%BUILD%L4data2.rel		--codeseg BANK38 --code-size %BANKn_SIZE% -c src\L4data2.c		
sdcc %CCFLAGS% -o	%BUILD%L4data3.rel		--codeseg BANK40 --code-size %BANKn_SIZE% -c src\L4data3.c		

sdcc %CCFLAGS% -o	%BUILD%L5data0.rel		--codeseg BANK42 --code-size %BANKn_SIZE% -c src\L5data0.c		
sdcc %CCFLAGS% -o	%BUILD%L5data1.rel		--codeseg BANK44 --code-size %BANKn_SIZE% -c src\L5data1.c		
sdcc %CCFLAGS% -o	%BUILD%L5data2.rel		--codeseg BANK46 --code-size %BANKn_SIZE% -c src\L5data2.c		
sdcc %CCFLAGS% -o	%BUILD%L5data3.rel		--codeseg BANK48 --code-size %BANKn_SIZE% -c src\L5data3.c		
										
sdcc %CCFLAGS% -o	%BUILD%data_levels.rel	--codeseg BANK50 --code-size %BANKn_SIZE% -c src\data_levels.c	
sdcc %CCFLAGS% -o	%BUILD%data_sprites.rel	--codeseg BANK52 --code-size %BANKn_SIZE% -c src\data_sprites.c
sdcc %CCFLAGS% -o	%BUILD%intro.rel		--codeseg BANK54 --code-size %BANKn_SIZE% -c src\intro.c	


REM sdcc %CCFLAGS% -o	%BUILD%audiodata.rel	--codeseg BANK58 --code-size %BANK0_SIZE% -c src\audiodata.c


sdcc %CCFLAGS% -o %BUILD%mytestrom.ihx --data-loc %RAM_ADDR% %BANKS_ADDR% %BUILD%megarom.rel  %BUILD%L0data0.rel %BUILD%L0data1.rel %BUILD%L0data2.rel %BUILD%L0data3.rel  %BUILD%L1data0.rel %BUILD%L1data1.rel %BUILD%L1data2.rel %BUILD%L1data3.rel  %BUILD%L2data0.rel %BUILD%L2data1.rel %BUILD%L2data2.rel %BUILD%L2data3.rel  %BUILD%L3data0.rel %BUILD%L3data1.rel %BUILD%L3data2.rel %BUILD%L3data3.rel  %BUILD%L4data0.rel %BUILD%L4data1.rel %BUILD%L4data2.rel %BUILD%L4data3.rel  %BUILD%L5data0.rel %BUILD%L5data1.rel %BUILD%L5data2.rel %BUILD%L5data3.rel  %BUILD%audio.rel %BUILD%data_levels.rel %BUILD%data_sprites.rel %BUILD%intro.rel %BUILD%mytestrom.rel

.\build_win\makerom.exe %BUILD%mytestrom.ihx mytestrom.rom

rem # -- Generate symbols for openmsx

py util\gensym.py build mytestrom 

setlocal EnableDelayedExpansion
 
rem # -- Self Path Indentifer. Do not change this part of the script
set SCRIPT_NAME=%~nx0
set CURRENT_DIR=%~dp0
set FULL_PATH= %~fs0
set sourcefile=%1
for %%f in (%sourcefile%) do set prog=%%~nf
for %%I in ("%~dp0.") do for %%J in ("%%~dpI.") do set PARENT_DIR=%%~dpnxJ

rem # -- End of Self Path Identifizer

set OPENMSX_APP_PATH=F:\openMSX\
set MSX_MACHINE_SCRIPT_PATH=F:\SDCC\MSX_Fusion-C_V1.3\WorkingFolder\sdcc_megarom-master\util\

start /b /d %PARENT_DIR%\sdcc_megarom-master %OPENMSX_APP_PATH%openmsx.exe -script %MSX_MACHINE_SCRIPT_PATH%2-emul_start_MSX2_config.txt  -carta mytestrom.rom

java -jar mdl.jar audio.asm -so-opt -po3 -asm auto -dialect sdcc -ansion