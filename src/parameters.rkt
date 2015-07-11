#lang racket/base

(provide edit-mode)
(define edit-mode (make-parameter #f))
(provide window-style)
(define window-style (make-parameter '()))

(case (system-type 'os)
  [(windows macosx)
   (window-style '(float))])

