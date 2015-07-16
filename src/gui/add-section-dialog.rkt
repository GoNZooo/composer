#lang racket/gui

(provide add-section-dialog%)
(define add-section-dialog%
  (class dialog%
    (super-new)

    (define name-field
      (new text-field%
           [parent this]
           [label "Section name"]))
    
    (define add-section-button
      (new button%
           [parent this]
           [label "Add"]
           [callback
             (lambda (button event)
               (send (send this get-parent)
                     add-section
                     (send name-field get-value)
                     '((rows (row ())))))]))))


