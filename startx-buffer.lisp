;;;; startx-buffer.lisp
;(in-package #:startx-buffer)
;;; "startx-buffer" goes here. Hacks and glory await!
;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y COMMON LISP
;;; FEB. 2015

(ql:quickload "usocket")
(ql:quickload "osc")

;;; udp setuo
;;(defparameter *startx-ip* "192.168.219.14")
(defparameter *startx-ip* "startx.local") 
(defparameter *startx-osc-port* 9000)
(defparameter *startx-socket* nil)

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

(defun mach-socket ()
  (defparameter  *startx-socket* (usocket:socket-connect
                                  *startx-ip* *startx-osc-port*
                                  :protocol :datagram
                                  :element-type '(unsigned-byte 8))))
(defun kill-socket ()
  (usocket:socket-close *startx-socket*))

(defun udp-server (port buffer)
  (let* ((socket (usocket:socket-connect nil nil
                                         :protocol :datagram
                                         :element-type '(unsigned-byte 8)
                                         :local-host *startx-ip*
                                         :local-port port)))
    (unwind-protect
         (multiple-value-bind (buffer size client receive-port)
             (usocket:socket-receive socket buffer 8)
           (format t "~A~%" buffer)
           (usocket:socket-send socket (reverse buffer) size
                                :port receive-port
                                :host client))
      (usocket:socket-close socket))))

;; (defun udp-client-oneshot (ip port buffer)
;;   (let* ((socket (usocket:socket-connect ip port :protocol :datagram
;;                                         :element-type '(unsigned-byte 8)))
;;          ;(buffer-0 (make-sequence  '(vector (unsigned-byte 8)) 512))
;;          (length (array-dimension buffer 0)))
;;     (unwind-protect
;;          (progn
;;            (format t "sending...~%")
;;            (usocket:socket-send socket buffer length)
;;            ;;recive spaeter
;;            ;;(usocket:socket-receive socket buffer ?)
;;            ;;(format t "~A~%" buffer)
;;            )
;;       (usocket:socket-close socket))
;;     t))

(defmacro 2startx (path &rest value)
  `(let* ((buffer (osc:encode-message ,path ,@value))
          (length (array-dimension buffer 0)))
     (usocket:socket-send *startx-socket* buffer length)))
                                   
;; (defmacro 2startx (path &rest value)
;;   `(udp-client ,*startx-ip* ,*startx-osc-port* 
;;                (osc:encode-message ,path ,@value)))
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

;; (x- "111111        11")
;; (sag+ "0 3") ;nil->no change machen
;; (sag- "0 3")

;;(satz-teil "1 3 5 7 9") => blanko dazu no signal senden


(defun maxi-lst (lst)
  "as list, one-shot maxi kontrol"
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (maxi i (car cur))))

(defun maxi (pos &optional max-spd)
  (cond ((null max-spd) nil)
        ((listp pos)
         (dolist (ele pos)
           (maxi ele max-spd)))
        ((zerop pos) (alle maxi max-spd))
        ((not (null pos))(2startx (each/ pos "max") max-spd))
        (t nil)))

;; (maxi '(11 12 nil 14 15 16 17 17 nil 19 0 1 2 3 4 ))
;; (maxi 0 100)
;; (maxi 1 99)

(defun aksel-lst (lst)
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (aksel i (car cur))))

(defun aksel (pos &optional accel-var)
  (cond ((null accel-var) nil)
        ((listp pos)
         (dolist (ele pos)
           (aksel ele accel-var)))
        ((zerop pos) (alle aksel accel-var))
        ((not (null pos))(2startx (each/ pos "accel") accel-var))
        (t nil)))

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

;; ;;; Btcusdsl
;; (ql:quickload :yason)
;; (ql:quickload :flexi-streams)
;; (ql:quickload :drakma)
;; (info "last_price" (yason:parse (FLEXI-STREAMS:octets-to-string (drakma:http-request url) :external-format :utf-8)))

;; (defun btcusd (key)
;;   "key as string,  z.B. mid, bid, ask, last_price, low, high, volume, timestamp  "
;;   (let ((result (info key (yason:parse (FLEXI-STREAMS:octets-to-string (drakma:http-request url) :external-format :utf-8)))))
;;     (format nil "~%~A" result)))

;; (defun foo (time-interval wieviel-mals)
;;   (loop for i from 1 to wieviel-mals do
;;        (s+ (btcusd "last_price"))
;;        (sleep time-interval))
;;   (s+ "         fertig"))


;; CMD
(defun startx ()
  (netz 1)
  (sleep 1)
  (stm 0 1)
  (sleep 1)
  (kali 0 1))

(defun agur ()
  (abal 0)
  (sleep 6)
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
(defun bla ()
  (loop for i from 1 to 5 do
       (sleep 0.5)
       (2startx "/gjeiotbla" i)))

(defun blabla ()
  (loop (sleep 1)
     (2startx "/blabla-222" 1)))

;; (defun bla ())
;; (loop (bla))

(defun demo ()
  (2startx "/FF" 5))

(defun spido (x-maxi x-aksel)
  (maxi 0 x-maxi)
  (aksel 0 x-aksel))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun haus ()  (s '(1 2) "e"))
(defun baum ()  (s '(3 4) "e"))
(defun bush ()  (s '(5) "e"))
(defun fenster ()  (s '(6) "e"))
(defun schreibmaschine ()  (s '(1) "f"))
(defun himmel ()  (s '(7) "e"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (mach-funcs-a "leb-um-zu-leben" "d-l" "spiral" "startx" "katze" "katze" "func" "func"
;;                  "hammock" "hammock" "nest" "tisch" "hasen" "katze" "lisp" "lisp")

;; ;; **TODO
;; ;; OSC RECEIVE
;; ;; defparameter

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
       (defun ,f1 () (s '(1) ,was))
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
              LEB D-L SPIRAL START-X
              KATZE1 KATZE2 FUNC1 FUNC2
              HAMMOCK1 HAMMOCK2 NEST TISCH
              HASEN KATZE3 LISP1 LISP2)
(mach-func-wo "a"
              '(5 6 14) KATZE)
(mach-func-wo "a"
              '(7 8) FUNC)
(mach-func-wo "a"
              '(9 10) HAMMOCK)
(mach-func-wo "a"
              '(15 16) LISP)
