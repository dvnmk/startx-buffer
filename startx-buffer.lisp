;;;; startx-buffer.lisp

(in-package #:cl-user)
		     
;;; "startx-buffer" goes here. Hacks and glory await!
;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y COMMON LISP
;;; FEB. 2015

(defparameter *startx-ip* "localhost")
(defparameter *startx-osc-port* 9000)
(defparameter *socket-s* nil)
(defparameter *socket-r* nil)
(defparameter *osc-port-r* 9001)

;;; helper (range)
(defun range (min max &optional (step 1))
  (when (<= min max)
    (cons min (range (+ min step) max step))))

;;; satz helper

;; (defun toggle-case-old  (string)
;;   "aBcDe -> AbCdE"
;;   (do ((i 0 (+ i 1))
;;         (len (length string))
;;         (res string))
;;       ((equal i len) res)
;;     (let ((ele (aref string i)))
;;       (if (< (char-code ele) 91)    ; ascii A 65 ~ Z 90, a 97 ~ z 122
;;           (setf (aref string i) (char-downcase ele))
;;           (setf (aref string i) (char-upcase ele))))))

(defun toggle-case  (string)
  "aBcDe -> (97 ...) -> (65 ...)"
  (let* ((res-list (coerce string 'list))
	 (res-ascii (mapcar #'char-code res-list))
	 (res (make-list 0)))
    (dolist (ele res-ascii)
      (cond ((< 64 ele 91)
	     (push (+ ele 32) res))
	    ((< 96 ele 123)
	     (push (- ele 32) res))
	    (t (push ele res))))
    (reverse res)))

(defun mach-socket-s ()
  "FUER BEFEHL"
  (defparameter  *socket-s* (usocket:socket-connect
                                  *startx-ip* *startx-osc-port*
                                  :protocol :datagram
                                  :element-type '(unsigned-byte 8))))
(defun kill-socket-s ()
  (usocket:socket-close *socket-s*))

(defun mach-socket-r ()
  (defparameter *socket-r*
    (usocket:socket-connect nil nil :protocol :datagram
			    :element-type '(unsigned-byte 8)
			    :local-host "127.0.0.1"
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

(defmacro each/ (pos path)
  "osc path helper"
  `(concatenate 'string "/each/" (write-to-string ,pos) "/" ,path))

(defmacro alle (cmd &optional tgl)
  `(let ((path (concatenate 'string "/alle/"
                            (string ',cmd))))
     (2startx path ,tgl)))

(defun s (pos &optional ∂)
  "pos kann nummer 0~16(0:alle), list sein, x:string or character"
  (let ((res (cond ((numberp ∂) ∂)
                   ((null ∂) nil)
                   ((stringp ∂) (toggle-case ∂))
                   (t (char-code ∂)))))
    (cond ((listp pos)
           (dolist (ele pos)
            ; (2startx (each/ ele "dec") res)
            (s ele ∂) ))
          ((zerop pos) (2startx "/alle/dec" res ))
          ((numberp pos) (2startx (each/ pos "dec") res)))))

(defun x-kurz (string &optional maxi-x aksel-x)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element 32))
	 (asc (toggle-case string)))
    (replace res asc)
    (maxi 0 maxi-x)
    (aksel 0 aksel-x)
    (2startx "/alle/satz"
             (nth 0  res) (nth 1 res) (nth 2 res) (nth 3 res)
             (nth 4  res) (nth 5 res) (nth 6 res) (nth 7 res)
             (nth 8  res) (nth 9 res) (nth 10 res) (nth 11 res)
             (nth 12 res) (nth 13 res) (nth 14 res) (nth 15 res))))

(defun a (∂str-or-char)
  "∂kurz -> 16 alle shot, ∂: str or char egal"
  (s 0 ∂str-or-char))

(defun x+ (string)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element nil))
         (lst (toggle-case string))
         (res (sublis '((32 . NIL)) (replace res lst))))
    (progn
      (s 1 (nth 0 res)) (s 2 (nth 1 res)) (s 3 (nth 2 res)) (s 4 (nth 3 res))
      (s 5 (nth 4 res)) (s 6 (nth 5 res)) (s 7 (nth 6 res)) (s 8 (nth 7 res))
      (s 9 (nth 8 res)) (s 10 (nth 9 res)) (s 11 (nth 10 res)) (s 12 (nth 11 res))
      (s 13 (nth 12 res)) (s 14 (nth 13 res)) (s 15 (nth 14 res)) (s 16 (nth 15 res))
      )))

(defmacro x- (string)
  "nur input existing each to change"
  (let* ((res (toggle-case string))
         (forms (mapcar (lambda (x) `,x) res)))
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

;; TODO inklusive (abal)?
(defun kali (&optional (pos 0) (tgl 1))
  (cond ((listp pos)
         (dolist (ele pos)
           (kali ele tgl)))
        ((zerop pos) (alle null tgl))
        ((not (null pos))(2startx (each/ pos "null") tgl))
        (t nil)))

(defun abal (&optional (pos 0))
  (s pos 128))	     

;; CMD
(defun init ()
  (mach-socket)
  (feedback-on)
  (osc-router-d "start"))

;; TODO defunize
(defun kredit ()
  (x "   A    by dvnmk")
  (sleep 0.1)
  (warte-alle-stop)
  (sleep 2)
  (x+ "     G")
  (sleep 0.1)
  (warte-alle-stop)
  (sleep 2)
  (x-kurz ">startx<ready!AA"))

(defun startx ()
  (setf (cdr (assoc "kali" *status* :test #'equalp)) 10)
  (netz 1)
  (sleep 1)
  (stm 0 1)
  (sleep 1)
  (kali 0 1)
  (warte "kali" 16)
  (kredit)
  (format t "THE MASCHINE STARTX INITIALIZED, VERMUTE ICH")
  )

(defun kali-warte ()
  (setf (cdr (assoc "kali" *status* :test #'equalp)) 10)
  (kali 0 1)
  (warte "kali" 16)
  (format t "ALLE NULL KALIBRIERT, DENKE ICH."))

(defun agur ()
  (abal 0)
  (sleep 7)
  (stm 0 0)
  (sleep 1)
  (netz 0)
  (format t "AGUR!"))

(defun foo (stepper-lst abs &optional maxi-x aksel-x)
  (progn (maxi stepper-lst maxi-x)
         (aksel stepper-lst aksel-x)
         (s stepper-lst abs)))

(defvar *oben* '(1 2 3 4 5 6 7 8))
(defvar *unten '(9 10 11 12 13 14 15 16))
(defvar *even* '(2 4 6 8 10 12 14 16))
(defvar *odd* '(1 3 5 7 9 11 13 15))
(defvar *alle* '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))

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

(mach-func-16 "A"
              LEB DL SPIRAL START-X
              CAT-1 CAT-2 FUNC-1 FUNC-2
              HAMMOCK1-1 HAMMOCK1-2 NEST TISCH
              HASEN CAT-3 LISP-1 LISP-2)
(mach-func-wo "A"
              '(5 6 14) CAT)
(mach-func-wo "A"
              '(7 8) FUNC)
(mach-func-wo "A"
              '(9 10) HAMMOCK1)
(mach-func-wo "A"
              '(15 16) LISP)

(mach-func-16 "B "
              BAUM1-1 BAUM1-2 BAUM1-3 BAUM1-4
              BAUM1-5 BAUM1-6 BAUM1-7 BAUM1-8
              BAUM1-9 BAUM1-10 BAUM1-11 BAUM1-12
              BAUM1-13 BAUM1-14 BAUM1-15 BAUM1-16 )
(mach-func-wo "B"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM1)

(mach-func-16 "C"
              BAUM2-1 BAUM2-2 BAUM2-3 BAUM2-4
              BAUM2-5 BAUM2-6 BAUM2-7 BAUM2-8
              BAUM2-9 BAUM2-10 BAUM2-11 BAUM2-12
              BAUM2-13 BAUM2-14 BAUM2-15 BAUM2-16 )
(mach-func-wo "C"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM2)

(mach-func-16 "D"
              BAUM3-1 BAUM3-2 BAUM3-3 BAUM3-4
              BAUM3-5 BAUM3-6 BAUM3-7 BAUM3-8
              BAUM3-9 BAUM3-10 BAUM3-11 BAUM3-12
              BAUM3-13 BAUM3-14 BAUM3-15 BAUM3-16 )

(mach-func-wo "D"
              '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) BAUM3)

(mach-func-16 "E"
              GEBAU-JEJU-1 GEBAU-JEJU-2 BAUM-JEJU-1 BAUM-JEJU-2
              BUSH FENSTER WOLKE STADT-AUS
              AUTO-FRAME BOGWANG-FLAG BETT-SIGN RACICE-STETI
              HAMMOCK-VIEW1 PRZYTARNIA-KAMP-SIGN FUCK-REALITY SOFA-LEMIAN)
(mach-func-wo "E" '(1 2) GEBAU-JEJU)
(mach-func-wo "E" '(3 4) BAUM-JEJU)

(mach-func-16 "F"
              SCHREIBMASCHINE LEER-JEJU GEBAU-HANGANG-1 GEBAU-HANGANG-2
              WASSERTURM1 WASSERTURM2 GEBAU-JECHON-1 GABAU-JECHON-2
              GEBAU-KOLN-1 GEBAU-KOLN-2 LAUNDARY-KOCHER WASSERHANN
              BOILER DRYER CONVER WASSER-PILE1)
(mach-func-wo "F" '(3 4) gebau-hangang)
(mach-func-wo "F" '(7 8) gebau-jechon)
(mach-func-wo "F" '(9 10) gebau-koln)

(mach-func-16 "G"
              VINO WASSER-PILE2 BIER-MAGOLI KAFE-CIGARET
              SANDORA KOE VIOLIN BALLET
              GOPDUNGI1-1 GOPDUNGI1-2 GOPDUNGI2 DONKIXOTE
              XCROSS  WINTER-IST-ES-KALT-ZU-RAUCHEN MUEDIGKEITS-GESELSCHAFT BONK )
(mach-func-wo "G" '(9 10) GOPDUNGI1)

(mach-func-16 "H"
              GASI KEEP-CALM-AND GLENDA1 GLENDA2
              UNFALL1 UNFALL2 HAMMOCK2 HAMMCOK3
              HAMMOCK-VIEW2 HAMMOCK-VIEW3 HAMMOCK4-1 HAMMOCK4-2
              DE-DAMAS KLO-1 KLO-2 ESSEN)
(mach-func-wo "H" '(3 4) GLENDA)
(mach-func-wo "H" '(5 6) UNFALL)
(mach-func-wo "H" '(11 12) HAMMCOK4)
(mach-func-wo "H" '(14 15) KLO)

(mach-func-16 "I"
              BOARD-HOTEL COCINA BOARD-ALBATROS BOARD-ESSEN
              BECHEROVKA BIONADE KOCH-WURST SONNENBRILLE
              EN-JOYSTICK-1 EN-JOYSTICK-2 LIEBE-ZU-DRRIT-1 LIEBE-ZU-DRRIT-2
              ICHAT-IM-BTHEK2-1 ICHAT-IM-BTHEK2-2 ICHAT-IM-BTHEK1 AUFM-KLO)
(mach-func-wo "I" '(9 10) EN-JOYSTICK)
(mach-func-wo "I" '(11 12) LIEBE-ZU-DRRIT)
(mach-func-wo "I" '(13 14) ICHAT-IM-BTHEK2)

(mach-func-16 "J"
              PPALDDUGI KATE MX-FAHRRAD BETT-IM-PARK-1
              BETT-IM-PARK-2 FAHRRAD-TENT STUFFE F8
              F9 F10 F11 F12
              F13 F14 F15 F16)
(mach-func-wo "J" '(4 5) BETT-IM-PARK)

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

;; OSC HANDLER 
(defparameter *status*
  '((1 . "stp")(2 . "stp")(3 . "stp")(4 . "stp")(5 . "stp")(6 . "stp")
    (7 . "stp")(8 . "stp")(9 . "stp")(10 . "stp")(11 . "stp")(12 . "stp")
    (13 . "stp")(14 . "stp")(15 . "stp")(16 . "stp")
    ("kali" . 0) ("stm" . 0) ("NULL" . 0) ("netz" . 0)
    ("each" . 0) ("bewegend" . 0)))

;(assoc "kali" *status* :test #'equalp)
;(assoc 0 *status* :test #'equalp)

(defun osc-router ()
  "place value at the adress in alist *status*"
  (let* ((buffer-r (make-array 20 :element-type '(unsigned-byte 8)))
         (received-msg (osc:decode-message (usocket:socket-receive *socket-r*
								   buffer-r 20)))
         (value (cadr received-msg))
         (address-0 (string-left-trim "/" (car received-msg)))
         (address-zu-int (parse-integer address-0 :junk-allowed t))
         (address (if (null address-zu-int)
                      address-0
                      address-zu-int))
         (gefunden (assoc address *status* :test #'equalp))) 
    (if (null gefunden)
        (format t "~%OSC ROUTING NOT GEFUNDEN")
        (progn (rplacd gefunden  value)
               (format t "~%=> ~S" gefunden)))
    gefunden))

(defun osc-router-loop ()
  (loop (osc-router)))

(defun osc-check (address value)
  "Check nth stepper go or stp, how many kali done"
           (equal (cdr (assoc address *status* :test #'equalp)) value)) 
;; (osc-check "kali" 16)
;; (osc-check 1 "go")
;; (osc-check 1 "stp")

(defun alle-stop-p ( )
  "Check ob alle 16 status stp ist, dann T, sonst NIL"
  (if (and (osc-check 1 "stp") (osc-check 2 "stp") (osc-check 3 "stp")
	   (osc-check 4 "stp") (osc-check 5 "stp") (osc-check 6 "stp")
	   (osc-check 7 "stp") (osc-check 8 "stp") (osc-check 9 "stp")
	   (osc-check 10 "stp") (osc-check 11 "stp") (osc-check 12 "stp")
	   (osc-check 13 "stp") (osc-check 14 "stp") (osc-check 15 "stp")
	   (osc-check 16 "stp"))
      'T))

(defun warte-alle-stop ( )
  "warte bis alle stop"
  (process-wait "ALLE-WARTE" #'alle-stop-p)
  (format t "GESTOPPT ALLE")
  't)
;; z.B.
;; (progn (x-kurz "wualamosimosi")
;; 		(sleep 0.1) ; braucht zwsn zeit,weil zu schnell die 'warte-alle-stop 
;; 		(warte-alle-stop))

(defparameter *satz-dauer* 2)
(defparameter *zwsn* 0.1)

(defun x-warte (∂)
  (progn (x-kurz ∂)
	 (sleep *zwsn*)
	 (warte-alle-stop)
	 (sleep *satz-dauer*)
	 't))

(defun nimm-16 (∂)
  "trim 16 y nimm es"
  (if (> (length ∂) 16)
      (subseq ∂ 0 16)
      ∂))

(defun x-lang (∂)
  "x mit lang satz"
  (do* ((was (nimm-16 ∂) (nimm-16 sonst))
	(sonst (subseq ∂ 16) (subseq sonst 16)))
       ((<= (length sonst) 16)
	(x-warte was)
	(x-warte sonst))
    (x-warte was)))

(defun x-wu (∂)
  "dies war x-final, finalisch wird zu x /o -final"
  (if (<= (length ∂) 16)
      (x-kurz ∂)
      (x-lang ∂)))

(defun x (∂)
  "thread version of x-wu"
  (process-run-function "thread" #'x-wu ∂))

;; clozure warte
(defun warte (address value)
  (process-wait "WARTE" #'osc-check address value)
  't)

;;(setf (nth (- 16 1) *status*) "VEN")

(defparameter *osc-router-d* nil)
(defun osc-router-d (&optional (x "status"))
  (cond ((equal x "stop") (process-kill *osc-router-d*))
        ((equal x "start")
         (defparameter *osc-router-d*
	   (process-run-function "OSC-ROUTER-D" #'osc-router-loop)))
        (t (all-processes))))

(defun feedback-on ()
  (2startx "/alle/FBK" 1))
(defun feedback-off ()
  (2startx "/alle/FBK" 0))

(defun vor (n)
  "reset n-th to 0"
  (2startx (format nil "/~A" n) 0))

(defun go-warte (n ∂)
  (vor n)
  (sleep 0.1)
  (s n ∂)
  (warte n "stp"))

(defun max-aks-n (n maxi-x aksel-x)
  (progn (maxi n maxi-x)
         (aksel n aksel-x))) 

(defparameter *baz*
  '("a" 1 "b" 1 "c" 1 "d" 1  "e" 1 "f" 1  "g" 1  "h" 1 "i" 1 "%" 3))
(defparameter *bilder*
  '("A" 1 "B" 1 "C" 1 "D" 1  "E" 1 "F" 1  "G" 1  "H" 1 "@" 3 ))
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

(defmacro mach-seq-x-loop (∂)
  (let ((f (intern (format nil "seq-~a-loop" ∂)))
	(f0 (intern (format nil "seq-~a" ∂))))
    `(defun ,f ()
       (loop (,f0)))))

;; (mapcar #'mach-seq-x-loop '(range 1 16 ))

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
(defun seq-1-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-1-d*))
        ((equal ∂ "start")
         (defparameter *seq-1-d*
	   (process-run-function "seq-1-d" #'seq-1-loop)))
        (t (all-processes))))

(defparameter *seq-2-d* nil)
(defun seq-2-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-2-d*))
        ((equal ∂ "start")
         (defparameter *seq-2-d* 
	   (process-run-function "seq-2-d" #'seq-2-loop)))
        (t (all-processes))))

(defparameter *seq-3-d* nil)
(defun seq-3-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-3-d*))
        ((equal ∂ "start")
         (defparameter *seq-3-d* 
	   (process-run-function "seq-3-d" #'seq-3-loop)))
        (t (all-processes))))

(defparameter *seq-4-d* nil)
(defun seq-4-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-4-d*))
        ((equal ∂ "start")
         (defparameter *seq-4-d* 
	   (process-run-function "seq-4-d" #'seq-4-loop)))
        (t (all-processes))))

(defparameter *seq-5-d* nil)
(defun seq-5-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-5-d*))
        ((equal ∂ "start")
         (defparameter *seq-5-d* 
	   (process-run-function "seq-5-d" #'seq-5-loop)))
        (t (all-processes))))

(defparameter *seq-6-d* nil)
(defun seq-6-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-6-d*))
        ((equal ∂ "start")
         (defparameter *seq-6-d* 
	   (process-run-function "seq-6-d" #'seq-6-loop)))
        (t (all-processes))))

(defparameter *seq-7-d* nil)
(defun seq-7-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-7-d*))
        ((equal ∂ "start")
         (defparameter *seq-7-d* 
	   (process-run-function "seq-7-d" #'seq-7-loop)))
        (t (all-processes))))

(defparameter *seq-8-d* nil)
(defun seq-8-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-8-d*))
        ((equal ∂ "start")
         (defparameter *seq-8-d* 
	   (process-run-function "seq-8-d" #'seq-8-loop)))
        (t (all-processes))))

(defparameter *seq-9-d* nil)
(defun seq-9-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-9-d*))
        ((equal ∂ "start")
         (defparameter *seq-9-d* 
	   (process-run-function "seq-9-d" #'seq-9-loop)))
        (t (all-processes))))

(defparameter *seq-10-d* nil)
(defun seq-10-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-10-d*))
        ((equal ∂ "start")
         (defparameter *seq-10-d* 
	   (process-run-function "seq-10-d" #'seq-10-loop)))
        (t (all-processes))))

(defparameter *seq-11-d* nil)
(defun seq-11-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-11-d*))
        ((equal ∂ "start")
         (defparameter *seq-11-d* 
	   (process-run-function "seq-11-d" #'seq-11-loop)))
        (t (all-processes))))

(defparameter *seq-12-d* nil)
(defun seq-12-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-12-d*))
        ((equal ∂ "start")
         (defparameter *seq-12-d* 
	   (process-run-function "seq-12-d" #'seq-12-loop)))
        (t (all-processes))))

(defparameter *seq-13-d* nil)
(defun seq-13-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-13-d*))
        ((equal ∂ "start")
         (defparameter *seq-13-d* 
	   (process-run-function "seq-13-d" #'seq-13-loop)))
        (t (all-processes))))

(defparameter *seq-14-d* nil)
(defun seq-14-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-14-d*))
        ((equal ∂ "start")
         (defparameter *seq-14-d* 
	   (process-run-function "seq-14-d" #'seq-14-loop)))
        (t (all-processes))))

(defparameter *seq-15-d* nil)
(defun seq-15-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-15-d*))
        ((equal ∂ "start")
         (defparameter *seq-15-d* 
	   (process-run-function "seq-15-d" #'seq-15-loop)))
        (t (all-processes))))

(defparameter *seq-16-d* nil)
(defun seq-16-d (&optional (∂ "status"))
  (cond ((equal ∂ "stop") (process-kill *seq-16-d*))
        ((equal ∂ "start")
         (defparameter *seq-16-d* 
	   (process-run-function "seq-16-d" #'seq-16-loop)))
        (t (all-processes))))

;; TODO defun od defmacro
(defun seq0 ()  t)

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

