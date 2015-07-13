#lang racket/gui

(require "../parameters.rkt")

(provide section-label%)
(define section-label%
  (class horizontal-panel%
    (super-new)

	(init-field label)

	(define label-message (new message%
							   [parent this]
							   [label label]))
    
    (define/public
      (serialize)
      (send label-message get-label))))
