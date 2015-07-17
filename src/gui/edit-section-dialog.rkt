#lang racket/gui

(provide edit-section-dialog%)
(define edit-section-dialog%
  (class dialog%
    (super-new)

    (init edited-section)

    (define name-field
      (new text-field%
           [parent this]
           [label "Section name:"]
           [init-value name]))

    (define edit-section-button
      (new button%
           [parent this]
           [label "Edit"]
           [callback
             (lambda (button event)
               (send edited-section
                     set-section-label
                     (send name-field get-value)))]))

    (define remove-section-button
      (new button%
           [parent this]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-section
                           get-parent)
                     remove-section
                     edited-section))]))

    (define add-row-button
      (new button%
           [parent this]
           [label "Add row"]
           [callback
             (lambda (button event)
               (send edited-section
                     add-row))]))
    
    (define section-move-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define section-move-left-button
      (new button%
           [parent section-move-panel]
           [label "^"]
           [callback
             (lambda (button event)
               (send edited-section
                     move
                     'left))]))

    (define section-move-right-button
      (new button%
           [parent section-move-panel]
           [label "v"]
           [callback
             (lambda (button event)
               (send edited-section
                     move
                     'right))]))))
