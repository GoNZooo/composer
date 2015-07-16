#lang racket/gui

(require "../parameters.rkt")

(provide section-label%)
(define section-label%
  (class horizontal-panel%
    (super-new)

    (init-field label)

    (define label-message (new message%
                               [parent this]
                               [label label]))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-control-down))
         (send (send this get-parent)
               move
               'left)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-control-down))
         (send (send this get-parent)
               move
               'right)]
        [else #f]))

    (define/public
      (serialize)
      (send label-message get-label))))
