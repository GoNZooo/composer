#lang racket/gui

(provide add-button-dialog%)
(define add-button-dialog%
  (class dialog%
    (super-new)

    (init-field sections)

    (define section-combo-field
      (new combo-field%
           [parent this]
           [choices sections]
           [label "Section"]))
    
    (define name-field
      (new text-field%
           [parent this]
           [label "Button name:"]))

    (define clear-check-box
      (new check-box%
           [parent this]
           [label "Clear clipboard before use:"]))

    (define template-field
      (new text-field%
           [parent this]
           [label "Template:"]
           [style '(multiple)]))
    
    (define add-button
      (new button%
           [parent this]
           [label "Add"]
           [callback
             (lambda (button event)
               (send (send this get-parent)
                     add-button
                     (send section-combo-field get-value)
                     (send name-field get-value)
                     (send template-field get-value)
                     (send clear-check-box get-value)))]))))
