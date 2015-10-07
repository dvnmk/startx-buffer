# (+ STARTX LISP) => STARTX-BUFFER
![FOTO](MEDIA/STARTX-BUFFER_PROBE.PNG)

## STARTX IS A HOMEBREWED MACHINE,
* SPLIT DISPLAY MODUL X 16
* RASPBERRY PI, CHIPKIT, IP CAMERA
* PUREDATA
* COMMUNICATION VIA OSC

## STARTX-BUFFER IS,

- A EXPERIMENTALISCHE PHYSIKAL BUFFER
- \*SCRATCH\* BUFFER IN EMACS INSPIRED.
- STARTX-BUFFER-MODE.EL (ELISP - REAL TIME KEYINPUT HIJACKER TO STARTX IN EMACS)

(ADD-TO-LIST 'LOAD-PATH "/USERS/DVNMK/DROPBOX/STARTX/STARTX-BUFFER-BUFFER/")
(REQUIRE 'STARTX-BUFFER-MODE)

## STARTX-BUFFER.LISP IS,
## STARTX-THEATRE IS,
![FOTO](MEDIA/STARTX-THEATRE.PNG)

### CONNECT STARTX
    (DEFUN TUNNEL ()
      (INTERACTIVE)
      (CALL-PROCESS-SHELL-COMMAND "SSH -FNL 4004:LOCALHOST:4004 PI@MUT.DLINKDDNS.COM &"))
    
    M-X TUNNEL

	
### DEMO
### TODO
