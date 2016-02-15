;;; startx-buffer-buffer.el --- a physikal buffer, connecting with the machschine >STARTX< in Emacs -*- lexical-binding: t; -*

;; Copyright (C) 2015-2016 by dvnmk
;;
;; Author: dvnmk <divinomok@gmail.com>
;; URL: http://github.com/dvnmk/startx-buffer
;; Keywords: buffer, physical
;; Linzen: WDW (Wie Du Willst)
;; Version: minus-moebius

;; This file is NOT a part of GNU Emacs.

;;; License:

;;; Commentary:

;;; Code:

(defun tunnel ()
  (interactive)
  (start-process-shell-command "tunnel" "*tunnel-msg*"
   "sshpass -p startx ssh -fNL 4004:localhost:4004 startx@mut.dlinkddns.com")
  (switch-to-buffer "*tunnel-msg*"))

(defun vue-vlc ()
  (interactive)
  (call-process-shell-command
   "open -n -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_1.h264 --no-audio"
   nil 0))

(defun vue-vlc-hd ()
  (interactive)
  (call-process-shell-command
   "open -n -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_0.h264 --no-audio")
  nil 0)

(defun vue-vlc-audio ()
  (interactive)
  (call-process-shell-command
   "open -a vlc --args rtsp://mut.dlinkddns.com:554/ch0_3.h264"
   nil 0))

(defun vue-mpv ()
  (interactive)
  (call-process-shell-command
   "open -a mpv --args rtsp://mut.dlinkddns.com:554/ch0_1.h264 --no-audio --framedrop=vo --fs --osd-align-x=right --osd-align-y=top --osd-level=0"
   nil 0))

(defun vue-mpv-hd ()
  (interactive)
  (call-process-shell-command
   "open -a mpv --args rtsp://mut.dlinkddns.com:554/ch0_0.h264 --no-audio --framedrop=vo --fs --osd-align-x=right --osd-align-y=top --osd-level=0"
   nil 0))

(defun vue ()
  (interactive)
  (vue-mpv))

(defun vue-hd ()
  (interactive)
  (vue-mpv-hd))

;;; helper

(make-variable-buffer-local
 (defvar wo 1
   "Wo fuege ich die char zu?"))

(defun wo-looper (n)
  "Wo +n od. -n margin ist 1-16"
  (if (plusp n)
      (if (equal wo 16)
          (setq wo 1)
        (setq wo (+ wo n)))
    (if (equal wo 1)
        (setq wo 16)
      (setq wo (+ wo n 1)))))

(defun toggle-case  (string)
"aBcDe -> AbCdE"
  (do* ((i 0 (+ i 1))
        (len (length string))
        (res string))
      ((equal i len) res)
    (let ((ele (aref string i)))
      (if (< ele 91) ; ascii A 65 ~ Z 90, a 97 ~ z 122
          (aset string i (downcase ele))
        (aset string i (upcase ele))))))

(defun toggle-case-ascii (n)
  "N is ascii code, a->A, A->a, sonst gleich."
  (cond ((< 96 n 123) (- n 32))
        ((< 64 n 91) (+ n 32))
        (t n)))

;;; socket

(defun mach-socket ()
  (interactive)
  (slime-eval `(swank::pprint-eval "(mach-socket)")))

(defun kill-socket ()
  (interactive)
  (slime-eval `(swank::pprint-eval "(kill-socket)")))


;; schreibung
(defun sag (pos ∂)
  "pos : number o. list / ∂ : char? o. ascii dec."
  (interactive)
  (let* ((pos-res (if (numberp pos)(number-to-string pos)
                    (format "'%s" pos)))
         (cmd-gen (concatenate 'string
                               "(s" " "
                               pos-res " "
                               (number-to-string ∂)
                               ")")))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))


