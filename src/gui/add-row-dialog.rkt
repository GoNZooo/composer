#lang racket/gui

(provide add-row-dialog%)
(define add-row-dialog%
  (class dialog%
    (super-new)

    (init-field sections)

    (define section-combo-field
      (new combo-field%
           [parent this]
           [choices (map (lambda (s)
                           (send s get-section-label))
                         sections)]
           [label "Section"]))
    
    (define add-row
      (new row%
           [parent this]
           [callback
             (lambda (button event)
               (send (send this get-parent)
                     add-row
                     (send section-combo-field get-value)))]))
    ))

