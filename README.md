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
### SSH TUNNELING
``` bash
$ ssh -fNL 4004:localhost:4004 startx@mut.dlinkddns.com
...password : startx
```
### IP CAMERA
``` bash
$ mpv --no-audio --framedrop=vo rtsp://mut.dlinkddns.com:554/ch0_1.h264
``` 
### SLIME
`M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)`
### STARTX
```
CL-USER> (startx)
->->->alle null kalibriert, denke ich.
NIL
CL-USER>
```
### STARTX-BUFFER

`M-x startx-buffer`

## COMMAND
```
CL-USER> (startx)      ; start the machine startx
CL-USER> (agur)        ; turn off the maschine
```
* `(x "foo")`   ; write "foo" to \*startx-buffer\*
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
* STARTX ACCOUNT TRANSITION
* RES/ SPONTANEOUS SLIME-CONNECT ERFOLGREICH, PERO MAS CHECKEN
* (x ":startx:ready) ZU GLOBAL-VARI Z.B. *WILKOMMEN-MESG*
* NOT A TRAMP FILE PROBLEM ZU LOSCHEN
* HIDDEN COMMAND TO DOCUMENTATION
