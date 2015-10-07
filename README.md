# (+ STARTX LISP) => STARTX-BUFFER
![foto](media/startx-buffer_probe.png)

## STARTX IS A HOMEBREWED MACHINE,
* SPLIT DISPLAY MODUL * 16
* RASPBERRY PI, CHIPKIT, IP CAMERA
* PUREDATA
* VIA OSC

## STARTX-BUFFER IS,
* A EXPERIMENTALISCHE PHYSIKALISCHE BUFFER
* \*SCRATCH\* BUFFER IN EMACS INSPIRED.
* STARTX-BUFFER-MODE.EL ; REAL TIME KEYINPUT HIJACKER FROM EMACS TO STARTX
`
    (add-to-list 'load-path "/users/dvnmk/dropbox/startx/startx-buffer-buffer/")
    (require 'startx-buffer-mode)
`
## STARTX-THEATRE.LISP IS,
![foto](media/startx-theatre.png)

### CONNECT STARTX
    (defun tunnel ()
      (interactive)
      (call-process-shell-command "ssh -fnl 4004:localhost:4004 pi@mut.dlinkddns.com &"))
    
    M-x tunnel

    (defun vue ()
      (interactive)
      (call-process-shell-command "open -n -a mpv --args rtsp://mut.dlinkddns.com:554/ch0_1.h264 --no-audio --framedrop=vo --osd-align-x=right --osd-align-y=top &"))

    M-x vue

    M-x slime-connect (RET) 127.0.0.1 (RET) 4004 (RET)

### DEMO
### TODO
