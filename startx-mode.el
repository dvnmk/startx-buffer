;;; network-status.el -- Display network status in mode line.

;; Copyright (C) 2015 by dvnmk

;; Author: divinomok <divinomko@gmail.com>
;; URL: http://github.com/dvnmk/startx-buffer
;; Keywords: tools, network, convenience
;; Version: xx

;; This file is NOT a part of GNU Emacs.

;; network-status is free software distributed under the terms of the
;; GNU General Public License, version 3. For details, see the file
;; COPYING.


;;; Code:


;;; helper

(make-variable-buffer-local
 (defvar wo 1
   "Wo fuege ich die char zu?"))

(defun wo-looper (n)
  "wo +n od. -n margin ist 1-16"
  (if (plusp n)
      (if (equal wo 16)
          (setq wo 1)
        (setq wo (+ wo n)))
    (if (equal wo 1)
        (setq wo 16)
      (setq wo (+ wo n 1)))))

(defun toggle-case  (string)
  ""aBcDe" -> "AbCdE""
  (do* ((i 0 (+ i 1))
        (len (length string))
        (res string))
      ((equal i len) res)
    (let ((ele (aref string i)))
      (if (< ele 91) ; ascii A 65 ~ Z 90, a 97 ~ z 122
          (aset string i (downcase ele))
        (aset string i (upcase ele))))))

(defun toggle-case-ascii (n)
  "input is ascii code, a->A, A->a, sonst gleich"
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

;;; schreibung
(defun sag (pos x)
  "pos : number o. list / x : char o. ascii dec."
  (interactive)
  (let* ((pos-res (if (numberp pos)(number-to-string pos)
                    (format "'%s" pos)))
         (cmd-gen (concatenate 'string
                               "(sag" " "
                               pos-res " "
                               (number-to-string x)
                               ")")))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun sag+ (string)
  (interactive)
  (let ((cmd-gen (format "(sag+ \"%s\")" string)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun sag> (string)
  (interactive)
  (let ((cmd-gen (format "(sag> \"%s\")" string)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun sag- (string)
  (interactive)
  (let ((cmd-gen (format "(sag- \"%s\")" string)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

;;; kontrol

(defun stm (pos tgl)
  (interactive)
  (let ((cmd-gen (format "(stm %d %d)" pos tgl)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun netz (tgl)
  (interactive)
  (let ((cmd-gen (format "(netz %d)" tgl)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun kali (pos tgl)
  (interactive)
  (let ((cmd-gen (format "(kali %d %d)" pos tgl)))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun aksel (pos &optional accel-var)
  (interactive)
  (let ((cmd-gen (cond ((listp pos)(format "(aksel '%s)" pos))
                       (t (format "(aksel %d %d)" pos accel-var)))))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun maxi (pos &optional max-spd)
  (interactive)
  (let ((cmd-gen (cond ((listp pos)(format "(maxi '%s)" pos))
                       (t (format "(maxi %d %d)" pos max-spd)))))
    (slime-eval `(swank::pprint-eval ,cmd-gen))))

(defun abal (pos)
  (interactive)
  (sag pos 128))
;;;

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

;;(this-command-keys)

(define-minor-mode startx-mode
  "connecting with the machschine >STARTX< in Emacs"
  :lighter " >STARTX<"
  :keymap (let ((map (make-sparse-keymap)))
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
  (message ">STARTX<-mode gestartet."))

(provide 'startx-mode)

;;;; aus .emacs

;; (2cl "(g 043860-000)")
;; send command 2cl y get the output
(defun 2cl-s (command)
  "convert a result from the slime lisp's repl into the emacs lisp toplevel. return :output as STREAM"
  (read (slime-eval `(swank::pprint-eval ,command))))

(defun 2cl (command)
  "convert a result from the slime lisp's repl into the emacs lisp toplevel. return :output as MESSAGE"
  (message (slime-eval `(swank::pprint-eval ,command))))
