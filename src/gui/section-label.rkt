#lang racket/gui

(require "../parameters.rkt")

(provide section-label%)
(define section-label%
  (class message%
    (super-new)
    
    (define/public
      (serialize)
      (send this get-label))))
