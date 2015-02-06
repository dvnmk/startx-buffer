;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y COMMON LISP
;;; FEB. 2015

(ql:quickload "usocket")
(ql:quickload "osc")

;;; udp setuo
;;(defparameter *startx-ip* "192.168.219.14")
(defparameter *startx-ip* "192.168.219.14")
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

;; (defun udp-server (port buffer)
;;   (let* ((socket (usocket:socket-connect nil nil
;;                                          :protocol :datagram
;;                                          :element-type '(unsigned-byte 8)
;;                                          :local-host *startx-ip*
;;                                          :local-port port)))
;;     (unwind-protect
;;          (multiple-value-bind (buffer size client receive-port)
;;              (usocket:socket-receive socket buffer 8)
;;            (format t "~A~%" buffer)
;;            (usocket:socket-send socket (reverse buffer) size
;;                                 :port receive-port
;;                                 :host client))
;;       (usocket:socket-close socket))))

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

(defun sag (pos &optional x)
  "pos kann nummer 0~16(0:alle), list sein"
  (let ((res (cond ((numberp x) x)
                   ((null x) nil)
                   (t (char-code x)))))
    (cond ((listp pos)
           (dolist (ele pos)
             (2startx (each/ ele "dec") res)))
          ((zerop pos) (2startx "/alle/dec" res ))
          ((numberp pos) (2startx (each/ pos "dec") res))
          (t 'k.A.))))

(defun sag> (string)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element 32))
        (lst (coerce (toggle-case string) 'list))
        (asc (mapcar #'char-code lst)))
    (replace res asc)
    (2startx "/alle/satz"
             (nth 0  res) (nth 1 res) (nth 2 res) (nth 3 res)
             (nth 4  res) (nth 5 res) (nth 6 res) (nth 7 res)
             (nth 8  res) (nth 9 res) (nth 10 res) (nth 11 res)
             (nth 12 res) (nth 13 res) (nth 14 res) (nth 15 res))))

(defun sag+ (string)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element nil))
         (lst (coerce (toggle-case string) 'list))
         (res (sublis '((#\  . NIL)) (replace res lst))))
    (progn
      (sag 1 (nth 0 res)) (sag 2 (nth 1 res)) (sag 3 (nth 2 res)) (sag 4 (nth 3 res))
      (sag 5 (nth 4 res)) (sag 6 (nth 5 res)) (sag 7 (nth 6 res)) (sag 8 (nth 7 res))
      (sag 9 (nth 8 res)) (sag 10 (nth 9 res)) (sag 11 (nth 10 res)) (sag 12 (nth 11 res))
      (sag 13 (nth 12 res)) (sag 14 (nth 13 res)) (sag 15 (nth 14 res)) (sag 16 (nth 15 res))
      )))

(defmacro sag- (string)
  "nur input existing each to change"
  (let* ((lst (coerce (toggle-case string) 'list))
         (asc (mapcar #'char-code lst))
         (forms (mapcar (lambda (x) `,x) asc)))
    `(2startx "/alle/satz" ,@forms)))

;; (sag> "111111        11")
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
  (cond ((listp pos) (maxi-lst pos))
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
  (cond ((listp pos) (aksel-lst pos))
        ((zerop pos) (alle aksel accel-var))
        ((not (null pos))(2startx (each/ pos "accel") accel-var))
        (t nil)))

(defun stm (pos tgl)
  (cond ((zerop pos) (alle stm tgl))
        ((not (null pos))(2startx (each/ pos "stm") tgl))
        (t nil)))

(defun netz (tgl)
  (alle netz tgl))

(defun kali (pos tgl)
  (cond ((zerop pos) (alle null tgl))
        ((not (null pos))(2startx (each/ pos "null") tgl))
        (t nil)))

(defun abal (pos)
  (sag pos 128))
