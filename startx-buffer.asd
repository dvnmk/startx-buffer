;;;; startx-buffer.asd

(asdf:defsystem #:startx-buffer
  :description "Describe startx-buffer here"
  :author "dvnmk <divinomok@gmail.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:osc #:usocket)
  :components ((:file "package")
               (:file "startx-buffer")))

