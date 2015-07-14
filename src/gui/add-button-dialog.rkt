#lang racket/gui

(provide add-button-dialog%)
(define add-button-dialog%
  (class dialog%
    (super-new)
    
    (define name-field
      (new text-field%
           [parent this]
           [label "Button name:"]))

    (define template-field
      (new text-field%
           [parent this]
           [label "Template:"]))))
