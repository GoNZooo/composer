#lang racket/gui

(require "../parameters.rkt"
         "edit-button-dialog.rkt")

(provide movable-button%)
(define movable-button%
  (class button%

    (init-field clear
                template)

    (define (move direction)
      (send (send this get-parent) move-child this direction))

    (define inner-edit-button-dialog
      (new edit-button-dialog%
           [parent this]
           [button-name (send this get-button-label)]
           [template template]
           [clear clear]
           [sections (send (send this get-parent)
                           get-sections)]))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (move 'left)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down))
         (move 'right)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-shift-down)
              (send event get-control-down))
         (send inner-edit-button-dialog
               show #t)]
        [else #f]))

    (define/public
      (get-template)
      template)

    (define/public
      (get-button-label)
      
      (send this get-label))

    (define/public
      (remove-self)
      
      (send (send this get-parent)
            remove-button
            this))

    (define/public
      (serialize)

      (if clear
        `(button ,(send this get-label) ,template clear)
        `(button ,(send this get-label) ,template)))

    (super-new)))
