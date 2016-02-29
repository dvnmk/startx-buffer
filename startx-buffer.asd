;;;; startx-buffer.asd

(asdf:defsystem #:startx-buffer
  :description "
* A EXPERIMENTAL PHYSIKAL REMOTE BUFFER
* REAL TIME KEYINPUT HIJACKER FROM EMACS TO THE STARTX
"
  :author "dvnmk <divinomok@gmail.com>"
  :license  "The Artistic License 2.0"
  :serial t
  :depends-on (#:osc #:usocket)
  :components ((:file "package")
               (:file "startx-buffer")))

