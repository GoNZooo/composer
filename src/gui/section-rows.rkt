#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "row.rkt")

(provide section-rows%)
(define section-rows%
  (class vertical-panel%
    (super-new)

    (init rows)

    (define (make-rows rows)
      (map (lambda (r)
             (new row%
                  [parent this]
                  [buttons (cdr r)]
                  [alignment '(center top)]))
           rows))

    (define inner-rows (make-rows rows))

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define/public
      (move-child child direction)

      (set! inner-rows (case direction
                         [(left) (move-left child (send this get-children))]
                         [(right) (move-right child (send this get-children))]
                         [else #f]))
      (set-children inner-rows))

    (define/public
      (get-sections)
      
      (send (send this get-parent)
            get-sections))

    (define/public
      (add-button name template clear)
      
      (send (car inner-rows)
            add-button
            name template clear))

    (define/public
      (add-row)
      
      (set! inner-rows
        (cons (new row%
                   [parent this]
                   [buttons '()])
              inner-rows))
      
      (set-children inner-rows))

    (define/public
      (serialize)

      (cons 'rows
            (map (lambda (child)
                   (send child serialize))
                 (send this get-children))))
    ))
