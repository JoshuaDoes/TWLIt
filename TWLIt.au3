#cs ---- REFERENCE ----
TWLTool v1.6.1
  by WulfyStylez
  Special thanks to CaitSith2

Usage: twltool <command> [args]
Commands:
  nandcrypt
  modcrypt
  boot2
  syscrypt
nandcrypt: (de)crypt DSi NAND
  --cid [file/hex CID]          eMMC CID
  --consoleid [file/hex ID]     DSi ConsoleID
  --in [infile]                 Input image
  --out [outfile]               Output file (optional)
  --3ds                         Crypt 3DS TWLNAND
    --3dsbrute                  Bruteforce 3DS ConsoleID
    --cidfile [outfile]         Output name for bruteforced CID (optional)
      --n3ds                    New3DS bruteforce (use with --3ds)
modcrypt: (de)crypt SRL modcrypt sections
  --in [infile]                 Input SRL
  --out [outfile]               Output file (optional)
boot2: decrypt boot2 image to arm7.bin and arm9.bin
  --in [infile]                 Input image
  --debug                       Crypt debug boot2 (devkits, TWL_FIRM, ...)
syscrypt: crypt system files with ES block crypto (dev.kp, tickets, ...)
  --in [infile]                 Input SRL
  --out [outfile]               Output file (optional)
  --consoleid [file/hex ID]     DSi ConsoleID
  --encrypt                     Encrypt file
  --3ds                         Using 3DS ConsoleID
#ce ---- REFERENCE ----

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Outfile=TWLIt.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=GUI wrapper for WinterMute's fork of TWLTool.
#AutoIt3Wrapper_Res_Description=TWLIt
#AutoIt3Wrapper_Res_Fileversion=2
#AutoIt3Wrapper_Res_LegalCopyright=JoshuaDoes © 2017
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <FileConstants.au3>
#include <GUIEdit.au3>
#include <GUITab.au3>
#include "assets\libs\BorderLessWinUDF.au3"

AutoItSetOption("GUIOnEventMode", 1) ;Events are better than GUI message loops

DirCreate(@ScriptDir & "\assets")
DirCreate(@ScriptDir & "\assets\icons")
DirCreate(@ScriptDir & "\assets\utils")
FileInstall(".\assets\icons\Close.ico", @ScriptDir & "\assets\icons\Close.ico")
FileInstall(".\assets\utils\TWLTool.exe", @ScriptDir & "\assets\utils\TWLTool.exe")

Global Const $Program_Title = "TWLIt" ;Program title
Global Const $Program_Build = 2 ;Program build number

Global $iMainPID = 0 ;Current process ID
Global $sRegistryLocation = "HKEY_CURRENT_USER\Software\JoshuaDoes\TWLIt" ;Registry location for saving values

