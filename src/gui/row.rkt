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

    (define (make-buttons bs)
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
                [clear #f])]
          ['() '()]))

      (map make-button bs))

    (define inner-buttons (make-buttons buttons))

    (define/public
      (move-child child direction)

      (set! inner-buttons (case direction
                            [(left) (move-left child inner-buttons)]
                            [(right) (move-right child inner-buttons)]
                            [else #f]))
      (set-children inner-buttons))

    (define/public
      (get-sections)
      
      (send (send this get-parent)
            get-sections))

    (define/public
      (add-button name template clear)
      
      (set! inner-buttons (cons (new movable-button%
                                     [parent this]
                                     [label name]
                                     [template template]
                                     [clear clear])
                                inner-buttons))
      (set-children inner-buttons))

    (define/public
      (remove-button button)
      
      (set! inner-buttons
        (for/list ([b inner-buttons])
          (not (equal? b button))))
      (set-children inner-buttons))

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
                      (send this get-children))))))
