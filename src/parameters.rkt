#lang racket/base

(provide edit-mode)
(define edit-mode (make-parameter #f))
(provide float)
(define window-style (make-parameter '()))

(when (or (equal? (system-type 'os)
                  'windows)
          (equal? (system-type 'os)
                  'macosx))
  (style '(float)))
