#lang racket/gui

(provide edit-section-dialog%)
(define edit-section-dialog%
  (class dialog%
    (super-new)
    
    (init name
          edited-section
          top-level-window
          rows)
    
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
               (send top-level-window
                     add-section
                     (send name-field get-value)
                     rows)
               (send top-level-window
                     remove-section edited-section))]))
    
    (define remove-section-button
      (new button%
           [parent this]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send top-level-window
                     remove-section edited-section))]))
    
    (define add-row-button
      (new button%
           [parent this]
           [label "Add row"]
           [callback
             (lambda (button event)
               (send edited-section
                     add-row))]))))
