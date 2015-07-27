#lang racket/gui

(provide edit-section-dialog%)
(define edit-section-dialog%
  (class dialog%
    (super-new)

    (init edited-section)

    (define main-vertical-panel
      (new vertical-panel%
           [parent this]
           [alignment '(center top)]))

    (define name-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Section name:"]
           [init-value (send edited-section
                             get-section-label)]
           [callback
             (lambda (text-field event)
               (when (equal? (send event
                                   get-event-type)
                             'text-field-enter)
                 (send edited-section
                       set-section-label
                       (send name-field
                             get-value))))]))

    (define button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define edit-section-button
      (new button%
           [parent button-panel]
           [label "Edit"]
           [callback
             (lambda (button event)
               (send edited-section
                     set-section-label
                     (send name-field
                           get-value)))]))

    (define remove-section-button
      (new button%
           [parent button-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-section
                           get-parent)
                     remove-section
                     edited-section)
               (send this
                     show
                     #f))]))

    (define add-row-button
      (new button%
           [parent button-panel]
           [label "Add row"]
           [callback
             (lambda (button event)
               (send edited-section
                     add-row)
               (send this
                     show
                     #f))]))

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
