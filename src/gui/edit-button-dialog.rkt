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
    
    (define button-horizontal-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define button-left-panel
      (new vertical-panel%
           [parent button-horizontal-panel]
           [alignment '(center top)]))

    (define button-right-panel
      (new vertical-panel%
           [parent button-horizontal-panel]
           [alignment '(center top)]))

    (define section-message
      (new message%
           [parent button-left-panel]
           [label "Section:"]))

    (define section-combo-field
      (new combo-field%
           [parent button-right-panel]
           [choices (map (lambda (s)
                           (send s get-section-label))
                         sections)]
           [label #f]
           [init-value (send edited-button
                             get-section)]))

    (define name-message
      (new message%
           [parent button-left-panel]
           [label "Button name:"]))

    (define name-field
      (new text-field%
           [parent button-right-panel]
           [label #f]
           [init-value (send edited-button
                             get-button-label)]))

    (define clear-message
      (new message%
           [parent button-left-panel]
           [label "Clear clipboard before use:"]))

    (define clear-check-box
      (new check-box%
           [parent button-right-panel]
           [label ""]
           [value (send edited-button
                        get-clear)]))

    (define template-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Template:"]
           [style '(multiple)]
           [init-value (send edited-button
                             get-template)]))
    
    (define edit-button-button
      (new button%
           [parent main-vertical-panel]
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
           [parent main-vertical-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-button get-parent)
                     remove-button edited-button))]))
    
    (define row-message
      (new message%
           [parent main-vertical-panel]
           [label "Row settings"]))

    (define row-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))
    
    (define remove-row-button
      (new button%
           [parent row-panel]
           [label "Remove"]
           [callback
             (lambda (button event)
               (send (send edited-row
                           get-parent)
                     remove-row
                     edited-row))]))
    
    (define add-button-button
      (new button%
           [parent row-panel]
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
