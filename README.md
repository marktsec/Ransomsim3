# Ransomware Simulator - RANSOMSIM3
## +-+-+-+-+-+-+-+-+-+ |R|A|N|S|O|M|S|I|M| +-+-+-+-+-+-+-+-+-+
### THE BEST RANSOMWARE SIMULATION FOR ENTERPRISE SECURITY TESTING

[MT|marktsec]
[![Twitter Badge](https://img.shields.io/badge/Twitter-Profile-informational?style=flat&logo=twitter&logoColor=white&color=1CA2F1)](https://twitter.com/marktsec46065)


In order to improve their security posture, many organizations want to test their security products and validate if they can prevent never before-seen ransomware without resorting to running malware. Built to assist Red/Blue teams test their defenses.

## Features
- Encrypting documents
- Deleting Volume Shadow Copies
- Kill processes (in this version notepad.exe only)
- Dropping a ransomware note to the chosen folder
- File hash change in one click
- and more

## Usage

It's recommended to install AutoIt for the file hash change in click (compile) option
[AutoIt](https://www.autoitscript.com/site/) 

```sh
ransomsim3.exe [help] [mode] [path] [shadow copy] [password]
```

# Quick Start
Encrypt files in C:\test directory
```sh
ransomsim3.exe encrypt C:\test
```
#### SEE ATTACHED DOCUMENTATION FILE FOR ADVANCED USAGE AND EXAMPLES

```diff
-  WARNING: If the shadow copy delete option is selected, all shadow copies will be deleted.
-  WARNING: All files in the folder selected for the encryption will be encrypted.
```
> WARNING: If the shadow copy delete option is selected, all shadow copies will be deleted.
> WARNING: All files in the folder selected for the encryption will be encrypted.

> Note: NOTES FOR RED TEAMERS: USE IMPACKET SMBEXEC AND LOLBINS TO RUN THIS SIMULATION.

Verify the deployment by navigating to your server address in
your preferred browser.

```diff
-  WARNING: This software does not offer any kind of guarantee. Its use is exclusive for educational environments and / or security audits with the corresponding consent of the client. I am not responsible for its misuse or for any possible damage caused by it.
```

## License

MIT


