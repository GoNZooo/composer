#lang racket/gui

(require "add-button-dialog.rkt")

(provide edit-button-dialog%)
(define edit-button-dialog%
  (class dialog%
    (super-new)

    (init sections
          top-level-window)
    (init-field edited-button)


    (define edited-row (send edited-button
                             get-parent))

    (define/public
      (set-edited-button button)

      (set! edited-button
        button))

    (define/public
      (get-edited-button)

      edited-button)

    (define/public
      (set-edited-row row)

      (set! edited-row
        row))

    (define/public
      (get-edited-row)

      edited-row)

    (define add-button-dialog #f)

    (define main-vertical-panel
      (new vertical-panel%
           [parent this]
           [alignment '(center top)]))

    (define button-message
      (new message%
           [parent main-vertical-panel]
           [label "Button settings"]
           [font (make-object font%
                              13
                              'modern)]))

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
           [init-value (send (get-edited-button)
                             get-section)]))

    (define name-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Name"]
           [style '(single vertical-label)]
           [init-value (send (get-edited-button)
                             get-button-label)]))

    (define clear-check-box
      (new check-box%
           [parent main-vertical-panel]
           [label "Clear clipboard before use"]
           [value (send (get-edited-button)
                        get-clear)]))

    (define template-field
      (new text-field%
           [parent main-vertical-panel]
           [label "Template"]
           [style '(multiple)]
           [init-value (send (get-edited-button)
                             get-template)]))

    (define button-section-button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define edit-button-button
      (new button%
           [parent button-section-button-panel]
           [label "Save button settings"]
           [callback
             (lambda (button event)
               (if (equal? (send section-combo-field
                                 get-value)
                           (send (get-edited-button) get-section))
                 (send this
                       set-edited-button 
                       (send (send (get-edited-button)
                                   get-parent)
                             recreate-button
                             (get-edited-button)
                             (send name-field
                                   get-value)
                             (send template-field
                                   get-value)
                             (send clear-check-box
                                   get-value)))
                 (begin
                   (send (send (get-edited-button)
                               get-parent)
                         remove-button
                         (get-edited-button))
                   (send this
                         set-edited-button
                         (send top-level-window
                               add-button
                               (send section-combo-field
                                     get-value)
                               (send name-field
                                     get-value)
                               (send template-field
                                     get-value)
                               (send clear-check-box
                                     get-value))))))]))

    (define remove-button-button
      (new button%
           [parent button-section-button-panel]
           [label "Remove button"]
           [callback
             (lambda (button event)
               (send (send (get-edited-button)
                           get-parent)
                     remove-button
                     (get-edited-button))
               (send this
                     show
                     #f))]))

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
               (send (get-edited-button)
                     move
                     'left))]))

    (define button-section-move-vert-panel
      (new vertical-panel%
           [parent button-section-move-panel]
           [alignment '(center top)]))

    (define button-move-up-button
      (new button%
           [parent button-section-move-vert-panel]
           [label "^"]
           [callback
             (lambda (button event)
               (send this
                     set-edited-button
                     (send (get-edited-button)
                           re-parent-button
                           'up)))]))

    (define button-move-down-button
      (new button%
           [parent button-section-move-vert-panel]
           [label "v"]
           [callback
             (lambda (button event)
               (send this
                     set-edited-button
                     (send (get-edited-button)
                           re-parent-button
                           'down)))]))

    (define button-move-right-button
      (new button%
           [parent button-section-move-panel]
           [label "->"]
           [callback
             (lambda (button event)
               (send (get-edited-button)
                     move
                     'right))]))

    (define row-message
      (new message%
           [parent main-vertical-panel]
           [label "Row settings"]
           [font (make-object font%
                              13
                              'modern)]))

    (define row-section-combo-field
      (new combo-field%
           [parent main-vertical-panel]
           [choices (map (lambda (s)
                           (send s get-section-label))
                         sections)]
           [label "Section for row"]
           [style '(vertical-label)]
           [init-value (send (get-edited-row)
                             get-section)]))

    (define edit-section-button
      (new button%
           [parent main-vertical-panel]
           [label "Save row settings"]
           [callback
             (lambda (button event)
               (child- (send (get-edited-row)
                           get-parent)
                       (get-edited-row))
               (send this
                     set-edited-row
                     (send (send (get-edited-row)
                                 get-parent)
                           re-parent-row
                           (get-edited-row)
                           (send row-section-combo-field
                                 get-value)))
               (send this
                     show
                     #f))]))

    (define row-section-button-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define remove-row-button
      (new button%
           [parent row-section-button-panel]
           [label "Remove row"]
           [callback
             (lambda (button event)
               (send (send (get-edited-row)
                           get-parent)
                     remove-row
                     (get-edited-row))
               (send this
                     show
                     #f))]))

    (define add-button-button
      (new button%
           [parent row-section-button-panel]
           [label "Add button to row"]
           [callback
             (lambda (button event)
               (set! add-button-dialog
                 (new add-button-dialog%
                      [parent this]
                      [parent-row (get-edited-row)]
                      [label "Add button"]))
               (send add-button-dialog
                     show
                     #t))]))

    (define row-section-move-panel
      (new horizontal-panel%
           [parent main-vertical-panel]
           [alignment '(center top)]))

    (define row-move-up-button
      (new button%
           [parent row-section-move-panel]
           [label "^"]
           [callback
             (lambda (button event)
               (send (get-edited-row)
                     move
                     'left))]))

    (define row-move-down-button
      (new button%
           [parent row-section-move-panel]
           [label "v"]
           [callback
             (lambda (button event)
               (send (get-edited-row)
                     move
                     'right))]))

    ))
