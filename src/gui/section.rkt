#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "section-label.rkt"
         "section-rows.rkt")

(provide section%)
(define section%
  (class vertical-panel%
    (super-new)

    (init rows)
    (init-field section-label)

    (define inner-section-label (new section-label%
                                     [parent this]
                                     [label section-label]
                                     [alignment '(center top)]))

    (define inner-section-rows (new section-rows%
                                    [parent this]
                                    [rows (cdar rows)]
                                    [alignment '(center top)]))

    (define (move direction)
      (send (send this get-parent) move-child this direction))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-control-down))
         (move 'left)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-control-down))
         (move 'right)]
        [else #f]))

    (define/public
      (get-section-label)

      section-label)

    (define/public
      (serialize)

      (cons 'section
            (list (send inner-section-label serialize)
                  (send inner-section-rows serialize))))
    ))
