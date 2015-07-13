#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "movable-button.rkt")

(provide row%)
(define row%
  (class horizontal-panel%
    (super-new)

    (init buttons)

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define (make-buttons buttons)
      (define (make-button b)
        (match b
          [(list 'button name text clear)
           (new movable-button%
                [parent this]
                [label name]
                [template text]
                [clear #t])]
          [(list 'button name text)
           (new movable-button%
                [parent this]
                [label name]
                [template text]
                [clear #f])]))

      (set-children (map make-button
                         buttons)))

    (make-buttons buttons)

    (define/public
      (move-child child direction)
      (set-children (case direction
                      [(left) (move-left child (send this get-children))]
                      [(right) (move-right child (send this get-children))]
                      [else #f])))

    (define (move direction)
      (send (send this get-parent) move-child this direction))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-shift-down))
         (move 'left)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-shift-down))
         (move 'right)]
        [else #f]))

    (define/public
      (serialize)

      (cons 'row (map (lambda (child)
                        (send child serialize))
                      (send this get-children))))
    ))
