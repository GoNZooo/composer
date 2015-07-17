#lang racket/gui

(require "add-button-dialog.rkt")

(provide edit-row-dialog%)
(define edit-row-dialog%
  (class dialog%
    (super-new)

    (init edited-row)

    (define add-button-dialog #f)

    (define main-vertical-panel
      (new vertical-panel%
           [parent this]
           [alignment '(center top)]))
    
    (define button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))
    
    (define remove-row-button
      (new button%
           [parent button-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-row
                           get-parent)
                     remove-row
                     edited-row))]))
    
    (define add-button-button
      (new button%
           [parent button-panel]
           [label "Add button"]
           [callback
             (lambda (button event)
               (set! add-button-dialog
                 (new add-button-dialog%
                      [parent this]
                      [label "Add button"]
                      [parent-row edited-row]))
               (send add-button-dialog
                     show
                     #t))]))
    
    (define row-section-move-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define row-move-left-button
      (new button%
           [parent row-section-move-panel]
           [label "^"]
           [callback
             (lambda (button event)
               (send edited-row
                     move
                     'left))]))

    (define row-move-right-button
      (new button%
           [parent row-section-move-panel]
           [label "v"]
           [callback
             (lambda (button event)
               (send edited-row
                     move
                     'right))]))))
