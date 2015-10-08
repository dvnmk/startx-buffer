# (+ STARTX LISP) => STARTX-BUFFER
![foto](media/startx-buffer.png)

## STARTX IS A MACHINE,
* SPLIT DISPLAY MODUL x 16
* RASPBERRY PI, CHIPKIT, IP CAMERA
* PUREDATA
* VIA OSC

## STARTX-BUFFER IS A EMACS MINOR MODE,
* A EXPERIMENTALISCHE PHYSIKALISCHE BUFFER
* \*SCRATCH\* BUFFER IN EMACS INSPIRED.
* STARTX-BUFFER-MODE.EL ; REAL TIME KEYINPUT HIJACKER FROM EMACS TO STARTX
```
(add-to-list 'load-path "/users/dvnmk/dropbox/startx/startx-buffer-buffer/")
(require 'startx-buffer-mode)
```

## STARTX-THEATRE IS A REMOTE LIVE THEATRE ENVIRONMENT,
![foto](media/startx-theatre.png)

* LIVE CODING INSPIRED
* SATELLITE REMOTE PROGRAMMING INSPIRED 
* "THE LIBRARY OF BABEL BY JORGE LUIS BORGES" GELESEN.

## CONNECT TO STARTX
```
(defun tunnel ()
  (interactive)
  (call-process-shell-command
  "ssh -fnl 4004:localhost:4004 pi@mut.dlinkddns.com &"))
M-x tunnel
```
```
(defun vue ()
   (interactive)
   (call-process-shell-command
   "open -n -a mpv --args rtsp://mut.dlinkddns.com:554/ch0_1.h264 --no-audio --framedrop=vo --osd-align-x=right --osd-align-y=top &"))
M-x vue
```
```
M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)
```
```
CL-USER> (startx)
->->->alle null kalibriet, denke ich.
NIL
CL-USER>
```
## DEMO
## TODO
