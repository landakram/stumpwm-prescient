(defpackage stumpwm-prescient
  (:use :cl :stumpwm))
(in-package :stumpwm-prescient)

(export '(refine-input
          remember-candidate))

(defvar *persist* nil)
(defvar *history* (make-hash-table :test 'equal))
(defvar *history-length* 100)
(defvar *frequency* (make-hash-table :test 'equal))
(defvar *frequency-decay* 0.997)
(defvar *frequency-threshold* 0.05)
(defvar *sort-by-length* t)

(defun sort-comparator (c1 c2)
  (let* ((p1 (gethash c1 *history* *history-length*))
         (p2 (gethash c2 *history* *history-length*)))
    (or (< p1 p2)
        (and (eq p1 p2)
             (let* ((f1 (gethash c1 *frequency* 0))
                    (f2 (gethash c2 *frequency* 0)))
               (or (> f1 f2)
                   (and (eq f1 f2)
                        *sort-by-length*
                        (< (length c1)
                           (length c2)))))))))

(defun sort-candidates (candidates)
  (sort candidates 'sort-comparator))

(defun refine-input (str candidates)
  (let ((candidates (input-refine-regexp str candidates)))
    (sort-candidates candidates)))

(defun remember-candidate (candidate)
  (let* ((candidate (string-trim '(#\Space #\Tab #\Newline) candidate))
         (this-pos (gethash candidate *history* *history-length*)))
    (maphash
     (lambda (other-candidate other-pos)
       (cond
         ((< other-pos this-pos)
          (setf (gethash other-candidate *history*) (1+ other-pos)))
         ((or (>= other-pos *history-length*)
              (and (= other-pos (1- *history-length*))
                   (= this-pos *history-length*)))
          (remhash other-candidate *history-length*))))
     *history*)

    (setf (gethash candidate *history*) 0)

    (setf (gethash candidate *frequency*) (1+ (gethash candidate *frequency* 0)))
    (maphash
     (lambda (cand old-freq)
       (let ((new-freq (* old-freq *frequency-decay*)))
         (if (< new-freq *frequency-threshold*)
             (remhash cand *frequency*)
             (setf (gethash cand *frequency*) new-freq))))
     *frequency*)))

(add-hook *input-candidate-selected-hook* 'remember-candidate) 
