;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright (C) 2014  Wojciech Siewierski                               ;;
;;                                                                       ;;
;; This program is free software: you can redistribute it and/or modify  ;;
;; it under the terms of the GNU General Public License as published by  ;;
;; the Free Software Foundation, either version 3 of the License, or     ;;
;; (at your option) any later version.                                   ;;
;;                                                                       ;;
;; This program is distributed in the hope that it will be useful,       ;;
;; but WITHOUT ANY WARRANTY; without even the implied warranty of        ;;
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ;;
;; GNU General Public License for more details.                          ;;
;;                                                                       ;;
;; You should have received a copy of the GNU General Public License     ;;
;; along with this program.  If not, see <http://www.gnu.org/licenses/>. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar *output*)
(defvar *indent*)

(defun format-tag (symbol &optional arg)
  (cond
    ((equal arg 'begin)
     (format nil "~{~a~}<~(~a~)" *indent* symbol))
    ((equal arg 'end)
     (format nil "~{~a~}<~(/~a~)>~%" *indent* symbol))
    (t
     (format nil "~{~a~}~a~%" *indent* symbol))))

(defun sexp-to-xml--inside-tag (sexp)
  (if sexp
      (if (listp (car sexp))
          (progn
            (sexp-to-xml--new-tag (car sexp))
            (sexp-to-xml--inside-tag (cdr sexp)))
          (progn
            (push (format-tag
                   (string (car sexp)))
                  *output*)
            (sexp-to-xml--inside-tag (cdr sexp))))))

(defun sexp-to-xml--attrs (plist)
  (when plist
    (push (format nil " ~(~a~)=~s"
                  (car plist)
                  (cadr plist))
          *output*)
    (sexp-to-xml--attrs (cddr plist))))

(defun sexp-to-xml--new-tag (sexp)
  (if (listp (car sexp))
      (progn
        (push (format-tag (caar sexp) 'begin)
              *output*)
        (sexp-to-xml--attrs (cdar sexp)))
      (push (format-tag (car sexp) 'begin)
            *output*))
  (unless (cdr sexp)
    (push (format nil " /")
          *output*))
  (push (format nil ">~%")
        *output*)
  (let ((*indent* (cons "  " *indent*)))
    (sexp-to-xml--inside-tag (cdr sexp)))
  (when (cdr sexp)
    (push (format-tag (if (listp (car sexp))
                          (caar sexp)
                          (car sexp))
                      'end)
          *output*)))

(defun sexp-to-xml-unquoted (&rest sexps)
  (apply #'concatenate 'string
         (apply #'concatenate 'list
                         (loop for sexp in sexps collecting
                              (let ((*output* nil)
                                    (*indent* nil))
                                (reverse (sexp-to-xml--new-tag  sexp)))))))

(defmacro sexp-to-xml (&rest sexps)
  `(format *standard-output* "~a"
           (sexp-to-xml-unquoted ,@(loop for sexp in sexps collecting
                                        `(quote ,sexp)))))
(defun file-get-contents (filename)
  (with-open-file (stream filename)
    (let ((contents (make-string (file-length stream))))
      (read-sequence contents stream)
      contents)))

(defun file-get-lines (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun list-to-string (lst)
    (format nil "~{~A~}" lst))


(defun test1()
  (let((input (file-get-contents "sample2.sexp")))
    (format t (sexp-to-xml-unquoted (read-from-string "(head (title \"my-site\"))")))
  )
)

(defun test2()
  (let((input (file-get-lines "sample2.sexp")))
    (loop for sexp in input do (print (write-to-string sexp)))
  )
)

(defun test3()
  (let((input (file-get-lines "sample2.sexp")))
    (format t (list-to-string input))
  )
)


(defun :str->lst (str / i lst)
  (repeat (setq i (strlen str))
    (setq lst (cons (substr str (1+ (setq i (1- i))) 1) lst)))) 

(defun print-elements-recursively (list)
 (when list                            ; do-again-test
       (print (car list))              ; body
       (print-elements-recursively     ; recursive call
        (cdr list))))                  ; next-step-expression


(defun tokenize( str )(read-from-string (concatenate 'string "(" str
")")))


(defun test4()
  (let((input (file-get-contents "sample2.sexp")))
    (print-elements-recursively (tokenize input) )
  )
)


(defun test5()
  (let((input (file-get-contents "sample2.sexp")))
    (print (sexp-to-xml-unquoted (tokenize input)))
  )
)

(defun test6()
  (let((input (file-get-contents "sample2.sexp")))
    (loop for sexp in  (tokenize input) do (
      with-input-from-string (s (write-to-string sexp) ) 
        (print ( sexp-to-xml-unquoted (read s)) )
      
      )
    )
  )
)


(defun test7()
  (let((input (file-get-contents "sample2.sexp")))
    (loop for sexp in  (tokenize input) do (
      print sexp

      )
    )
  )
)

(defun test8()
  (let((input (file-get-contents "sample2.sexp")))
    (format t (sexp-to-xml-unquoted (read-from-string input)))
  )
)
