#lang racket/gui

(provide edit-button-dialog%)
(define edit-button-dialog%
  (class dialog%
    (super-new)
    
    (init button-name
          template
          clear
          sections)
    
    (define section-combo-field
      (new combo-field%
           [parent this]
           [choices (map (lambda (s)
                           (send s get-section-label))
                         (send (send this get-parent)
                               get-sections))]
           [label "Section"]))
    
    (define name-field
      (new text-field%
           [parent this]
           [label "Button name:"]
           [init-value button-name]))

    (define clear-check-box
      (new check-box%
           [parent this]
           [label "Clear clipboard before use:"]
           [value clear]))

    (define template-field
      (new text-field%
           [parent this]
           [label "Template:"]
           [style '(multiple)]
           [init-value template]))
    
    (define add-button
      (new button%
           [parent this]
           [label "Modify"]
           [callback
             (lambda (button event)
               (send (send this get-parent)
                     add-button
                     (send section-combo-field get-value)
                     (send name-field get-value)
                     (send template-field get-value)
                     (send clear-check-box get-value))
               (send (send this get-parent)
                     remove-self))]))))
