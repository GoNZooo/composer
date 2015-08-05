#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "tab.rkt")

(provide template-content%)
(define template-content%
  (class tab-panel%
    (super-new [choices '()])

    (init-field tabs)
    (field [active-tab #f])

    (define (init-tabs)
      (map (lambda (s)
             (new tab%
                  [parent this]
                  [tab-label (cadr s)]
                  [sections (cddr s)]))
           tabs))

    (set! tabs
      (init-tabs))
    (set! active-tab (car tabs))

    (define (set-tabs ts)
      (set! tabs ts)
      (send this
            change-children
            (lambda (children)
              tabs)))

    (define/public
      (get-tabs)

      tabs)

    (define/public
      (set-tab-label tab
                     new-label)

      (printf "Rename-message: ~a ~a ~n"
              tab new-label)

      (define (rename-tab [ts tabs] [n 0])
        (cond
          [(null? ts)
           #f]
          [(eqv? (car ts)
                 tab)
           (send this
                 set-item-label
                 n
                 new-label)]
          [else
            (rename-tab (cdr ts)
                        (add1 n))]))

      (rename-tab))

    (define/public
      (get-active-tab)
      
      active-tab)

    (define/public
      (set-active-tab n)

      (when (not (equal? (get-active-tab)
                         #f))
        (send this
              delete-child
              (get-active-tab)))
      (send this
            add-child
            (list-ref tabs
                      n))
      (set! active-tab
        (list-ref tabs
                  n)))

    (define/public
      (serialize)

      (cons 'templates
            (map (lambda (tab)
                   (send tab
                         serialize))
                 tabs)))))
