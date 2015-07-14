#lang racket/gui

(provide add-dialog%)
(define add-dialog%
  (class dialog%
    (super-new)
    
    (define type-radio-box
      (new radio-box%
           [label "Type of item"]
           [choices '("Button"
                      "Row"
                      "Section")]
           [parent this]
           [style '(vertical)]))))
