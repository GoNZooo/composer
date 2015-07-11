#lang racket/gui

(require "parent-manipulation.rkt"
         "parameters.rkt")

(provide movable-horizontal-panel%)
(define movable-horizontal-panel%
  (class horizontal-panel%

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-shift-down))
         (move-left-in-container this)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-shift-down))
         (move-right-in-container this)]
        [else #f]))

    (super-new)))
