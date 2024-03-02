Ransomware Simulator - RANSOMSIM3

 +-+-+-+-+-+-+-+-+-+
 |R|A|N|S|O|M|S|I|M|
 +-+-+-+-+-+-+-+-+-+

THE BEST SIMULATION FOR ENTERPRISE SECURITY TESTING


In order to improve their security posture, many organizations want to test their security products and validate if they can prevent never before-seen ransomware without resorting to running malware. 
Built to assist Red/Blue teams test their defenses. 
This tool simulates typical ransomware behavior, such as: 
Kill processes (in this version notepad.exe only)
 Deleting Volume Shadow Copies 
Encrypting documents
Dropping a ransomware note to the chosen folder 

USAGE:

ransomsim3.exe [help] [mode] [path] [shadow copy] [password]

SEE ATTACHED DOCUMENTATION FOR USAGE AND EXAMPLES

Quick Start: ransomsim3.exe encrypt C:\test2 

WARNING - If the shadow copy delete option is selected, all shadow copies will be deleted. 
WARNING - All files in the folder selected for the encryption will be encrypted. 

NOTES FOR RED TEAMERS:
USE IMPACKET SMBEXEC AND LOLBINS TO RUN THIS SIMULATION

RANSOMSIM executable hash change
There is an option to change the hash of the file by compiling the source using AutoIt compile right click option, or command line compile.



** Ransom note deployed to the encrypted folder. 
** Kill process option added. By default it closes the notepad.exe process if it exists. 

WARNING:
This software does not offer any kind of guarantee. Its use is exclusive for educational environments and / or security audits with the corresponding consent of the client. I am not responsible for its misuse or for any possible damage caused by it.