$GUI_Main = GUICreate($Program_Title & " - Build " & $Program_Build, 800, 600, ((@DesktopWidth / 2) - 400), ((@DesktopHeight / 2) - 300), BitOR($WS_POPUP, $WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
_GUI_EnableDragAndResize($GUI_Main, 800, 600, 800, 600, False)
GUISetBkColor(0x1C1C1C, $GUI_Main)
$GUI_Title = GUICtrlCreateLabel($Program_Title & " - Build " & $Program_Build, 3, 3, 778, 16, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetResizing($GUI_Title, $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetFont($GUI_Title, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Title, 0x1C1C1C)
GUICtrlSetColor($GUI_Title, 0xFAFAFA)
$GUI_Close = GUICtrlCreateIcon(@ScriptDir & "\assets\icons\Close.ico", -1, 782, 2, 16, 16)
GUICtrlSetResizing($GUI_Close, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetOnEvent($GUI_Close, "Close")

$GUI_Navigation = GUICtrlCreateTab(3, 19, 794, 378)
GUICtrlSetResizing($GUI_Navigation, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Navigation, 9, 0, 0, "Segoe UI")
_GUICtrlTab_SetBkColor($GUI_Main, $GUI_Navigation, 0x1C1C1C)

$GUI_Navigation_NANDCrypt = GUICtrlCreateTabItem("NAND Crypt")
GUICtrlSetResizing($GUI_Navigation_NANDCrypt, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_NANDCrypt_eMMCID_Label = GUICtrlCreateLabel("eMMC ID:", 6, 50, 786, 15)
GUICtrlSetResizing($GUI_NANDCrypt_eMMCID_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_eMMCID_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_eMMCID_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_eMMCID_Label, 0xFAFAFA)
$GUI_NANDCrypt_eMMCID_Input = GUICtrlCreateInput("", 6, 65, 786, 20)
GUICtrlSetResizing($GUI_NANDCrypt_eMMCID_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_eMMCID_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_eMMCID_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_eMMCID_Input, 0xFAFAFA)
$GUI_NANDCrypt_DSiConsoleID_Label = GUICtrlCreateLabel("DSi Console ID:", 6, 90, 786, 15)
GUICtrlSetResizing($GUI_NANDCrypt_DSiConsoleID_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_DSiConsoleID_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_DSiConsoleID_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_DSiConsoleID_Label, 0xFAFAFA)
$GUI_NANDCrypt_DSiConsoleID_Input = GUICtrlCreateInput("", 6, 105, 786, 20)
GUICtrlSetResizing($GUI_NANDCrypt_DSiConsoleID_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_DSiConsoleID_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_DSiConsoleID_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_DSiConsoleID_Input, 0xFAFAFA)
$GUI_NANDCrypt_InputImage_Label = GUICtrlCreateLabel("Input Image:", 6, 130, 786, 15)
GUICtrlSetResizing($GUI_NANDCrypt_InputImage_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_InputImage_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_InputImage_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_InputImage_Label, 0xFAFAFA)
$GUI_NANDCrypt_InputImage_Input = GUICtrlCreateInput("", 6, 145, 734, 20)
GUICtrlSetResizing($GUI_NANDCrypt_InputImage_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_InputImage_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_InputImage_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_InputImage_Input, 0xFAFAFA)
$GUI_NANDCrypt_InputImage_Button = GUICtrlCreateButton("Browse", 740, 145, 52, 20)
GUICtrlSetResizing($GUI_NANDCrypt_InputImage_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_InputImage_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_InputImage_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_InputImage_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_NANDCrypt_InputImage_Button, "TWL_NANDCrypt_SetFileInputImage")
$GUI_NANDCrypt_OutputImage_Label = GUICtrlCreateLabel("Output Image:", 6, 170, 786, 15)
GUICtrlSetResizing($GUI_NANDCrypt_OutputImage_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputImage_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputImage_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputImage_Label, 0xFAFAFA)
$GUI_NANDCrypt_OutputImage_Input = GUICtrlCreateInput("", 6, 185, 734, 20)
GUICtrlSetResizing($GUI_NANDCrypt_OutputImage_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputImage_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputImage_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputImage_Input, 0xFAFAFA)
$GUI_NANDCrypt_OutputImage_Button = GUICtrlCreateButton("Browse", 740, 185, 52, 20)
GUICtrlSetResizing($GUI_NANDCrypt_OutputImage_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputImage_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputImage_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputImage_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_NANDCrypt_OutputImage_Button, "TWL_NANDCrypt_SetFileOutputImage")
$GUI_NANDCrypt_Is3DS_Label = GUICtrlCreateLabel("3DS:", 6, 210, 24, 15)
GUICtrlSetResizing($GUI_NANDCrypt_Is3DS_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_Is3DS_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_Is3DS_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_Is3DS_Label, 0xFAFAFA)
$GUI_NANDCrypt_Is3DS_Checkbox = GUICtrlCreateCheckbox("", 32, 210, 15, 15)
GUICtrlSetResizing($GUI_NANDCrypt_Is3DS_Checkbox, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_NANDCrypt_Bruteforce3DS_Label = GUICtrlCreateLabel("Bruteforce 3DS:", 30, 230, 85, 15)
GUICtrlSetResizing($GUI_NANDCrypt_Bruteforce3DS_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_Bruteforce3DS_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_Bruteforce3DS_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_Bruteforce3DS_Label, 0xFAFAFA)
$GUI_NANDCrypt_Bruteforce3DS_Checkbox = GUICtrlCreateCheckbox("", 113, 230, 15, 15)
GUICtrlSetResizing($GUI_NANDCrypt_Bruteforce3DS_Checkbox, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_NANDCrypt_IsNew3DS_Label = GUICtrlCreateLabel("New 3DS:", 30, 250, 85, 15)
GUICtrlSetResizing($GUI_NANDCrypt_IsNew3DS_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_IsNew3DS_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_IsNew3DS_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_IsNew3DS_Label, 0xFAFAFA)
$GUI_NANDCrypt_IsNew3DS_Checkbox = GUICtrlCreateCheckbox("", 113, 250, 15, 15)
GUICtrlSetResizing($GUI_NANDCrypt_IsNew3DS_Checkbox, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_NANDCrypt_OutputCID_Label = GUICtrlCreateLabel("Output CID:", 30, 270, 762, 15)
GUICtrlSetResizing($GUI_NANDCrypt_OutputCID_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputCID_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputCID_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputCID_Label, 0xFAFAFA)
$GUI_NANDCrypt_OutputCID_Input = GUICtrlCreateInput("", 30, 285, 710, 20)
GUICtrlSetResizing($GUI_NANDCrypt_OutputCID_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputCID_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputCID_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputCID_Input, 0xFAFAFA)
$GUI_NANDCrypt_OutputCID_Button = GUICtrlCreateButton("Browse", 740, 285, 52, 20)
GUICtrlSetResizing($GUI_NANDCrypt_OutputCID_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_OutputCID_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_OutputCID_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_OutputCID_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_NANDCrypt_OutputCID_Button, "TWL_NANDCrypt_SetFileOutputCID")
$GUI_NANDCrypt_Execute_Button = GUICtrlCreateButton("Execute", 744, 374, 49, 20)
GUICtrlSetResizing($GUI_NANDCrypt_Execute_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_Execute_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_Execute_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_Execute_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_NANDCrypt_Execute_Button, "TWL_NANDCrypt_Execute")
$GUI_NANDCrypt_ClearConsole_Button = GUICtrlCreateButton("Clear Console", 660, 374, 84, 20)
GUICtrlSetResizing($GUI_NANDCrypt_ClearConsole_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_NANDCrypt_ClearConsole_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_NANDCrypt_ClearConsole_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_NANDCrypt_ClearConsole_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_NANDCrypt_ClearConsole_Button, "Clear")
GUICtrlCreateTabItem("")

$GUI_Navigation_ModCrypt = GUICtrlCreateTabItem("Mod Crypt")
$GUI_ModCrypt_InputSRL_Label = GUICtrlCreateLabel("Input SRL:", 6, 50, 786, 15)
GUICtrlSetResizing($GUI_ModCrypt_InputSRL_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_InputSRL_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_InputSRL_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_InputSRL_Label, 0xFAFAFA)
$GUI_ModCrypt_InputSRL_Input = GUICtrlCreateInput("", 6, 65, 734, 20)
GUICtrlSetResizing($GUI_ModCrypt_InputSRL_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_InputSRL_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_InputSRL_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_InputSRL_Input, 0xFAFAFA)
$GUI_ModCrypt_InputSRL_Button = GUICtrlCreateButton("Browse", 740, 65, 52, 20)
GUICtrlSetResizing($GUI_ModCrypt_InputSRL_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_InputSRL_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_InputSRL_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_InputSRL_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_ModCrypt_InputSRL_Button, "TWL_ModCrypt_SetFileInputSRL")
$GUI_ModCrypt_OutputSRL_Label = GUICtrlCreateLabel("Output SRL:", 6, 90, 786, 15)
GUICtrlSetResizing($GUI_ModCrypt_OutputSRL_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_OutputSRL_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_OutputSRL_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_OutputSRL_Label, 0xFAFAFA)
$GUI_ModCrypt_OutputSRL_Input = GUICtrlCreateInput("", 6, 105, 734, 20)
GUICtrlSetResizing($GUI_ModCrypt_OutputSRL_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_OutputSRL_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_OutputSRL_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_OutputSRL_Input, 0xFAFAFA)
$GUI_ModCrypt_OutputSRL_Button = GUICtrlCreateButton("Browse", 740, 105, 52, 20)
GUICtrlSetResizing($GUI_ModCrypt_OutputSRL_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_OutputSRL_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_OutputSRL_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_OutputSRL_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_ModCrypt_OutputSRL_Button, "TWL_ModCrypt_SetFileOutputSRL")
$GUI_ModCrypt_Execute_Button = GUICtrlCreateButton("Execute", 744, 374, 49, 20)
GUICtrlSetResizing($GUI_ModCrypt_Execute_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_Execute_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_Execute_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_Execute_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_ModCrypt_Execute_Button, "TWL_ModCrypt_Execute")
$GUI_ModCrypt_ClearConsole_Button = GUICtrlCreateButton("Clear Console", 660, 374, 84, 20)
GUICtrlSetResizing($GUI_ModCrypt_ClearConsole_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_ModCrypt_ClearConsole_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_ModCrypt_ClearConsole_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_ModCrypt_ClearConsole_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_ModCrypt_ClearConsole_Button, "Clear")
GUICtrlCreateTabItem("")

$GUI_Navigation_Boot2 = GUICtrlCreateTabItem("Boot2")
$GUI_Boot2_InputImage_Label = GUICtrlCreateLabel("Input Image:", 6, 50, 786, 15)
GUICtrlSetResizing($GUI_Boot2_InputImage_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_InputImage_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_InputImage_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_InputImage_Label, 0xFAFAFA)
$GUI_Boot2_InputImage_Input = GUICtrlCreateInput("", 6, 65, 734, 20)
GUICtrlSetResizing($GUI_Boot2_InputImage_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_InputImage_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_InputImage_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_InputImage_Input, 0xFAFAFA)
$GUI_Boot2_InputImage_Button = GUICtrlCreateButton("Browse", 740, 65, 52, 20)
GUICtrlSetResizing($GUI_Boot2_InputImage_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_InputImage_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_InputImage_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_InputImage_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_Boot2_InputImage_Button, "TWL_Boot2_SetFileInputImage")
$GUI_Boot2_Debug_Label = GUICtrlCreateLabel("Debug:", 6, 90, 37, 15)
GUICtrlSetResizing($GUI_Boot2_Debug_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_Debug_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_Debug_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_Debug_Label, 0xFAFAFA)
$GUI_Boot2_Debug_Checkbox = GUICtrlCreateCheckbox("", 47, 90, 15, 15)
GUICtrlSetResizing($GUI_Boot2_Debug_Checkbox, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_Boot2_Execute_Button = GUICtrlCreateButton("Execute", 744, 374, 49, 20)
GUICtrlSetResizing($GUI_Boot2_Execute_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_Execute_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_Execute_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_Execute_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_Boot2_Execute_Button, "TWL_Boot2_Execute")
$GUI_Boot2_ClearConsole_Button = GUICtrlCreateButton("Clear Console", 660, 374, 84, 20)
GUICtrlSetResizing($GUI_Boot2_ClearConsole_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Boot2_ClearConsole_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Boot2_ClearConsole_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_Boot2_ClearConsole_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_Boot2_ClearConsole_Button, "Clear")
GUICtrlCreateTabItem("")

$GUI_Navigation_SysCrypt = GUICtrlCreateTabItem("SysCrypt")
$GUI_SysCrypt_DSiConsoleID_Label = GUICtrlCreateLabel("DSi Console ID:", 6, 50, 786, 15)
GUICtrlSetResizing($GUI_SysCrypt_DSiConsoleID_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_DSiConsoleID_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_DSiConsoleID_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_DSiConsoleID_Label, 0xFAFAFA)
$GUI_SysCrypt_DSiConsoleID_Input = GUICtrlCreateInput("", 6, 65, 786, 20)
GUICtrlSetResizing($GUI_SysCrypt_DSiConsoleID_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_DSiConsoleID_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_DSiConsoleID_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_DSiConsoleID_Input, 0xFAFAFA)
$GUI_SysCrypt_InputSRL_Label = GUICtrlCreateLabel("Input SRL:", 6, 90, 786, 15)
GUICtrlSetResizing($GUI_SysCrypt_InputSRL_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_InputSRL_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_InputSRL_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_InputSRL_Label, 0xFAFAFA)
$GUI_SysCrypt_InputSRL_Input = GUICtrlCreateInput("", 6, 105, 734, 20)
GUICtrlSetResizing($GUI_SysCrypt_InputSRL_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_InputSRL_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_InputSRL_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_InputSRL_Input, 0xFAFAFA)
$GUI_SysCrypt_InputSRL_Button = GUICtrlCreateButton("Browse", 740, 105, 52, 20)
GUICtrlSetResizing($GUI_SysCrypt_InputSRL_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_InputSRL_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_InputSRL_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_InputSRL_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_SysCrypt_InputSRL_Button, "TWL_SysCrypt_SetFileInputSRL")
$GUI_SysCrypt_OutputSRL_Label = GUICtrlCreateLabel("Output SRL:", 6, 130, 786, 15)
GUICtrlSetResizing($GUI_SysCrypt_OutputSRL_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_OutputSRL_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_OutputSRL_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_OutputSRL_Label, 0xFAFAFA)
$GUI_SysCrypt_OutputSRL_Input = GUICtrlCreateInput("", 6, 145, 734, 20)
GUICtrlSetResizing($GUI_SysCrypt_OutputSRL_Input, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_OutputSRL_Input, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_OutputSRL_Input, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_OutputSRL_Input, 0xFAFAFA)
$GUI_SysCrypt_OutputSRL_Button = GUICtrlCreateButton("Browse", 740, 145, 52, 20)
GUICtrlSetResizing($GUI_SysCrypt_OutputSRL_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_OutputSRL_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_OutputSRL_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_OutputSRL_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_SysCrypt_OutputSRL_Button, "TWL_SysCrypt_SetFileOutputSRL")
$GUI_SysCrypt_Is3DS_Label = GUICtrlCreateLabel("3DS:", 6, 170, 24, 15)
GUICtrlSetResizing($GUI_SysCrypt_Is3DS_Label, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_Is3DS_Label, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_Is3DS_Label, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_Is3DS_Label, 0xFAFAFA)
$GUI_SysCrypt_Is3DS_Checkbox = GUICtrlCreateCheckbox("", 32, 170, 15, 15)
GUICtrlSetResizing($GUI_SysCrypt_Is3DS_Checkbox, $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$GUI_SysCrypt_Execute_Button = GUICtrlCreateButton("Execute", 744, 374, 49, 20)
GUICtrlSetResizing($GUI_SysCrypt_Execute_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_Execute_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_Execute_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_Execute_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_SysCrypt_Execute_Button, "TWL_SysCrypt_Execute")
$GUI_SysCrypt_ClearConsole_Button = GUICtrlCreateButton("Clear Console", 660, 374, 84, 20)
GUICtrlSetResizing($GUI_SysCrypt_ClearConsole_Button, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_SysCrypt_ClearConsole_Button, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_SysCrypt_ClearConsole_Button, 0x1C1C1C)
GUICtrlSetColor($GUI_SysCrypt_ClearConsole_Button, 0xFAFAFA)
GUICtrlSetOnEvent($GUI_SysCrypt_ClearConsole_Button, "Clear")
GUICtrlCreateTabItem("")

;$GUI_Navigation_Settings = GUICtrlCreateTabItem("Settings")
;GUICtrlCreateTabItem("")

$GUI_Console = GUICtrlCreateEdit("", 3, 400, 794, 197, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_MULTILINE, $ES_WANTRETURN, $ES_READONLY))
GUICtrlSetResizing($GUI_Console, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
GUICtrlSetFont($GUI_Console, 9, 0, 0, "Segoe UI")
GUICtrlSetBkColor($GUI_Console, 0x1C1C1C)
GUICtrlSetColor($GUI_Console, 0xFAFAFA)

LoadOption($sRegistryLocation, "NANDCrypt_Bruteforce3DS", $GUI_NANDCrypt_Bruteforce3DS_Checkbox)
LoadOption($sRegistryLocation, "NANDCrypt_DSiConsoleID", $GUI_NANDCrypt_DSiConsoleID_Input)
LoadOption($sRegistryLocation, "NANDCrypt_eMMCID", $GUI_NANDCrypt_eMMCID_Input)
LoadOption($sRegistryLocation, "NANDCrypt_InputImage", $GUI_NANDCrypt_InputImage_Input)
LoadOption($sRegistryLocation, "NANDCrypt_Is3DS", $GUI_NANDCrypt_Is3DS_Checkbox)
LoadOption($sRegistryLocation, "NANDCrypt_IsNew3DS", $GUI_NANDCrypt_IsNew3DS_Checkbox)
LoadOption($sRegistryLocation, "NANDCrypt_OutputImage", $GUI_NANDCrypt_OutputImage_Input)
LoadOption($sRegistryLocation, "ModCrypt_InputSRL", $GUI_ModCrypt_InputSRL_Input)
LoadOption($sRegistryLocation, "ModCrypt_OutputSRL", $GUI_ModCrypt_OutputSRL_Input)
LoadOption($sRegistryLocation, "Boot2_Debug", $GUI_Boot2_Debug_Checkbox)
LoadOption($sRegistryLocation, "Boot2_InputImage", $GUI_Boot2_InputImage_Input)
LoadOption($sRegistryLocation, "SysCrypt_DSiConsoleID", $GUI_SysCrypt_DSiConsoleID_Input)
LoadOption($sRegistryLocation, "SysCrypt_InputSRL", $GUI_SysCrypt_InputSRL_Input)
LoadOption($sRegistryLocation, "SysCrypt_Is3DS", $GUI_SysCrypt_Is3DS_Checkbox)
LoadOption($sRegistryLocation, "SysCrypt_OutputSRL", $GUI_SysCrypt_OutputSRL_Input)

GUISetState(@SW_SHOW)

While 1
	If $iMainPID Then
		Do
			$STDOUT = StdoutRead($iMainPID)
			$STDERR = StderrRead($iMainPID)
			$STDMSG = $STDOUT & $STDERR
			Write($STDMSG)
		Until Not ProcessExists($iMainPID)
		$iMainPID = 0
	EndIf
WEnd

Func TWL_Execute($sParameters)
	If Not FileExists(@ScriptDir & "\assets\utils\TWLTool.exe") Then Return False ;TWLTool was not found
	If $iMainPID Then
		Write("!!! A PROCESS IS ALREADY RUNNING !!!")
		Return False
	EndIf

	Write(">TWLTool """ & $sParameters & """")

	$iMainPID = Run(@ScriptDir & "\assets\utils\TWLTool.exe " & $sParameters, @ScriptDir, @SW_HIDE, 0x8) ;Run TWLTool with the parameters specified and access to the STDOUT and STDERR pipelines, hiding the console window
EndFunc
Func TWL_NANDCrypt($eMMCCID, $DSiConsoleID, $sFileInput_Image, $sFileOutput_Image = "", $b3DS = False, $bBruteforce3DS = False, $sFileOutput_CIDName = "", $bNew3DS = False)
	If Not FileExists($sFileInput_Image) Then Return False

	$sParameters = "nandcrypt --cid " & $eMMCCID & " --consoleid " & $DSiConsoleID & " --in """ & $sFileInput_Image & """"
	If $sFileOutput_Image Then $sParameters &= " --out """ & $sFileOutput_Image & """"
	If $b3DS Then
		$sParameters &= " --3ds"
		If $bBruteforce3DS Then $sParameters &= " --3dsbrute"
		If $sFileOutput_CIDName Then $sParameters &= " --cidfile """ & $sFileOutput_CIDName & """"
		If $bNew3DS Then
			$sParameters &= " --n3ds"
		EndIf
	EndIf

	TWL_Execute($sParameters)
EndFunc
Func TWL_NANDCrypt_SetFileInputImage()
	Local $hFile = FileOpenDialog("Select an input image...", @ScriptDir, "All files (*.*)")
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_NANDCrypt_InputImage_Input, $hFile)
	If Not GUICtrlRead($GUI_NANDCrypt_OutputImage_Input) Then GUICtrlSetData($GUI_NANDCrypt_OutputImage_Input, $hFile)
EndFunc
Func TWL_NANDCrypt_SetFileOutputImage()
	Local $hFile = FileSaveDialog("Choose a save location for the output image...", @ScriptDir, "All files (*.*)", 0, GUICtrlRead($GUI_NANDCrypt_OutputImage_Input))
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_NANDCrypt_OutputImage_Input, $hFile)
EndFunc
Func TWL_NANDCrypt_SetFileOutputCID()
	Local $hFile = FileSaveDialog("Choose a save location for the CID...", @ScriptDir, "All files (*.*)", 0, GUICtrlRead($GUI_NANDCrypt_OutputCID_Input))
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_NANDCrypt_OutputCID_Input, $hFile)
EndFunc
Func TWL_NANDCrypt_Execute()
	Local $eMMCCID = GUICtrlRead($GUI_NANDCrypt_eMMCID_Input)
	Local $DSiConsoleID = GUICtrlRead($GUI_NANDCrypt_DSiConsoleID_Input)
	Local $sFileInput_Image = GUICtrlRead($GUI_NANDCrypt_InputImage_Input)
	Local $sFileOutput_Image = GUICtrlRead($GUI_NANDCrypt_OutputImage_Input)
	Local $b3DS = GUICtrlRead($GUI_NANDCrypt_Is3DS_Checkbox)
	If $b3DS = $GUI_CHECKED Then
		$b3DS = True
	Else
		$b3DS = False
	EndIf
	Local $bBruteforce3DS = GUICtrlRead($GUI_NANDCrypt_Bruteforce3DS_Checkbox)
	If $bBruteforce3DS = $GUI_CHECKED Then
		$bBruteforce3DS = True
	Else
		$bBruteforce3DS = False
	EndIf
	Local $sFileOutput_CIDName = GUICtrlRead($GUI_NANDCrypt_OutputCID_Input)
	Local $bNew3DS = GUICtrlRead($GUI_NANDCrypt_IsNew3DS_Checkbox)
	If $bNew3DS = $GUI_CHECKED Then
		$bNew3DS = True
	Else
		$bNew3DS = False
	EndIf
	TWL_NANDCrypt($eMMCCID, $DSiConsoleID, $sFileInput_Image, $sFileOutput_Image, $b3DS, $bBruteforce3DS, $sFileOutput_CIDName, $bNew3DS)
EndFunc
Func TWL_ModCrypt($sFileInput_SRL, $sFileOutput_SRL = "")
	If Not FileExists($sFileInput_SRL) Then Return False

	$sParameters = "modcrypt --in """ & $sFileInput_SRL & """"
	If $sFileOutput_SRL Then $sParameters &= " --out """ & $sFileOutput_SRL & """"

	TWL_Execute($sParameters)
EndFunc
Func TWL_ModCrypt_SetFileInputSRL()
	Local $hFile = FileOpenDialog("Select an input SRL...", @ScriptDir, "All files (*.*)")
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_ModCrypt_InputSRL_Input, $hFile)
	If Not GUICtrlRead($GUI_ModCrypt_OutputSRL_Input) Then GUICtrlSetData($GUI_ModCrypt_OutputSRL_Input, $hFile)
EndFunc
Func TWL_ModCrypt_SetFileOutputSRL()
	Local $hFile = FileSaveDialog("Choose a save location for the output SRL...", @ScriptDir, "All files (*.*)", 0, GUICtrlRead($GUI_ModCrypt_OutputSRL_Input))
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_ModCrypt_OutputSRL_Input, $hFile)
EndFunc
Func TWL_ModCrypt_Execute()
	Local $sFileInput_SRL = GUICtrlRead($GUI_ModCrypt_InputSRL_Input)
	Local $sFileOutput_SRL = GUICtrlRead($GUI_ModCrypt_OutputSRL_Input)

	TWL_ModCrypt($sFileInput_SRL, $sFileOutput_SRL)
EndFunc
Func TWL_Boot2($sFileInput_Image, $bDebug = False)
	If Not FileExists($sFileInput_Image) Then Return False

	$sParameters = "boot2 --in """ & $sFileInput_Image & """"
	If $bDebug Then $sParameters &= " --debug"

	TWL_Execute($sParameters)
EndFunc
Func TWL_Boot2_SetFileInputImage()
	Local $hFile = FileOpenDialog("Select an input image...", @ScriptDir, "All files (*.*)")
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_Boot2_InputImage_Input, $hFile)
EndFunc
Func TWL_Boot2_Execute()
	Local $sFileInput_Image = GUICtrlRead($GUI_Boot2_InputImage_Input)
	Local $bDebug = GUICtrlRead($GUI_Boot2_Debug_Checkbox)
	If $bDebug = $GUI_CHECKED Then
		$bDebug = True
	Else
		$bDebug = False
	EndIf

	TWL_Boot2($sFileInput_Image, $bDebug)
EndFunc
Func TWL_SysCrypt($sFileInput_SRL, $DSiConsoleID, $sFileOutput_SRL = "", $b3DS = False)
	If Not FileExists($sFileInput_SRL) Then Return False

	$sParameters = "syscrypt --in """ & $sFileInput_SRL & """ --consoleid " & $DSiConsoleID & " --encrypt"
	If $sFileOutput_SRL Then $sParameters &= " --out """ & $sFileOutput_SRL & """"
	If $b3DS Then $sParameters &= " --3ds"

	TWL_Execute($sParameters)
EndFunc
Func TWL_SysCrypt_SetFileInputSRL()
	Local $hFile = FileOpenDialog("Select an input SRL...", @ScriptDir, "All files (*.*)")
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_SysCrypt_InputSRL_Input, $hFile)
	If Not GUICtrlRead($GUI_SysCrypt_OutputSRL_Input) Then GUICtrlSetData($GUI_SysCrypt_OutputSRL_Input, $hFile)
EndFunc
Func TWL_SysCrypt_SetFileOutputSRL()
	Local $hFile = FileSaveDialog("Choose a save location for the output SRL...", @ScriptDir, "All files (*.*)", 0, GUICtrlRead($GUI_SysCrypt_OutputSRL_Input))
	If Not $hFile Then Return False
	GUICtrlSetData($GUI_SysCrypt_OutputSRL_Input, $hFile)
EndFunc
Func TWL_SysCrypt_Execute()
	Local $DSiConsoleID = GUICtrlRead($GUI_SysCrypt_DSiConsoleID_Input)
	Local $sFileInput_SRL = GUICtrlRead($GUI_SysCrypt_InputSRL_Input)
	Local $sFileOutput_SRL = GUICtrlRead($GUI_SysCrypt_OutputSRL_Input)
	Local $b3DS = GUICtrlRead($GUI_SysCrypt_Is3DS_Checkbox)
	If $b3DS = $GUI_CHECKED Then
		$b3DS = True
	Else
		$b3DS = False
	EndIf

	TWL_SysCrypt($DSiConsoleID, $sFileInput_SRL, $sFileOutput_SRL, $b3DS)
EndFunc

Func Write($sMsg)
	If Not $sMsg Then Return False
	_GUICtrlEdit_AppendText($GUI_Console, $sMsg & @CRLF)
EndFunc
Func Clear()
	GUICtrlSetData($GUI_Console, "")
EndFunc
Func Close()
	If $iMainPID Then
		Write("Killing TWLTool... (PID: " & $iMainPID & ")")
		ProcessWaitClose($iMainPID)
	EndIf
	SaveOption($sRegistryLocation, "NANDCrypt_Bruteforce3DS", GUICtrlRead($GUI_NANDCrypt_Bruteforce3DS_Checkbox))
	SaveOption($sRegistryLocation, "NANDCrypt_DSiConsoleID", GUICtrlRead($GUI_NANDCrypt_DSiConsoleID_Input))
	SaveOption($sRegistryLocation, "NANDCrypt_eMMCID", GUICtrlRead($GUI_NANDCrypt_eMMCID_Input))
	SaveOption($sRegistryLocation, "NANDCrypt_InputImage", GUICtrlRead($GUI_NANDCrypt_InputImage_Input))
	SaveOption($sRegistryLocation, "NANDCrypt_Is3DS", GUICtrlRead($GUI_NANDCrypt_Is3DS_Checkbox))
	SaveOption($sRegistryLocation, "NANDCrypt_IsNew3DS", GUICtrlRead($GUI_NANDCrypt_IsNew3DS_Checkbox))
	SaveOption($sRegistryLocation, "NANDCrypt_OutputImage", GUICtrlRead($GUI_NANDCrypt_OutputImage_Input))
	SaveOption($sRegistryLocation, "ModCrypt_InputSRL", GUICtrlRead($GUI_ModCrypt_InputSRL_Input))
	SaveOption($sRegistryLocation, "ModCrypt_OutputSRL", GUICtrlRead($GUI_ModCrypt_OutputSRL_Input))
	SaveOption($sRegistryLocation, "Boot2_Debug", GUICtrlRead($GUI_Boot2_Debug_Checkbox))
	SaveOption($sRegistryLocation, "Boot2_InputImage", GUICtrlRead($GUI_Boot2_InputImage_Input))
	SaveOption($sRegistryLocation, "SysCrypt_DSiConsoleID", GUICtrlRead($GUI_SysCrypt_DSiConsoleID_Input))
	SaveOption($sRegistryLocation, "SysCrypt_InputSRL", GUICtrlRead($GUI_SysCrypt_InputSRL_Input))
	SaveOption($sRegistryLocation, "SysCrypt_Is3DS", GUICtrlRead($GUI_SysCrypt_Is3DS_Checkbox))
	SaveOption($sRegistryLocation, "SysCrypt_OutputSRL", GUICtrlRead($GUI_SysCrypt_OutputSRL_Input))
	Exit
EndFunc
Func LoadOption($sRegistryLocation, $sOption, $hWnd)
	Local $sValue = RegRead($sRegistryLocation, $sOption)
	If IsNumber($sValue) Then
		GUICtrlSetState($hWnd, $sValue)
	Else
		GUICtrlSetData($hWnd, $sValue)
	EndIf
EndFunc
Func SaveOption($sRegistryLocation, $sOption, $sValue)
	If IsNumber($sValue) Then
		RegWrite($sRegistryLocation, $sOption, "REG_DWORD", $sValue)
	ElseIf IsString($sValue) Then
		RegWrite($sRegistryLocation, $sOption, "REG_SZ", $sValue)
	ElseIf IsBinary($sValue) Then
		RegWrite($sRegistryLocation, $sOption, "REG_BINARY", $sValue)
	Else
		Write("Unknown data type, unable to save value for """ & $sOption & """ to the registry.")
	EndIf
EndFunc

Func _GUICtrlTab_SetBkColor($hWnd, $hSysTab32, $sBkColor) ;Credit to M23, https://www.autoitscript.com/forum/topic/107527-tab-background-color/
    Local $aTabPos = ControlGetPos($hWnd, "", $hSysTab32)
    Local $aTab_Rect = _GUICtrlTab_GetItemRect($hSysTab32, -1)

    GUICtrlCreateLabel("", $aTabPos[0] + 2, $aTabPos[1] + $aTab_Rect[3] + 4, $aTabPos[2] - 6, $aTabPos[3] - $aTab_Rect[3] - 7)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP )
    GUICtrlSetBkColor(-1, $sBkColor)
    GUICtrlSetState(-1, $GUI_DISABLE)
EndFunc