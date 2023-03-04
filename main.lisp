(defstruct stack
  (data '()))

(defun push (stack value)
  (push value (stack-data stack)))

(defun pop (stack)
  (pop (stack-data stack)))

(defun add (stack)
  (let ((a (pop stack))
        (b (pop stack)))
    (push stack (+ a b))))

(defun subtract (stack)
  (let ((a (pop stack))
        (b (pop stack)))
    (push stack (- b a))))

(defun multiply (stack)
  (let ((a (pop stack))
        (b (pop stack)))
    (push stack (* a b))))

(defun divide (stack)
  (let ((a (pop stack))
        (b (pop stack)))
    (push stack (/ b a))))

(defun sin (stack)
  (let ((a (pop stack)))
    (push stack (sin a))))

(defun cos (stack)
  (let ((a (pop stack)))
    (push stack (cos a))))

(defun tan (stack)
  (let ((a (pop stack)))
    (push stack (tan a))))

(defun log (stack)
  (let ((a (pop stack)))
    (push stack (log a))))

(defun exp (stack)
  (let ((a (pop stack)))
    (push stack (exp a))))

(defun rpn (expression)
  (let ((stack (make-stack)))
    (dolist (token expression)
      (cond ((numberp token)
             (push stack token))
            ((eq token '+)
             (add stack))
            ((eq token '-)
             (subtract stack))
            ((eq token '*)
             (multiply stack))
            ((eq token '/')
             (divide stack))
            ((eq token 'sin)
             (sin stack))
            ((eq token 'cos)
             (cos stack))
            ((eq token 'tan)
             (tan stack))
            ((eq token 'log)
             (log stack))
            ((eq token 'exp)
             (exp stack))))
    (pop stack)))

(defun tokenize (expression)
  (let ((tokens '())
        (buffer '()))
    (labels ((flush-buffer ()
               (when buffer
                 (push (coerce buffer 'string) tokens)
                 (setf buffer '()))))
      (dolist (char expression)
        (cond ((member char '(#\space #\tab #\return #\newline))
               (flush-buffer))
              ((member char '(#\+ #\- #\* #\/))
               (flush-buffer)
               (push char tokens))
              ((member char '(#\s #\i #\n))
               (setf buffer (append buffer '(#\s #\i #\n))))
              ((member char '(#\c #\o #\s))
               (setf buffer (append buffer '(#\c #\o #\s))))
              ((member char '(#\t #\a #\n))
               (setf buffer (append buffer '(#\t #\a #\n))))
              ((char>= char #\0)
               (setf buffer (append buffer (list char))))
              (t (error "Invalid character %s" char)))
        )
      )
      (flush-buffer)
      (let ((result (eval (parse-tokens tokens))))
        (format t "~A~%" result)
        )
      )
  )
