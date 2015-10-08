# (+ STARTX EMACS) => STARTX-BUFFER
![foto](media/startx-buffer.png)

## STARTX IS A MACHINE,
* SPLIT DISPLAY MODUL x 16
* RASPBERRY PI, CHIPKIT, IP CAMERA
* PUREDATA
* VIA OSC

## STARTX-BUFFER IS A EMACS MINOR MODE,
* A EXPERIMENTALISCHE PHYSIKALISCHE BUFFER
* REAL TIME KEYINPUT HIJACKER FROM EMACS TO THE STARTX

```
(add-to-list 'load-path ".../startx-buffer/")
(require 'startx-buffer)
```

## DEPENDANCY
* SLIME <https://github.com/slime/slime>
* MPV <http://mpv.io>

## CONNECT TO STARTX-BUFFER
```
;;; ssh tunneling
(defun tunnel ()
  (interactive)
  (call-process-shell-command
  "ssh -fnl 4004:localhost:4004 pi@mut.dlinkddns.com &"))
```
`M-x tunnel`

```
;;; ip camera
(defun vue ()
   (interactive)
   (call-process-shell-command
   "mpv --no-audio --framedrop=vo
   rtsp://mut.dlinkddns.com:554/ch0_1.h264 &"))
```   
`M-x vue`

`M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)`
```
CL-USER> (startx)
->->->alle null kalibriet, denke ich.
NIL
CL-USER>
```
`M-x startx-buffer`

## COMMAND
```
CL-USER> (startx)      ; initialize the machine
CL-USER> (agur)        ; turn off the maschine
```
* `C-a`         ; move-beginning-of-startx
* `C-k`         ; kill-rest in startx
* `<backspace>` ; backward-delete-char in startx

<!-- ## STARTX-THEATRE IS A REMOTE LIVE THEATRE ENVIRONMENT, -->
<!-- ![foto](media/startx-theatre.png) -->

<!-- * LIVE CODING INSPIRED -->
<!-- * SATELLITE REMOTE PROGRAMMING INSPIRED  -->
<!-- * "THE LIBRARY OF BABEL BY JORGE LUIS BORGES" GELESEN. -->

## SCREENCAST
