#lang racket/base

(provide edit-mode)
(define edit-mode (make-parameter #f))
(provide window-style)
(define window-style (make-parameter '()))

(when (or (equal? (system-type 'os)
                  'windows)
          (equal? (system-type 'os)
                  'macosx))
  (window-style '(float)))
