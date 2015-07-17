#lang racket/gui

(provide add-button-dialog%)
(define add-button-dialog%
  (class dialog%
    (super-new)

    (init parent-row)

    (define main-vertical-panel
      (new vertical-panel%
           [parent this]
           [alignment '(center top)]))

    (define button-message
      (new message%
           [parent main-vertical-panel]
           [label "Button settings"]))
    
    (define button-vert-panel
      (new vertical-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define name-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Name"]
           [style '(single vertical-label)]))

    (define clear-check-box
      (new check-box%
           [parent main-vertical-panel]
           [label "Clear clipboard before use"]))

    (define template-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Template"]
           [style '(multiple)]))

    (define button-section-button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))
    
    (define add-button
      (new button%
           [parent this]
           [label "Add"]
           [callback
             (lambda (button event)
               (send parent-row
                     add-button
                     (send name-field get-value)
                     (send template-field get-value)
                     (send clear-check-box get-value)))]))))
