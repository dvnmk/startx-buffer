;;;; startx-buffer.asd

(asdf:defsystem #:startx-buffer
  :description "Describe startx-buffer here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:osc #:usocket)
  :components ((:file "package")
               (:file "startx-buffer")))

