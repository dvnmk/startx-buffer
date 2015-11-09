;;; startx-buffer.lisp
;(in-package #:startx-buffer)
;;; "startx-buffer" goes here. Hacks and glory await!
;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y COMMON LISP
;;; FEB. 2015

;;; swank

;; (eval-when (:compile-toplevel)
;;   (ql:quickload :usocket)
;;   (ql:quickload :osc))

;; (asdf:oos 'asdf:load-op 'usocket)
;; (asdf:oos 'asdf:load-op 'osc)

(asdf:load-system "osc")
(asdf:load-system "usocket")

(defpackage :startx-buffer
  (:use :cl :osc :usocket))

(defparameter *startx-ip* "localhost")
(defparameter *startx-osc-port* 9000)
(defparameter *socket-s* nil)
(defparameter *socket-r* nil)
(defparameter *osc-port-r* 9001)


;;; satz helper
(defun toggle-case  (string)
  "aBcDe -> AbCdE"
  (do* ((i 0 (+ i 1))
        (len (length string))
        (res string))
      ((equal i len) res)
    (let ((ele (aref string i)))
      (if (< (char-code ele) 91)               ; ascii A 65 ~ Z 90, a 97 ~ z 122
          (setf (aref string i) (char-downcase ele))
          (setf (aref string i) (char-upcase ele))))))

(defun mach-socket-s ()
  "FUER BEFEHL"
  (defparameter  *socket-s* (usocket:socket-connect
                                  *startx-ip* *startx-osc-port*
                                  :protocol :datagram
                                  :element-type '(unsigned-byte 8))))
(defun kill-socket-s ()
  (usocket:socket-close *socket-s*))

;; (defmacro mach-socket-r (n)
;;   "*SOCKET-N* :port 9000 + N"
;;   `(set (intern (format nil "*SOCKET-~A*" ,n))
;;        (usocket:socket-connect nil nil :protocol :datagram :element-type '(unsigned-byte 8) :local-host "127.0.0.1" :local-port (+ 9000 ,n))))

;; (defun kill-socket-r (n)
;;   (usocket:socket-close (eval (intern (format nil "*SOCKET-~A*" n)))))

(defun mach-socket-r ()
  (defparameter *socket-r*
    (usocket:socket-connect nil nil :protocol :datagram :element-type '(unsigned-byte 8) :local-host "127.0.0.1"
                            :local-port *osc-port-r*)))

(defun kill-socket-r ()
  (usocket:socket-close *socket-r*))

(defun mach-socket ()
  (progn (mach-socket-s)
         (mach-socket-r)))
(defun kill-socket ()
  (progn (kill-socket-s)
         (kill-socket-r)))

(defmacro 2startx (path &rest value)
  `(let* ((buffer (osc:encode-message ,path ,@value))
          (length (array-dimension buffer 0)))
     (progn
       (usocket:socket-send *SOCKET-S* buffer length)
       (format t "->"))))

(defmacro 4startx ()
  `(let ((buffer-r (make-array 20 :element-type '(unsigned-byte 8))))
     (progn
       (format t "-KOM...")
       (osc:decode-message (usocket:socket-receive *socket-r* buffer-r 20)))))

(defun osc-listen (port) 
  "a basic test function which attempts to decode an osc message a given port."
  (let ((s (usocket:socket-connect nil nil :protocol :datagram :element-type '(unsigned-byte 8) :local-host "127.0.0.1" :local-port port))
        (buffer (make-sequence '(vector (unsigned-byte 8)) 1024)))
   ; (socket-bind s #(0 0 0 0) port)
    (format t "listening on localhost port ~A~%~%" port)
    (unwind-protect 
	(loop do
	      (usocket:socket-receive s buffer 1024)
	      (format t "receiveded -=> ~S~%" (osc:decode-bundle buffer)))
      (when s (usocket:socket-close s)))))

(defmacro each/ (pos path)
  "osc path helper"
  `(concatenate 'string "/each/" (write-to-string ,pos) "/" ,path))

(defmacro alle (cmd &optional tgl)
  `(let ((path (concatenate 'string "/alle/"
                            (string ',cmd))))
     (2startx path ,tgl)))

(defun s (pos &optional x)
  "pos kann nummer 0~16(0:alle), list sein, x:string or character"
  (let ((res (cond ((numberp x) x)
                   ((null x) nil)
                   ((stringp x) (char-code (character x)))
                   (t (char-code x)))))
    (cond ((listp pos)
           (dolist (ele pos)
            ; (2startx (each/ ele "dec") res)
            (s ele x) ))
          ((zerop pos) (2startx "/alle/dec" res ))
          ((numberp pos) (2startx (each/ pos "dec") res)))))

(defun x (string &optional maxi-x aksel-x)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element 32))
        (lst (coerce (toggle-case string) 'list))
        (asc (mapcar #'char-code lst)))
    (replace res asc)
    (maxi 0 maxi-x)
    (aksel 0 aksel-x)
    (2startx "/alle/satz"
             (nth 0  res) (nth 1 res) (nth 2 res) (nth 3 res)
             (nth 4  res) (nth 5 res) (nth 6 res) (nth 7 res)
             (nth 8  res) (nth 9 res) (nth 10 res) (nth 11 res)
             (nth 12 res) (nth 13 res) (nth 14 res) (nth 15 res))))

(defun a (x.str-or-char)
  "x -> 16 alle shot, x : str or char egal"
  (cond ((characterp x.str-or-char)
         (s 0 (char-code x.str-or-char)))
        ((stringp x.str-or-char)
         (s 0 (character x.str-or-char)))
        (t 'k.A)))
(defun x+ (string)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element nil))
         (lst (coerce (toggle-case string) 'list))
         (res (sublis '((#\  . NIL)) (replace res lst))))
    (progn
      (s 1 (nth 0 res)) (s 2 (nth 1 res)) (s 3 (nth 2 res)) (s 4 (nth 3 res))
      (s 5 (nth 4 res)) (s 6 (nth 5 res)) (s 7 (nth 6 res)) (s 8 (nth 7 res))
      (s 9 (nth 8 res)) (s 10 (nth 9 res)) (s 11 (nth 10 res)) (s 12 (nth 11 res))
      (s 13 (nth 12 res)) (s 14 (nth 13 res)) (s 15 (nth 14 res)) (s 16 (nth 15 res))
      )))
(defmacro x- (string)
  "nur input existing each to change"
  (let* ((lst (coerce (toggle-case string) 'list))
         (asc (mapcar #'char-code lst))
         (forms (mapcar (lambda (x) `,x) asc)))
    `(2startx "/alle/satz" ,@forms)))

(defun maxi (pos &optional max-spd)
  (cond ((null max-spd) nil)
        ((listp pos)
         (dolist (ele pos)
           (maxi ele max-spd)))
        ((zerop pos) (alle maxi max-spd))
        ((not (null pos))(2startx (each/ pos "max") max-spd))
        (t nil)))
(defun maxi-lst (lst)
  "as list, one-shot maxi kontrol"
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (maxi i (car cur))))
;; (maxi '(11 12 nil 14 15 16 17 17 nil 19 0 1 2 3 4 ))
;; (maxi 0 100)
;; (maxi 1 99)

(defun aksel (pos &optional accel-var)
  (cond ((null accel-var) nil)
        ((listp pos)
         (dolist (ele pos)
           (aksel ele accel-var)))
        ((zerop pos) (alle aksel accel-var))
        ((not (null pos))(2startx (each/ pos "accel") accel-var))
        (t nil)))
(defun aksel-lst (lst)
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (aksel i (car cur))))

(defun stm (pos tgl)
  (cond ((listp pos)
         (dolist (ele pos)
           (stm ele tgl)))
    ((zerop pos) (alle stm tgl))
        ((not (null pos))(2startx (each/ pos "stm") tgl))
        (t nil)))
(defun netz (tgl)
  (alle netz tgl))
(defun kali (pos tgl)
  (cond ((listp pos)
         (dolist (ele pos)
           (kali ele tgl)))
        ((zerop pos) (alle null tgl))
        ((not (null pos))(2startx (each/ pos "null") tgl))
        (t nil)))
(defun abal (pos)
  (s pos 128))

;; CMD
(defun init ()
  (mach-socket)
  (feedback-on)
  (osc-router-d "start"))

(defun startx ()
  (setf (cdr (assoc "kali" *status* :test #'equalp)) 10)
  (netz 1)
  (sleep 1)
  (stm 0 1)
  (sleep 1)
  (kali 0 1)
  (warte "kali" 16)
  (format t "alle null kalibriert, denke ich.")
  (x "startx:ready"))

(defun kali-warte ()
  (setf (cdr (assoc "kali" *status* :test #'equalp)) 10)
  (kali 0 1)
  (warte "kali" 16)
  (format t "alle null kalibriert, denke ich."))

(defun agur ()
  (abal 0)
  (sleep 7)
  (stm 0 0)
  (sleep 1)
  (netz 0))

(defun foo (stepper-lst abs &optional maxi-x aksel-x)
  (progn (maxi stepper-lst maxi-x)
         (aksel stepper-lst aksel-x)
         (s stepper-lst abs)))

(defvar *oben* '(1 2 3 4 5 6 7 8))
(defvar *unten '(9 10 11 12 13 14 15 16))
(defvar *even* '(2 4 6 8 10 12 14 16))
(defvar *odd* '(1 3 5 7 9 11 13 15))
(defvar *alle* '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))

;; (foo '(1 2 3) "c" 500 500)
;; (foo '(1) "x" 1000 1000)
;; (s '(1 2) "k")
;; (s '(1 2) "0")
;; (x " dddddddddddddddddddddddddd")
;; (x "abbbbb")
;; (s '(1 2 3) "c")
;; (s *oben* "o")
;; (foo *oben* "o" 100 100)
;; (loop for i from 1 to 3 do
;;      (foo *oben* "o" 100 100)
;;      (sleep 5)
;;      (foo *oben* "x" 500 500))


;; (loop for i from 1 to 4 do
;;      (x "hello-wrld_world" 300 300)
;;      (sleep 12)
;;      (x "null-is-null" 1000 1000)
;;      (sleep 9)
;; )

;; (defun baz (x-mal)
;;   (loop for i from 1 to x-mal do
;;        (x "hello-wrld_world" 300 300)
;;        (sleep 5)
;;        (x " mosi " 1000 1000)
;;        (sleep 4))
;;   'FER)

;; (loop for i from 1 to 5 do
;;      (baz 5))

;; (abal 0)
;; (agur)
;; (maxi 0 1000)
;; (aksel 0 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun spido (x-maxi x-aksel)
  (maxi 0 x-maxi)
  (aksel 0 x-aksel))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro mach-func-16 (was f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16)
  (let (
        (f1 (intern (format nil "~a"  f1)))
        (f2 (intern (format nil "~a"  f2)))
        (f3 (intern (format nil "~a"  f3)))
        (f4 (intern (format nil "~a"  f4)))
        (f5 (intern (format nil "~a"  f5)))
        (f6 (intern (format nil "~a"  f6)))
        (f7 (intern (format nil "~a"  f7)))
        (f8 (intern (format nil "~a"  f8)))
        (f9 (intern (format nil "~a"  f9)))
        (f10 (intern (format nil "~a" f10)))
        (f11 (intern (format nil "~a" f11)))
        (f12 (intern (format nil "~a" f12)))
        (f13 (intern (format nil "~a" f13)))
        (f14 (intern (format nil "~a" f14)))
        (f15 (intern (format nil "~a" f15)))
        (f16 (intern (format nil "~a" f16)))
        )
    `(progn
       (defun ,f1 () (s '(1) ,was)
              (princ "FOO"))
       (defun ,f2 () (s '(2) ,was))
       (defun ,f3 () (s '(3) ,was))
       (defun ,f4 () (s '(4) ,was))
       (defun ,f5 () (s '(5) ,was))
       (defun ,f6 () (s '(6) ,was))
       (defun ,f7 () (s '(7) ,was))
       (defun ,f8 () (s '(8) ,was))
       (defun ,f9 () (s '(9) ,was))
       (defun ,f10 () (s '(10) ,was))
       (defun ,f11 () (s '(11) ,was))
       (defun ,f12 () (s '(12) ,was))
       (defun ,f13 () (s '(13) ,was))
       (defun ,f14 () (s '(14) ,was))
       (defun ,f15 () (s '(15) ,was))
       (defun ,f16 () (s '(16) ,was))
      )))

(defmacro mach-func-wo (was wo func-name)
  "wo ist List z.B. '(1 2 3)"
  (let ((a1 (intern (format nil "~a" func-name))))
    `(defun ,a1 ()
       (s ,wo ,was))))

;; (defun mach-func-at-was (was fn-list)
;;   (do ((i 1 (+ 1 i))
;;        (el (car fn-list) (cdr fn-list)))
;;       ((null el) 'fertig)
;;     (mach-func was el i)))

(mach-func-16 "a"
              LEB DL SPIRAL START-X
              CAT-1 CAT-2 FUNC-1 FUNC-2
              HAMMOCK1-1 HAMMOCK1-2 NEST TISCH
              HASEN CAT-3 LISP-1 LISP-2)
(mach-func-wo "a"
              '(5 6 14) CAT)
(mach-func-wo "a"
              '(7 8) FUNC)
(mach-func-wo "a"
              '(9 10) HAMMOCK1)
(mach-func-wo "a"
              '(15 16) LISP)

(mach-func-16 "b"
              BAUM1-1 BAUM1-2 BAUM1-3 BAUM1-4
              BAUM1-5 BAUM1-6 BAUM1-7 BAUM1-8
              BAUM1-9 BAUM1-10 BAUM1-11 BAUM1-12
              BAUM1-13 BAUM1-14 BAUM1-15 BAUM1-16 )
(mach-func-wo "b"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM1)

(mach-func-16 "c"
              BAUM2-1 BAUM2-2 BAUM2-3 BAUM2-4
              BAUM2-5 BAUM2-6 BAUM2-7 BAUM2-8
              BAUM2-9 BAUM2-10 BAUM2-11 BAUM2-12
              BAUM2-13 BAUM2-14 BAUM2-15 BAUM2-16 )
(mach-func-wo "c"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM2)

(mach-func-16 "d"
              BAUM3-1 BAUM3-2 BAUM3-3 BAUM3-4
              BAUM3-5 BAUM3-6 BAUM3-7 BAUM3-8
              BAUM3-9 BAUM3-10 BAUM3-11 BAUM3-12
              BAUM3-13 BAUM3-14 BAUM3-15 BAUM3-16 )
(mach-func-wo "d"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM3)

(mach-func-16 "e"
              GEBAU-JEJU-1 GEBAU-JEJU-2 BAUM-JEJU-1 BAUM-JEJU-2
              BUSH FENSTER WOLKE STADT-AUS
              AUTO-FRAME BOGWANG-FLAG BETT-SIGN RACICE-STETI
              HAMMOCK-VIEW1 PRZYTARNIA-KAMP-SIGN FUCK-REALITY SOFA-LEMIAN)
(mach-func-wo "e" '(1 2) GEBAU-JEJU)
(mach-func-wo "e" '(3 4) BAUM-JEJU)

(mach-func-16 "f"
              SCHREIBMASCHINE LEER-JEJU GEBAU-HANGANG-1 GEBAU-HANGANG-2
              WASSERTURM1 WASSERTURM2 GEBAU-JECHON-1 GABAU-JECHON-2
              GEBAU-KOLN-1 GEBAU-KOLN-2 LAUNDARY-KOCHER WASSERHANN
              BOILER DRYER CONVER WASSER-PILE1)
(mach-func-wo "f" '(3 4) gebau-hangang)
(mach-func-wo "f" '(7 8) gebau-jechon)
(mach-func-wo "f" '(9 10) gebau-koln)

(mach-func-16 "g"
              VINO WASSER-PILE2 BIER-MAGOLI KAFE-CIGARET
              SANDORA KOE VIOLIN BALLET
              GOPDUNGI1-1 GOPDUNGI1-2 GOPDUNGI2 DONKIXOTE
              XCROSS  WINTER-IST-ES-KALT-ZU-RAUCHEN MUEDIGKEITS-GESELSCHAFT BONK )
(mach-func-wo "g" '(9 10) GOPDUNGI1)

(mach-func-16 "h"
              GASI KEEP-CALM-AND GLENDA1 GLENDA2
              UNFALL1 UNFALL2 HAMMOCK2 HAMMCOK3
              HAMMOCK-VIEW2 HAMMOCK-VIEW3 HAMMOCK4-1 HAMMOCK4-2
              DE-DAMAS KLO-1 KLO-2 ESSEN)
(mach-func-wo "h" '(3 4) GLENDA)
(mach-func-wo "h" '(5 6) UNFALL)
(mach-func-wo "h" '(11 12) HAMMCOK4)
(mach-func-wo "h" '(14 15) KLO)

(mach-func-16 "i"
              BOARD-HOTEL COCINA BOARD-ALBATROS BOARD-ESSEN
              BECHEROVKA BIONADE KOCH-WURST SONNENBRILLE
              EN-JOYSTICK-1 EN-JOYSTICK-2 LIEBE-ZU-DRRIT-1 LIEBE-ZU-DRRIT-2
              ICHAT-IM-BTHEK2-1 ICHAT-IM-BTHEK2-2 ICHAT-IM-BTHEK1 AUFM-KLO)
(mach-func-wo "i" '(9 10) EN-JOYSTICK)
(mach-func-wo "i" '(11 12) LIEBE-ZU-DRRIT)
(mach-func-wo "i" '(13 14) ICHAT-IM-BTHEK2)

(mach-func-16 "j"
              PPALDDUGI KATE MX-FAHRRAD BETT-IM-PARK-1
              BETT-IM-PARK-2 FAHRRAD-TENT STUFFE F8
              F9 F10 F11 F12
              F13 F14 F15 F16)
(mach-func-wo "j" '(4 5) BETT-IM-PARK)

(defun blk ()
  (a " "))
(defun foo1 ()
  (baum2)
  (sleep 1)
;  (baum1)
  (sleep 2)
;  (baum3)
  (sleep 3)
  (baum3)
;  (sleep 1)
  'FER)

;; (defun improved-venga ()~
;;   (loop
;;      (foo1)
;;      (sb-thread:?? 'fertig-p-of-foo1
;;                    "waiting for something to happen")))

;; (defun venga-ein()
;;   (defparameter *thread* (sb-thread:make-thread #'venga)))

;; (defun aus()
;;   (sb-thread:terminate-thread *thread*))

;(defun foo-go ())

;=> '(1 3 5 7) ; 1, 3, 5, 6 bewegung gestartet
;; (defun gestoppt-p (wo)
;;   "check ob wo gestoppt od. nicht"
;;   ;;irgendwie send check befehl zu puredata via osc
;;   ;;y, warte aus osc-receive
;;   )

;; (defun venga-a ()
;;   (loop
;;        (x "a") ; => '(1) bewegung zur "a"
;;        (print "-bewegung-")
;;      (warte-for-gestopp (bewegung-p 1))))


;; SWANK vs VPN
;; ELISP PROBLEM

;; open -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_1.h264

;; UDP over SSH
;; STARTX      WAN        MB
;;  9000 <----10000-     9000
;;  9001     -10001----> 9001

;; ssh -L 10000:localhost:10000 pi@mut.dlinkddns.com 'socat tcp4-listen:10000,reuseaddr,fork udp:127.0.0.1:9000'
;; socat -T15 udp4-recvfrom:9000,reuseaddr,fork tcp:127.0.0.1:10000

;; ssh -fN -R 10001:localhost:10001 pi@mut.dlinkddns.com
;; TCP > (UDP) / oscdump / server
;; socat tcp4-listen:10001,reuseaddr,fork udp:127.0.0.1:9001
;; UDP > (TCP) / sendOSC / client
;; socat -T15 udp4-recvfrom:9001,reuseaddr,fork tcp:localhost:10001

(defun vue ()
  (defparameter *vue*
    (run-program "/bin/sh" (list "-c" "open -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_1.h264")
                :wait nil :output *standard-output*)))
(defun vncserver-editmode ()
  (run-program "/bin/sh" (list "-c" "ssh pi@mut.dlinkddns.com 'vncserver -geometry 650x800 -depth 8 -rfbport 5910'") :wait nil :output *standard-output*))
(defun vncserver-ein ()
  (run-program "/bin/sh" (list "-c" "ssh pi@mut.dlinkddns.com './vnc.sh'") :wait nil :output *standard-output*))
(defun vncserver-kill ()
  (run-program "/bin/sh" (list "-c" "ssh pi@mut.dlinkddns.com 'vncserver -kill :1'") :wait nil :output *standard-output*))
(defun vnc-viewer ()
  (defparameter *vnc-viewer*
    (run-program "/bin/sh" (list "-c" "open vnc://mut.dlinkddns.com:5910") :wait nil :output *standard-output*)))

(defun outgoing-tunneling ()
  (run-program "/bin/sh" (list "-c" "ssh -fN -L 10000:localhost:10000 pi@mut.dlinkddns.com") :wait nil :output *standard-output*))
(defun reverse-tunneling ()
  (run-program "/bin/sh" (list "-c" "ssh -fN -R 10001:localhost:10001 pi@mut.dlinkddns.com") :wait nil :output *standard-output*))
(defun da-socat-tcp2udp ()
  (run-program "/bin/sh" (list "-c" "ssh pi@mut.dlinkddns.com 'socat tcp4-listen:10000,reuseaddr,fork udp:127.0.0.1:9000'") :wait nil :output *standard-output*))
(defun udp2tcp () ;outgoing udp 9000 -> tcp 10000
  (run-program "/bin/sh" (list "-c" "socat -T15 udp4-recvfrom:9000,reuseaddr,fork tcp:127.0.0.1:10000") :wait nil :output *standard-output*))
(defun t4cp2udp () ;incomming tcp 10000 -> udp 9001
  (run-program "/bin/sh" (list "-c" "socat tcp4-listen:10001,reuseaddr,fork udp:127.0.0.1:9001") :wait nil :output *standard-output*))
(defun da-socat-udp2tcp ()
  (run-program "/bin/sh" (list "-c" "ssh pi@mut.dlinkddns.com 'socat -T15 udp4-recvfrom:9001,reuseaddr,fork tcp:localhost:10001'") :wait nil :output *standard-output*))

;; (defun osc-select (addr-x value-x)
;;   (do* ((addr (car kommt-osc) (car kommt-osc))
;;         (value (cadr kommt-osc) (cadr kommt-osc)))
;;       ((and (equal addr addr-x) (equal value value-x))
;;        (progn
;;          (format t "FER:~S ~S~%" addr value)
;;          'T)
;;        ) 
;;    ; (format t "~S ~S~%" addr value)
;;     ))
;; (defun warte-bis (addr-x tgr)
;;   (do ((i (nth (- addr-x 1) *status*)(nth (- addr-x 1) *status*)))
;;       ((equal i tgr) "END")
;;     (sleep 1)))

;; CL-USER> (progn
;;            (2startx "/delay" 5000)
;;            (osc-select "/delay/fbk" 1))
;; -TX-
;; T

;; ;; emacs defun
;; (defun vue ()
;;   (async-shell-command   "open -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_1.h264 &"))
;; (defun vnc-editmode ()
;;   (async-shell-command   "ssh pi@mut.dlinkddns.com 'vncserver -geometry 650x800 -depth 8 -rfbport 5910' &" ))
;; (defun vnc-editmode-2 ()
;;   (async-shell-command   "ssh pi@mut.dlinkddns.com 'vncserver -geometry 720x1024 -depth 8 -rfbport 5910' &" ))
;; (defun vnc-ein ()
;;   (async-shell-command   "ssh pi@mut.dlinkddns.com './vnc.sh' &" ))
;; (defun vnc-kill ()
;;   (async-shell-command   "ssh pi@mut.dlinkddns.com 'vncserver -kill :1' &" ))
;; (defun vnc-view ()
;;   (async-shell-command   "open vnc://mut.dlinkddns.com:5910 &"))
;; (defeun tunneling ()
;; (async-shell-command "ssh -fN -L 4004:localhost:4004 pi@mut.dlinkddns.com")

;; OSC HANDLER 
;#run.0
(defparameter *status* '((1 . 0)(2 . 0)(3 . 0)(4 . 0)(5 . 0)(6 . 0)(7 . 0)(8 . 0)
                         (9 . 0)(10 . 0)(11 . 0)(12 . 0)(13 . 0)(14 . 0)(15. 0)(16 . 0)
                         ("kali" . 0) ("stm" . 0) ("NULL" . 0) ("netz" . 0)
                         ("each" . 0)))
;(assoc "kali" *status* :test #'equalp)
;(assoc 0 *status* :test #'equalp)

(defun osc-router ()
  "place value at the adress in alist *status*"
  (let* ((buffer-r (make-array 20 :element-type '(unsigned-byte 8)))
         (received-msg (osc:decode-message (usocket:socket-receive *socket-r* buffer-r 20)))
         (value (cadr received-msg))
         (address-0 (string-left-trim "/" (car received-msg)))
         (address-zu-int (parse-integer address-0 :junk-allowed t))
         (address (if (null address-zu-int)
                      address-0
                      address-zu-int))
         (gefunden (assoc address *status* :test #'equalp))) 
    (if (null gefunden)
        (format t "~%OSC routing not gefunden")
        (progn (rplacd gefunden  value)
               (format t "~%=> ~S" gefunden)))
    gefunden))
(defun osc-router-loop ()
  (loop (osc-router)))

(defun status-reset ()
  (defparameter *status* (make-list 16 :initial-element "xx")))

;; clozure warte
(defun check-mal (address value)
           (equal (cdr (assoc address *status* :test #'equalp)) value))
;(check-mal "kali" 16)
;(check-mal 1 "TOGO")
(defun warte (address value)
  (process-wait "WARTE" #'check-mal address value)
  't)

;;(setf (nth (- 16 1) *status*) "VEN")

(defparameter *osc-router-d* nil)
(defun osc-router-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *osc-router-d*))
        ((equal x "start")
         (defparameter *osc-router-d* (process-run-function "OSC-ROUTER-D" #'osc-router-loop)))
        (t (all-processes))))

(defun feedback-on ()
  (2startx "/alle/FBK" 1))
(defun feedback-off ()
  (2startx "/alle/FBK" 0))

;; ** TODO SYNTAX-HIGHLIGHT
;; ** (WARTE-<= n)

(defun vor (n)
  "reset n-th to 0"
  (2startx (format nil "/~A" n) 0))
(defun go-warte (n x)
  (vor n)
  (sleep 0.1)
  (s n x)
  (warte n "stp"))

(defun max-aks-n (n maxi-x aksel-x)
  (progn (maxi n maxi-x)
         (aksel n aksel-x))) 

(defparameter *baz* '("a" 1 "b" 1 "c" 1 "d" 1  "e" 1 "f" 1  "g" 1  "h" 1 "i" 1 "%" 3))
(defparameter *bilder* '("A" 1 "B" 1 "C" 1 "D" 1  "E" 1 "F" 1  "G" 1  "H" 1 "@" 3 ))
(defparameter *seq-1* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-2* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-3* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-4* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-5* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-6* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-7* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-8* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-9* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-10* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-11* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-12* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-13* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-14* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-15* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *seq-16* '("S" 0.5 "T" 0.5 "A" 0.5 "R" 0.5 "T" 0.5 "X" 4))
(defparameter *hello-world* '("H" 3 "E" 3 "L" 3 "L" 3 "O" 3 "W" 3 "R" 3 "L" 3 "D"))

(progn
  (defun seq-1-loop () (loop (seq-1)))
  (defun seq-2-loop () (loop (seq-2)))
  (defun seq-3-loop () (loop (seq-3)))
  (defun seq-4-loop () (loop (seq-4)))
  (defun seq-5-loop () (loop (seq-5)))
  (defun seq-6-loop () (loop (seq-6)))
  (defun seq-7-loop () (loop (seq-7)))
  (defun seq-8-loop () (loop (seq-8)))
  (defun seq-9-loop () (loop (seq-9)))
  (defun seq-10-loop () (loop (seq-10)))
  (defun seq-11-loop () (loop (seq-11)))
  (defun seq-12-loop () (loop (seq-12)))
  (defun seq-13-loop () (loop (seq-13)))
  (defun seq-14-loop () (loop (seq-14)))
  (defun seq-15-loop () (loop (seq-15)))
  (defun seq-16-loop () (loop (seq-16)))
)

(defparameter *seq-1-d* nil)
(defun seq-1-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-1-d*))
        ((equal x "start")
         (defparameter *seq-1-d* (process-run-function "seq-1-d" #'seq-1-loop)))
        (t (all-processes))))
(defparameter *seq-2-d* nil)
(defun seq-2-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-2-d*))
        ((equal x "start")
         (defparameter *seq-2-d* (process-run-function "seq-2-d" #'seq-2-loop)))
        (t (all-processes))))
(defparameter *seq-3-d* nil)
(defun seq-3-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-3-d*))
        ((equal x "start")
         (defparameter *seq-3-d* (process-run-function "seq-3-d" #'seq-3-loop)))
        (t (all-processes))))
(defparameter *seq-4-d* nil)
(defun seq-4-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-4-d*))
        ((equal x "start")
         (defparameter *seq-4-d* (process-run-function "seq-4-d" #'seq-4-loop)))
        (t (all-processes))))
(defparameter *seq-5-d* nil)
(defun seq-5-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-5-d*))
        ((equal x "start")
         (defparameter *seq-5-d* (process-run-function "seq-5-d" #'seq-5-loop)))
        (t (all-processes))))
(defparameter *seq-6-d* nil)
(defun seq-6-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-6-d*))
        ((equal x "start")
         (defparameter *seq-6-d* (process-run-function "seq-6-d" #'seq-6-loop)))
        (t (all-processes))))
(defparameter *seq-7-d* nil)
(defun seq-7-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-7-d*))
        ((equal x "start")
         (defparameter *seq-7-d* (process-run-function "seq-7-d" #'seq-7-loop)))
        (t (all-processes))))
(defparameter *seq-8-d* nil)
(defun seq-8-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-8-d*))
        ((equal x "start")
         (defparameter *seq-8-d* (process-run-function "seq-8-d" #'seq-8-loop)))
        (t (all-processes))))
(defparameter *seq-9-d* nil)
(defun seq-9-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-9-d*))
        ((equal x "start")
         (defparameter *seq-9-d* (process-run-function "seq-9-d" #'seq-9-loop)))
        (t (all-processes))))
(defparameter *seq-10-d* nil)
(defun seq-10-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-10-d*))
        ((equal x "start")
         (defparameter *seq-10-d* (process-run-function "seq-10-d" #'seq-10-loop)))
        (t (all-processes))))
(defparameter *seq-11-d* nil)
(defun seq-11-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-11-d*))
        ((equal x "start")
         (defparameter *seq-11-d* (process-run-function "seq-11-d" #'seq-11-loop)))
        (t (all-processes))))
(defparameter *seq-12-d* nil)
(defun seq-12-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-12-d*))
        ((equal x "start")
         (defparameter *seq-12-d* (process-run-function "seq-12-d" #'seq-12-loop)))
        (t (all-processes))))
(defparameter *seq-13-d* nil)
(defun seq-13-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-13-d*))
        ((equal x "start")
         (defparameter *seq-13-d* (process-run-function "seq-13-d" #'seq-13-loop)))
        (t (all-processes))))
(defparameter *seq-14-d* nil)
(defun seq-14-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-14-d*))
        ((equal x "start")
         (defparameter *seq-14-d* (process-run-function "seq-14-d" #'seq-14-loop)))
        (t (all-processes))))
(defparameter *seq-15-d* nil)
(defun seq-15-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-15-d*))
        ((equal x "start")
         (defparameter *seq-15-d* (process-run-function "seq-15-d" #'seq-15-loop)))
        (t (all-processes))))
(defparameter *seq-16-d* nil)
(defun seq-16-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *seq-16-d*))
        ((equal x "start")
         (defparameter *seq-16-d* (process-run-function "seq-16-d" #'seq-16-loop)))
        (t (all-processes))))


(defun seq0 ( )
  t
  )

(defun seq-1 ()
  (let ((x *seq-1*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 1 ele)))))

(defun seq-2 ()
  (let ((x *seq-2*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 2 ele)))))

(defun seq-3 ()
  (let ((x *seq-3*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 3 ele)))))

(defun seq-4 ()
  (let ((x *seq-4*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 4 ele)))))

(defun seq-5 ()
  (let ((x *seq-5*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 5 ele)))))

(defun seq-6 ()
  (let ((x *seq-6*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 6 ele)))))

(defun seq-7 ()
  (let ((x *seq-7*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 7 ele)))))

(defun seq-8 ()
  (let ((x *seq-8*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 8 ele)))))

(defun seq-9 ()
  (let ((x *seq-9*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 9 ele)))))

(defun seq-10 ()
  (let ((x *seq-10*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 10 ele)))))

(defun seq-11 ()
  (let ((x *seq-11*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 11 ele)))))

(defun seq-12 ()
  (let ((x *seq-12*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 12 ele)))))

(defun seq-13 ()
  (let ((x *seq-13*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 13 ele)))))

(defun seq-14 ()
  (let ((x *seq-14*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 14 ele)))))

(defun seq-15 ()
  (let ((x *seq-15*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 15 ele)))))

(defun seq-16 ()
  (let ((x *seq-16*))
    (dolist (ele x)
      (if (numberp ele) (sleep ele)
	  (go-warte 16 ele)))))

(defun venga ( )
  (seq-1-d "start")
  (seq-2-d "start")
  (seq-3-d "start")
  (seq-4-d "start")
  (seq-5-d "start")
  (seq-6-d "start")
  (seq-7-d "start")
  (seq-8-d "start")
  (seq-9-d "start")
  (seq-10-d "start")
  (seq-11-d "start")
  (seq-12-d "start")
  (seq-13-d "start")
  (seq-14-d "start")
  (seq-15-d "start")
  (seq-16-d "start"))

(defun stop ( )
  (seq-1-d "stop")
  (seq-2-d "stop")
  (seq-3-d "stop")
  (seq-4-d "stop")
  (seq-5-d "stop")
  (seq-6-d "stop")
  (seq-7-d "stop")
  (seq-8-d "stop")
  (seq-9-d "stop")
  (seq-10-d "stop")
  (seq-11-d "stop")
  (seq-12-d "stop")
  (seq-13-d "stop")
  (seq-14-d "stop")
  (seq-15-d "stop")
  (seq-16-d "stop")
  (abal 0))
