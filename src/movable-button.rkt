#lang racket/gui

(require "parent-manipulation.rkt"
         "parameters.rkt")

(provide movable-button%)
(define movable-button%
  (class button%

    (init template-text)

    (define template template-text)

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (move-left-in-container this)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down))
         (move-right-in-container this)]
        [else #f]))

    (define/public
      (get-template)
      template)

    (super-new)))
