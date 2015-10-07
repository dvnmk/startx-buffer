(+ STARTX LISP) => STARTX-BUFFER
=================================
![foto](media/startx-buffer_probe.png)
STARTX is a homebrewed machine, with
------------------------------------
* stepper motor y DIY Circuit
* OSC (Open Sound Control)
* chipkit 
* puredata 

STARTX-BUFFER is,
-----------------
* a physikal buffer
* connected to common lisp od. emacs lisp
* allthing in emacs could be sent to startx-buffer
* et al.

Syntax
------
`(defun tunnel ()
  (interactive)
  (call-process-shell-command "ssh -fNL 4004:localhost:4004 pi@mut.dlinkddns.com &"))
`
Demo
----

Todo
----

