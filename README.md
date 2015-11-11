# (+ STARTX EMACS) => \*STARTX-BUFFER\*
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
* MPV <http://mpv.io>

### INSTALLATION
```
(add-to-list 'load-path "path/to/startx-buffer/")
(require 'startx-buffer)
```

## CONNECT TO STARTX-BUFFER
``` bash
;;; ssh tunneling
$ ssh -fNL 4004:localhost:4004 startx@mut.dlinkddns.com
...password : startx
```
```
;;; ip camera
$ mpv --no-audio --framedrop=vo rtsp://mut.dlinkddns.com:554/ch0_1.h264
```   


`M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)`
```
CL-USER> (startx)
->->->alle null kalibriert, denke ich.
NIL
CL-USER>
```
`M-x startx-buffer`

## COMMAND
```
CL-USER> (startx)      ; start the machine startx
CL-USER> (agur)        ; turn off the maschine
```
* `C-a`         ; move-beginning-of-\*startx-buffer\*
* `C-k`         ; kill-rest in \*startx-buffer\*
* `<backspace>` ; backward-delete-char in \*startx-buffer\*

<!-- ## STARTX-THEATRE IS A REMOTE LIVE THEATRE ENVIRONMENT, -->
<!-- ![foto](media/startx-theatre.png) -->

<!-- * LIVE CODING INSPIRED -->
<!-- * SATELLITE REMOTE PROGRAMMING INSPIRED  -->
<!-- * "THE LIBRARY OF BABEL BY JORGE LUIS BORGES" GELESEN. -->

## SCREENCAST

## TODO
~~* HOW TO SSH W/O PASSWORD~~
~~* SSH OR SLIME GUEST MODE~~
* STARTX ACCOUNT TRANSITION
 
~~* NUMERO OCHO KORRIGIEREN DIE KONNEKTOR~~
* RES/ SPONTANEOUS SLIME-CONNECT ERFOLGREICH, PERO MAS CHECKEN
* (x ":startx:ready) ZU GLOBAL-VARI Z.B. *WILKOMMEN-MESG*
* NOT A TRAMP FILE PROBLEM ZU LOSCHEN
