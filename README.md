# (ƒ STARTX EMACS) => \*STARTX-BUFFER\*
![foto](media/startx-buffer.png)
<!-- ![foto](media/mit-kamera.png) -->

## STARTX IS A MACHINE,
* SPLIT-FLAP DISPLAY MODUL x 16
* RASPBERRY PI, CHIPKIT, IP CAMERA
* PUREDATA, VIA OSC

## STARTX-BUFFER IS A EMACS MINOR MODE,
* A EXPERIMENTAL PHYSIKAL REMOTE BUFFER
* REAL TIME KEYINPUT HIJACKER FROM EMACS TO THE STARTX

### DEPENDANCY
* SLIME <https://github.com/slime/slime>
* mpv <https://mpv.io> (or VLC <https://www.videolan.org>)

### INSTALLATION
```
(add-to-list 'load-path "path/to/startx-buffer/")
(require 'startx-buffer-mode)
```

## CONNECT TO STARTX-BUFFER
### SSH TUNNELING
* FOR THE FIRST TIME, FROM SHELL (REGISTERING THE SERVER FINGERPRINT)
``` bash
$ ssh -fNL 4004:localhost:4004 startx@mut.dlinkddns.com
(...blah...blah...blah...)
Are you sure you want to continue connecting (yes/no)? yes
startx@mut.dlinkddns.com's password: startx
``` 

* AFTER THAT,
``` common-lisp
(defun tunnel ()
  (interactive)
  (start-process "tunnel" "tunnel-msg" 
  "sshpass" "-p" "startx" "ssh" "-fNL" "4004:localhost:4004" "startx@mut.dlinkddns.com")
  (switch-to-buffer "tunnel-msg"))
```
`M-x tunnel`
  
### IP CAMERA
* FROM SHELL
``` bash
$ vlc rtsp://mut.dlinkddns.com:554/ch0_1.h264 --no-audio
```
* OR, IN Emacs
``` common-lisp
(defun vue ()
  (interactive)
  (call-process "open"
		nil 0 nil
		"-n" "-a" "vlc" "--args"
		"rtsp://mut.dlinkddns.com:554/ch0_1.h264" "--no-audio"))
``` 
`M-x vue`

### SLIME
`M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)`
### STARTX
```
CL-USER> (startx)
->->->the maschine startx initialized, vermute ich.
NIL
CL-USER>
```
### STARTX-BUFFER

`M-x startx-buffer-mode`
* FROM NOW YOU CAN HACK THE PHYSIKAL BUFFER \*STARTX-BUFFER\*

## COMMAND
```
CL-USER> (startx)      ; start the machine startx
```
* `C-a`         ; move-beginning-of-\*startx-buffer\*
* `C-k`         ; kill-rest in \*startx-buffer\*
* `<backspace>` ; backward-delete-char in \*startx-buffer\*
* `M-x x-current-line-or-region`   ; send currnet line or region to \*startx-buffer\*

``` common-lisp
(x "foo")   ; send "foo             " to *startx-buffer*
(a "f")   ; send "ffffffffffffffff" to *startx-buffer*
(kali)      ; calibrate *startx-buffer* again 
(agur)      ; turn off the maschine
```

<!-- ## STARTX-THEATRE IS A REMOTE LIVE THEATRE ENVIRONMENT, -->
<!-- ![foto](media/startx-theatre.png) -->

<!-- * LIVE CODING INSPIRED -->
<!-- * SATELLITE REMOTE PROGRAMMING INSPIRED  -->
<!-- * "THE LIBRARY OF BABEL BY JORGE LUIS BORGES" GELESEN. -->

## DEMO

## TODO
* RES/ SPONTANEOUS SLIME-CONNECT ERFOLGREICH, PERO MAS CHECKEN
* HIDDEN COMMAND ZU DOCUMENTATION
* IN LISP KONTROLL DIE SATZ, DIE MEHR ALS 16 CHAR SIND.
 * ~~FAST OK, AUF-R DIE NAME DER FUNS~~
 * ~~WARTE BIS ALLE GESTOPPT?~~
  * \*STATUS\*
* (sag) ZU KORIGIEREN
* (x+ ∂) Y (x- ∂) /M LANGE VERSION
* ~~(kali 0 1) .el /M &optional~~
* (startx) IMMER WARTEN OD. ZU THREAD
* UNICODE EXCEPTION
** ASCIIFY?
 * (kali) WARTE LOCK ; (kali-warte) 
* STALL RESET λ
* ~~THREAD IN EMACS WIE?~~
* ~~(IN-PACKAGE #:CL-USER)~~
* ~~ELISP HOTKEY /M DOUBLE QUOTE EXCEPTION~~
* ~~not DOWNCASED-STR ALS arg~~
* ~~(agur) AUCH THREAD? => NO~~
* ~~(startx) AUCH THREAD? => NO~~
* FEEDBACK y (mach-socket) DEBUG, CCL VS VNC 
* ~~VLC y MPV : WHICH IST BETTER?~~
* ESCAPE \ KORIGIEREN
* ~~(call-process-shell-command) DISCOURAGED?~~
* (kali) (startx) SOLCHE INTERACTIVE VERSION FUNCTION ALS THREAD OD. N?
* ~~F3 KEYMAP M/ X-CURRENT-LINE-OR-REGION~~
* (TOGGLE-CASE)ooj DEBUG
* ALLE BEENDET-P
* SHORT-STORY

<!-- dvnmk@dvnmk-mb:~ » ssh startx@startx.local -->
<!-- The authenticity of host 'startx.local (192.168.0.4)' can't be established. -->
<!-- ECDSA key fingerprint is SHA256:dTvNU8FCrMmt2pMK8frpUarqxe+0Tzm9sZJdCXocLLo. -->
<!-- Are you sure you want to continue connecting (yes/no)? yes -->
<!-- Warning: Permanently added 'startx.local,192.168.0.4' (ECDSA) to the list of known hosts. -->
<!-- startx@startx.local's password:  -->
<!-- Permission denied, please try again. -->
<!-- startx@startx.local's password:  -->
<!-- Linux startx 4.1.13-v7+ #826 SMP PREEMPT Fri Nov 13 20:19:03 GMT 2015 armv7l -->

<!-- The programs included with the Debian GNU/Linux system are free software; -->
<!-- the exact distribution terms for each program are described in the -->
<!-- individual files in /usr/share/doc/*/copyright. -->

<!-- Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent -->
<!-- permitted by applicable law. -->
<!-- Last login: Thu Dec 31 11:13:20 2015 from dvnmk-mb.local -->
<!-- startx@startx ~ $  -->
