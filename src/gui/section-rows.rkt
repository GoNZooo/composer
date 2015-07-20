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
                  [min-height 25]
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
      (get-section)
      
      (send (send this get-parent)
            get-section-label))

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
                   [buttons '()]
                   [min-height 25]
                   [alignment '(center top)])
              inner-rows))
      
      (set-children inner-rows))

    (define/public
      (remove-row row)
      
      (set! inner-rows
        (filter (lambda (r)
                  (not (eqv? row
                             r)))
                inner-rows))
      (set-children inner-rows))

    (define (row-before row)
      (define (row-eqv? r)
        (eqv? row
              r))

      (match inner-rows
        [(list before ... prev (? row-eqv? r) after ...)
         prev]
        [(list (? row-eqv? r) after ...)
         r]))

    (define (row-after row)
      (define (row-eqv? r)
        (eqv? row
              r))

      (match inner-rows
        [(list before ... (? row-eqv? r))
         r]
        [(list before ... (? row-eqv? r) next after ...)
         next]))

    (define/public
      (re-parent-button button
                        direction)

      (case direction
        [(up)
         (send button
               reparent
               (row-before (send button
                                 get-parent)))]
        [(down)
         (send button
               reparent
               (row-after (send button
                                get-parent)))]))

    (define/public
      (re-parent-row row
                     section)
      
      (send (send this
                  get-parent)
            re-parent-row
            row
            section))

    (define/public
      (serialize)

      (cons 'rows
            (map (lambda (child)
                   (send child serialize))
                 (send this get-children))))))
