;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y COMMON LISP

(ql:quickload "usocket")
(ql:quickload "osc")

;;; udp setuo
(defparameter *startx-ip* "127.0.0.1")
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

(defmacro 2startx (parh &rest value)
  `(let* ((buffer (osc:encode-message ,parh ,@value))
          (length (array-dimension buffer 0)))
     (usocket:socket-send *startx-socket* buffer length)))
                                   
;; (defmacro 2startx (path &rest value)
;;   `(udp-client ,*startx-ip* ,*startx-osc-port* 
;;                (osc:encode-message ,path ,@value)))

(defun satz (string)
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

(defun satz-blanko (string)
  "No sigma (each-char) ver. einfach alle overwrite, no input each -> blanko"
  (let* ((res (make-list 16 :initial-element nil))
         (lst (coerce (toggle-case string) 'list))
         (res (sublis '((#\  . NIL)) (replace res lst))))
    (progn
      (karak 1 (nth 0 res))
      (karak 2 (nth 1 res))
      (karak 3 (nth 2 res))
      (karak 4 (nth 3 res))
      (karak 5 (nth 4 res))
      (karak 6 (nth 5 res))
      (karak 7 (nth 6 res))
      (karak 8 (nth 7 res))
      (karak 9 (nth 8 res))
      (karak 10 (nth 9 res))
      (karak 11 (nth 10 res))
      (karak 12 (nth 11 res))
      (karak 13 (nth 12 res))
      (karak 14 (nth 13 res))
      (karak 15 (nth 14 res))
      (karak 16 (nth 15 res))
      )))

(defmacro satz-teil (string)
  "nur input existing each to change"
  (let* ((lst (coerce (toggle-case string) 'list))
         (asc (mapcar #'char-code lst))
         (forms (mapcar (lambda (x) `,x) asc)))
    `(2startx "/alle/satz" ,@forms)))

;;(satz-teil "1 3 5 7 9") => blanko dazu no signal senden

(defmacro each/ (x path)
  `(concatenate 'string "/each/" (write-to-string ,x) "/" ,path))

(defun karak (pos char)
  (if (not (null char))
      (let ((ascii (char-code char)))
        (2startx (each/ pos "char") ascii))))

(defun maxi (pos &optional max-spd)
  (cond ((listp pos) (maxi-lst pos))
        ((zerop pos) (alle maxi max-spd))
        ((not (null pos))(2startx (each/ pos "max") max-spd))))


(defun maxi-lst (lst)
  "as list, one-shot maxi kontrol"
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (maxi i (car cur))))

(defmacro aksel (pos accel-var)
  (if )
  (2startx (each/ pos "accel") accel-var))

(defun stm (pos stm)
  (2startx (each/ pos "stm") stm))

(defmacro alle (cmd &optional tgl)
  `(let ((path (concatenate 'string "/alle/"
                            (string ',cmd))))
     (2startx path ,tgl)))

;; (MAXI-FOO '(1 2 3 4 5 6 7 8
;;             9 10 11 12 13 14 15 16))

(defun aksel-foo (lst)
  (do ((cur lst (cdr cur))
       (i 1 (+ 1 i)))
      ((null cur) t)
    (aksel i (car cur))))


;; (aksel-foo (make-list 16 :initial-element 4))
;; (maxi-foo (make-list 16 :initial-element 4))


;; ;;; z.B. 
;; (alle nullp)
;; (alle accel 0)
;; (alle maxi 9999)
;; (alle go )
;; (alle stm 0)
;; (2startx "/alle/NETZ")
;; (stm 1 1)
;; (alle stm 0)
;; (karak 2 #\K)
;; (alle netz 0)
;; (alle stm)
;; (alle null 1)
;; (alle stm 0)
;; (alle blk 1)
;; (alle parken 1)
;; (alle null 1)
;; (alle aksel 1110)
;; (alle maxi 900)
;; (satz "abcdef\"\^")
;; (satz-teil "1            3 5")
;; (karak 2 #\j)
;; (maxi 1 1111) 
;; (aksel 1 2222)
;; (norm 1 3333)

;; (maxi 1 500)


