#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "row.rkt")

(provide section-rows%)
(define section-rows%
  (class vertical-panel%
    (super-new)

    (init-field rows)

    (define (make-rows rows)
      (map (lambda (r)
             (new row%
                  [parent this]
                  [buttons (cdr r)]
                  [min-height 25]
                  [alignment '(center top)]))
           rows))

    (set! rows (make-rows rows))

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define/public
      (move-child child direction)

      (set! rows
        (case direction
                   [(left) (move-left child
                                      (send this
                                            get-children))]
                   [(right) (move-right child
                                        (send this
                                              get-children))]
                   [else #f]))
      (set-children rows))

    (define/public
      (get-sections)

      (send (send this
                  get-parent)
            get-sections))

    (define/public
      (get-section)

      (send (send this
                  get-parent)
            get-section-label))

    (define/public
      (add-button name
                  template
                  clear)

      (send (car rows)
            add-button
            name
            template
            clear))

    (define/public
      (add-row)

      (set! rows
        (cons (new row%
                   [parent this]
                   [buttons '()]
                   [min-height 25]
                   [alignment '(center top)])
              rows))

      (set-children rows))

    (define/public
      (put-row row)

      (define new-row
        (new row%
             [parent this]
             [buttons
               (cdr (send row
                          serialize))]
             [alignment '(center top)]))

      (set! rows
        (cons new-row
              rows)))

    (define/public
      (remove-row row)

      (set! rows
        (filter (lambda (r)
                  (not (eqv? row
                             r)))
                rows))
      (set-children rows))

    (define (row-before row)
      (match rows
        [(list before ... prev r after ...)
         #:when (eqv? row
                      r)
         prev]
        [(list r after ...)
         #:when (eqv? row
                      r)
         r]))

    (define (row-after row)
      (match rows
        [(list before ... r)
         #:when (eqv? row
                      r)
         r]
        [(list before ... r next after ...)
         #:when (eqv? row
                      r)
         next]
        [(list before ... r next)
         #:when (eqv? row
                      r)
         next]
        ))

    (define/public
      (re-parent-button button
                        direction)

      (case direction
        [(up)
         (send button
               reparent
               (row-before (send button
                                 get-parent)))
         button]
        [(down)
         (send button
               reparent
               (row-after (send button
                                get-parent)))
         button]))

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
