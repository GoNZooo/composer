#lang racket/gui

(provide add-frame%)
(define add-frame%
  (class frame%
    (super-new)
    
    (define type-radio-box
      (new radio-box%
           [label "Type of item"]
           [choices '("Button"
                      "Row"
                      "Section")]
           [parent this]
           [style '(vertical-label)]))))
