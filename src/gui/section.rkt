#lang racket/gui

(require "parent-manipulation.rkt"
         "section-label.rkt"
         "row.rkt")

(provide section%)
(define section%
  (class vertical-panel%
    (super-new)

    (init rows)
    (init-field section-label)

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define (make-rows rows)
      (for-each (lambda (r)
                  (new row%
                       [parent this]
                       [buttons (cdr r)]
                       [alignment '(center top)]))
                rows))

    (new section-label%
         [parent this]
         [label section-label])
    (make-rows rows)

    (define (move-child child direction)
      (set-children
        (lambda (c)
          (case direction
            [(left) (move-left child (send this get-children))]
            [(right) (move-right child (send this get-children))]
            [else #f]))))

    (define/public
      (get-section-label)

      section-label)

    (define/public
      (serialize)

      (cons 'section
            (map (lambda (child)
                   (send child serialize))
                 (send this get-children))))
    ))