(defun 2slime (str)
  (cadr (slime-eval `(swank:eval-and-grab-output ,str))))

;; 
(defmacro use-defun (fun-name)
  "Use the same name fun from CL"
  `(defun ,fun-name (&optional arg1 arg2)
     (if arg1
	 (if arg2
	     (2slime (format "(%s %s %s)" ',fun-name arg1 arg2))
	   (2slime (format "(%s \"%s\")" ',fun-name arg1)))
       (2slime (format "(%s)" ',fun-name)))))

(defmacro use-defun-interactive (fun-name)
  "Use the same name fun from CL"
  `(defun ,fun-name (&optional arg1 arg2)
     (interactive)
     (if arg1
	   (if arg2
	       (2slime (format "(%s %s %s)" ',fun-name arg1 arg2))
	     (2slime (format "(%s \"%s\")" ',fun-name arg1)))
	 (2slime (format "(%s)" ',fun-name)))))

;; (defun x (∂)
;;   (interactive)
;;   (let ((cmd-gen (format "(x \"%s\")" ∂)))
;;     (slime-eval `(swank::pprint-eval ,cmd-gen))))

;; (defun x+ (∂)
;;   (interactive)
;;   (let ((cmd-gen (format "(x+ \"%s\")" ∂)))
;;     (slime-eval `(swank::pprint-eval ,cmd-gen))))

;; (defun x- (∂)
;;   (interactive)
;;   (let ((cmd-gen (format "(x- \"%s\")" ∂)))
;;     (slime-eval `(swank::pprint-eval ,cmd-gen))))

(use-defun x+)
(use-defun x-)
(use-defun x)

;;; global kontrol/ start y end
(use-defun-interactive startx)
(use-defun-interactive agur)

;;; kontrol
(use-defun stm)
(use-defun netz)

;; (defun kali (&optional posx tglx)
;;   (interactive)
;;   (let* ((pos (or posx 0))
;; 	 (tgl (or tglx 1))
;; 	(cmd-gen (format "(kali %d %d)" pos tgl)))
;;     (slime-eval `(swank::pprint-eval ,cmd-gen))))

(use-defun-interactive kali)

(use-defun-interactive abal)

(use-defun kredit)

(defun aksel (pos &optional accel-var)
  (interactive)
  (let ((cmd-gen (cond ((listp pos)(format "(aksel '%s)" pos))
                       (t (format "(aksel %d %d)" pos accel-var)))))
    (2slime cmd-gen)))

(defun maxi (pos &optional max-spd)
  (interactive)
  (let ((cmd-gen (cond ((listp pos)(format "(maxi '%s)" pos))
                       (t (format "(maxi %d %d)" pos max-spd)))))
    (2slime cmd-gen)))


(defun xm (arg)
"xmark, x-current-line-or-region
if ARG not null, case sensitive"
  (interactive "P")
  (save-excursion
    (let* ((beg (if (use-region-p)
		    (region-beginning)
		  (line-beginning-position)))
	   (end (if (use-region-p)
		    (region-end)
		  (line-end-position)))
	   (regioned-str (buffer-substring-no-properties beg end))
	   (replaced-str (replace-regexp-in-string "\"" "\\\\\"" regioned-str))
	   (downcased-str (if arg
			      replaced-str
			    (downcase replaced-str))))
      (x  downcased-str))))

(defun xr ()
  "xraw, x-current-line-or-region,  but case sensitive, w/o case-toggle"
  (interactive)
  (xm 't))

(defun hijack ()
  (interactive)
  (self-insert-command 1)
  (wo-looper 1)
  (message "DEBUG// loc:%d asci:%s" wo (char-before))
  (sag wo (toggle-case-ascii (char-before))))

(defun hijack-del ()
  (interactive)
  (delete-char -1)
  (sag wo 32)
  (wo-looper -2)
  (message " loc:%d hijack-del" wo)
  )
            
(defun hijack-spc ()
  (interactive)
  (self-insert-command 1)
  (wo-looper 1)
  (message " loc:%d hijack-spc" wo)
  (sag wo 32))

;;;###autoload
(define-minor-mode startx-buffer-mode
  "connecting with the machschine >STARTX< in Emacs"
  :lighter " (X)"
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "<f3>") #'xm)
	    (define-key map (kbd "<M-f3>") #'xr)

            (define-key map (kbd "1") 'hijack)
            (define-key map (kbd "2") 'hijack)
            (define-key map (kbd "3") 'hijack)
            (define-key map (kbd "4") 'hijack)
            (define-key map (kbd "5") 'hijack)
            (define-key map (kbd "6") 'hijack)
            (define-key map (kbd "7") 'hijack)
            (define-key map (kbd "8") 'hijack)
            (define-key map (kbd "9") 'hijack)
            (define-key map (kbd "0") 'hijack)
            
            (define-key map (kbd "a") 'hijack)
            (define-key map (kbd "b") 'hijack)
            (define-key map (kbd "c") 'hijack)
            (define-key map (kbd "d") 'hijack)
            (define-key map (kbd "e") 'hijack)
            (define-key map (kbd "f") 'hijack)
            (define-key map (kbd "g") 'hijack)
            (define-key map (kbd "h") 'hijack)
            (define-key map (kbd "i") 'hijack)
            (define-key map (kbd "j") 'hijack)
            (define-key map (kbd "k") 'hijack)
            (define-key map (kbd "l") 'hijack)
            (define-key map (kbd "m") 'hijack)
            (define-key map (kbd "n") 'hijack)
            (define-key map (kbd "o") 'hijack)
            (define-key map (kbd "p") 'hijack)
            (define-key map (kbd "q") 'hijack)
            (define-key map (kbd "r") 'hijack)
            (define-key map (kbd "s") 'hijack)
            (define-key map (kbd "t") 'hijack)
            (define-key map (kbd "u") 'hijack)
            (define-key map (kbd "v") 'hijack)
            (define-key map (kbd "w") 'hijack)
            (define-key map (kbd "x") 'hijack)
            (define-key map (kbd "y") 'hijack)
            (define-key map (kbd "z") 'hijack)
            
            (define-key map (kbd "A") 'hijack)
            (define-key map (kbd "B") 'hijack)
            (define-key map (kbd "C") 'hijack)
            (define-key map (kbd "D") 'hijack)
            (define-key map (kbd "E") 'hijack)
            (define-key map (kbd "F") 'hijack)
            (define-key map (kbd "G") 'hijack)
            (define-key map (kbd "H") 'hijack)
            (define-key map (kbd "I") 'hijack)
            (define-key map (kbd "J") 'hijack)
            (define-key map (kbd "K") 'hijack)
            (define-key map (kbd "L") 'hijack)
            (define-key map (kbd "M") 'hijack)
            (define-key map (kbd "N") 'hijack)
            (define-key map (kbd "O") 'hijack)
            (define-key map (kbd "P") 'hijack)
            (define-key map (kbd "Q") 'hijack)
            (define-key map (kbd "R") 'hijack)
            (define-key map (kbd "S") 'hijack)
            (define-key map (kbd "T") 'hijack)
            (define-key map (kbd "U") 'hijack)
            (define-key map (kbd "V") 'hijack)
            (define-key map (kbd "W") 'hijack)
            (define-key map (kbd "X") 'hijack)
            (define-key map (kbd "Y") 'hijack)
            (define-key map (kbd "Z") 'hijack)
            
            (define-key map (kbd "`") 'hijack)
            (define-key map (kbd "~") 'hijack)
            (define-key map (kbd "!") 'hijack)
            (define-key map (kbd "@") 'hijack)
            (define-key map (kbd "#") 'hijack)
            (define-key map (kbd "$") 'hijack)
            (define-key map (kbd "%") 'hijack)
            (define-key map (kbd "^") 'hijack)
            (define-key map (kbd "&") 'hijack)
            (define-key map (kbd "*") 'hijack)
            (define-key map (kbd "(") 'hijack)
            (define-key map (kbd ")") 'hijack)
            (define-key map (kbd "-") 'hijack)
            (define-key map (kbd "_") 'hijack)
            (define-key map (kbd "=") 'hijack)
            (define-key map (kbd "+") 'hijack)
            (define-key map (kbd "[") 'hijack)
            (define-key map (kbd "\{") 'hijack) ;
            (define-key map (kbd "]") 'hijack)
            (define-key map (kbd "\}") 'hijack) ;          
            (define-key map (kbd "\|") 'hijack) ;
            (define-key map (kbd "\\") 'hijack) ;
            (define-key map (kbd ";") 'hijack)
            (define-key map (kbd ":") 'hijack)
            (define-key map (kbd "'") 'hijack)
            (define-key map (kbd "\"") 'hijack)
            (define-key map (kbd ",") 'hijack)
            (define-key map (kbd "<") 'hijack)
            (define-key map (kbd ".") 'hijack)
            (define-key map (kbd ">") 'hijack)
            (define-key map (kbd "/") 'hijack)
            (define-key map (kbd "?") 'hijack)
            
            (define-key map (kbd "SPC") 'hijack-spc)
            (define-key map (kbd "DEL") 'hijack-del)
            
            (define-key map (kbd "C-a")
              (lambda()(interactive)
                (beginning-of-visual-line)
                (setq wo 0)
                (message "DEBUG// C-a, anfang")))
            
            (define-key map (kbd "C-k")
              (lambda()(interactive)
                (kill-line)
                (setq wo 0)
                (message "DEBUG// C-k, kill-line")))
            
            (define-key map (kbd "<left>")
              (lambda()(interactive)
                (backward-char)
                (wo-looper -2)
                (message "DEBUG// <-")))

            (define-key map (kbd "C-b")
              (lambda()(interactive)
                (backward-char)
                (wo-looper -2)
                (message "DEBUG// <-")))

            (define-key map (kbd "C-k")
              (lambda()(interactive)
                (kill-visual-line)
                (sag (number-sequence (+ 1 wo) 16) 32)
                (message "DEBUG// C-k")))

            map)
  )

(provide 'startx-buffer-mode)

;;; startx-buffer-mode.el ends here
