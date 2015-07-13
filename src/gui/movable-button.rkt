#lang racket/gui

(require "../parameters.rkt")

(provide movable-button%)
(define movable-button%
  (class button%

    (init-field clear
                template)

    (define (move direction)
      (send (send this get-parent) move-button this direction))

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
        [else #f]))

    (define/public
      (get-template)
      template)

    (define/public
      (serialize)

      (if clear
        `(button ,(send this get-label) ,template clear)
        `(button ,(send this get-label) ,template)))

    (super-new)))
