#lang racket/gui

(provide edit-row-dialog%)
(define edit-row-dialog%
  (class dialog%
    (super-new)

    (init edited-row)
    
    (define horiz-main-panel
      (new horizontal-panel%
           [parent this]
           [alignment '(center top)]))
    
    (define remove-row-button
      (new button%
           [parent this]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-row
                           get-parent)
                     remove-row
                     edited-row))]))
    
    (define add-button-button
      (new button%
           [parent this]
           [label "Add button"]
           [callback
             (lambda (button event)
               (set! add-button-dialog
                 (new add-button-dialog%
                      [parent this]
                      [parent-row edited-row]))
               (send add-button-dialog
                     show
                     #t))]))))
