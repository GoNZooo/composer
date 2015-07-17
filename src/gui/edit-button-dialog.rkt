#lang racket/gui

(require "add-button-dialog.rkt")

(provide edit-button-dialog%)
(define edit-button-dialog%
  (class dialog%
    (super-new)
    
    (init sections
          edited-button
          top-level-window)

    (define edited-row (send edited-button
                             get-parent))

    (define add-button-dialog #f)

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

    (define section-combo-field
      (new combo-field%
           [parent button-vert-panel]
           [choices (map (lambda (s)
                           (send s get-section-label))
                         sections)]
           [label "Section"]
           [style '(vertical-label)]
           [init-value (send edited-button
                             get-section)]))

    (define name-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Name"]
           [style '(single vertical-label)]
           [init-value (send edited-button
                             get-button-label)]))

    (define clear-check-box
      (new check-box%
           [parent main-vertical-panel]
           [label "Clear clipboard before use"]
           [value (send edited-button
                        get-clear)]))

    (define template-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Template"]
           [style '(multiple)]
           [init-value (send edited-button
                             get-template)]))

    (define button-section-button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))
    
    (define edit-button-button
      (new button%
           [parent button-section-button-panel]
           [label "Edit"]
           [callback
             (lambda (button event)
               (if (equal? (send section-combo-field
                                 get-value)
                           (send edited-button get-section))
                 (begin
                   (send edited-button
                         set-name
                         (send name-field
                               get-value))
                   (send edited-button
                         set-template
                         (send template-field
                               get-value))
                   (send edited-button
                         set-clear
                         (send clear-check-box
                               get-value)))
                 (begin
                   (send top-level-window
                         add-button
                         (send section-combo-field
                               get-value)
                         (send name-field
                               get-value)
                         (send template-field
                               get-value)
                         (send clear-check-box
                               get-value))
                   (send (send edited-button
                               get-parent)
                         remove-button
                         edited-button))))]))
    
    (define remove-button-button
      (new button%
           [parent button-section-button-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-button get-parent)
                     remove-button edited-button))]))

    (define button-section-move-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define button-move-left-button
      (new button%
           [parent button-section-move-panel]
           [label "<-"]
           [callback
             (lambda (button event)
               (send edited-button
                     move
                     'left))]))

    (define button-move-right-button
      (new button%
           [parent button-section-move-panel]
           [label "->"]
           [callback
             (lambda (button event)
               (send edited-button
                     move
                     'right))]))
    
    (define row-message
      (new message%
           [parent main-vertical-panel]
           [label "Row settings"]))

    (define row-section-button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))
    
    (define remove-row-button
      (new button%
           [parent row-section-button-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-row
                           get-parent)
                     remove-row
                     edited-row))]))
    
    (define add-button-button
      (new button%
           [parent row-section-button-panel]
           [label "Add button"]
           [callback
             (lambda (button event)
               (set! add-button-dialog
                 (new add-button-dialog%
                      [parent this]
                      [parent-row edited-row]
                      [label "Add button"]))
               (send add-button-dialog
                     show
                     #t))]))))
