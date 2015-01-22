;;; DVNMK 2015 (c)
;;;
;;; WIRING >>STARTX<< Y EMACS LISP

;; macro fuer startx-buffer
(fset 'endo-eval
   "\C-e\C-x\C-e")
(global-set-key (kbd "<s-return>") 'endo-eval)
(global-set-key (kbd "<C-return>") 'endo-eval)

(require 'osc)

(setq osc-server-ip "192.168.219.14")
(setq osc-server-port "9000")

(setq my-client (osc-make-client osc-server-ip osc-server-port))

(defun senden-vec (osc-path vec)
  (osc-send-message my-client osc-path
                    (elt vec 0) (elt vec 1) (elt vec 2) (elt vec 3)
                    (elt vec 4) (elt vec 5) (elt vec 6) (elt vec 7)
                    (elt vec 8) (elt vec 9) (elt vec 10) (elt vec 11)
                    (elt vec 12) (elt vec 13) (elt vec 14) (elt vec 15)))

(defun string-zu-vector (string)
  (do* ((vec (make-vector 16 32))
        (lst (string-to-list string) (cdr lst))
        (leng (length lst))
        (i 0 (+ i 1)))
      ((or (equal i 16)
           (null lst)) vec)
    (aset vec i (car lst))))

(defun x (string)
  (let ((conv-vector (string-zu-vector (toggle-case string))))
    (senden-vec "/satz/value" conv-vector)
    t))

(defun netz (num)
  (osc-send-message my-client "/netz" num))
(defun stm (num)
  (osc-send-message my-client "/stm" num))
(defun nullp ()
  (osc-send-message my-client "/null" 1))
(defun parken ()
  (osc-send-message my-client "/satz/value" 128 128 128 128 128 128 128 128
                    128 128 128 128 128 128 128 128))
(defun blanko ()
  (osc-send-message my-client "/zeug/blk" 1))

(defun accel (spd)
  (osc-send-message my-client "/zeug/spido/accel" spd))
(defun maxi  (spd)
  (osc-send-message my-client "/zeug/spido/maxi" spd))
(defun norm (spd)
  (osc-send-message my-client "/zeug/spido/norm" spd))
(defun rst ()
  (accel 2500)
  (maxi 5000)
  (norm 1500)
  )

(defun startx ()
  (progn  (netz 1)
          (sleep-for 1)
          (stm 1)
          (sleep-for 0.5)
          (nullp))
  t)
(defun killx ()
  (progn  (accel 0)
          (maxi 600)
          (parken)
          (sleep-for 7)
          (stm 0)
          (sleep-for 2)
          (netz 0))
  t)

(transient-mark-mode 1)

(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun toggle-case-interactive ()
  (interactive)
  (when (region-active-p)
    (let ((i 0)
      (return-string "")
      (input (buffer-substring-no-properties (region-beginning) (region-end))))
      (while (< i (- (region-end) (region-beginning)))
    (let ((current-char (substring input i (+ i 1))))
      (if (string= (substring input i (+ i 1)) (downcase (substring input i (+ i 1))))
          (setq return-string
            (concat return-string (upcase (substring input i (+ i 1)))))
        (setq return-string
          (concat return-string (downcase (substring input i (+ i 1)))))))
    (setq i (+ i 1)))
      (delete-region (region-beginning) (region-end))
      (insert return-string))))

(defun toggle-case  (string)
  (do* ((i 0 (+ i 1))
        (len (length string))
        (res string))
      ((equal i len) res)
    (let ((ele (aref string i)))
      (if (< ele 91) ; ascii A 65 ~ Z 90, a 97 ~ z 122
          (aset string i (downcase ele))
        (aset string i (upcase ele))))))

(defun sag ()
  (interactive)
  (unless (use-region-p)
    (error "need an active region"))
  (let* ((beg (region-beginning))
         (end (region-end)))
    (funcall #'x (buffer-substring-no-properties beg end))))

(defun xx-vor ()
  "print current word."
  (interactive)
  (let (p1 p2)
    (save-excursion
      (setq p1 (point))
      (setq p2 (- p1 16))
      (x (buffer-substring-no-properties p2 p1)))
    (move-overlay uber p1 p2)
    (backward-char 16)))

(defun xx-nach ()
  "print current word."
  (interactive)
  (let (p1 p2)
    (save-excursion
      (setq p1 (point))
      (setq p2 (+ p1 16))
      (x (buffer-substring-no-properties p2 p1)))
    (move-overlay uber p1 p2)
    (forward-char 16)))

(setq uber (make-overlay (point) (- (point) 16) nil nil nil))
(overlay-put uber 'face 'lazy-highlight)

(defun xx-uber-nach ()
  (setq uber (make-overlay (point) (- (point) 16) nil nil nil))
  (overlay-put uber 'face 'lazy-highlight)
  (interactive)
  (move-overlay uber (point) (+ (point) 16)))


;; FROM HIER, PLAYGROUND. SO, DO NOT EVAL-BUFFER!

(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)                 ; permit invocation in minibuffer
  (format-time-string "%D%I:%M:%S %p"))
(defun today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
   (format-time-string " %e.%b.%a.%Y"))

(defun x-intro-seq (zwsn)
  (rst)
  (x "wuala   schach")
  (sleep-for zwsn)
  (accel 0)
  (maxi 900)
  (x ";hallo, #vvvolks")
  (sleep-for zwsn)

  (x "this is,........")
  (sleep-for zwsn)
  (x "      a *buffer*")
  (sleep-for zwsn)
  (x "physikal*buffer*")
  (sleep-for zwsn)
  (x "      a maschine")
  (sleep-for zwsn)
  (x " -live-  coding")
  (sleep-for zwsn)
  (x " -live- *buffer*")
  (sleep-for zwsn)
  (x " -live- catze")
  (sleep-for zwsn)
  (accel 500)
  (x " -live- catze CD")
  (sleep-for (+ zwsn 2))
  (accel 2000)
  (x " startx-buffer ")
  (sleep-for zwsn)
  (x " by     dvnmk")
  (sleep-for zwsn)
  (x "    2015dvnmk")
  (sleep-for zwsn)
  )

;; cast a cold eye / on life, on death / horseman, pass by.
;; WB Yeats
(x "cast a  cold eye")
(x "on life,on death")
(x "horsemanpass by.")

;; CATZE
(accel 0)
(maxi 300)
(x "(car CD)=>C")
(x "(cadr CD) => D")
(x "(cat CD)=> ?")
(x "(cat CD)=>  CD ")
(x "(cat CD)=> CCDD")
(accel 500)
(maxi 5000)
(norm 1500)
(parken)

;; ** DONE alle zu string.
;; (x "peiughet")
;; (x "()#xjiojiojiojoijiojjoij")

(defun zu-string (alle)
  (cond ((stringp alle) alle)
        ((numberp alle) (number-to-string alle))
        (t t)))

(defun x (etwas)
  (zu-x (zu-string etwas)))
