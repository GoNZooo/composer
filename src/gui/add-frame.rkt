#lang racket/gui

(require "add-button-dialog.rkt")

(provide add-dialog%)
(define add-dialog%
  (class dialog%
    (super-new)

    (init-field sections)

    (define/public
      (add-button section name template clear)
      
      (send (send this get-parent)
            add-button
            section name template clear))

    (define type-radio-box
      (new radio-box%
           [label "Type of item"]
           [choices '("Button"
                      "Row"
                      "Section")]
           [parent this]
           [style '(vertical
                     vertical-label)]))

    (define add-button-dialog
      (new add-button-dialog%
           [parent this]
           [label "Add button"]
           [sections sections]))

    (define add-button-button
      (new button%
           [label "Add"]
           [parent this]
           [callback
             (lambda (button event)
               (case (send type-radio-box get-selection)
                 [(0) (send add-button-dialog show #t)]
                 [else #f]))]))
    
    (define/public
      (add-done)
      
      (send this show #f))))
