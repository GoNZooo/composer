#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "section.rkt")

(provide tab%)
(define tab%
  (class vertical-panel%
    (super-new)

    (init-field tab-label
                sections)

    (define/public
      (set-tab-label new-label)
      
      (send (send this
                  get-parent)
            set-tab-label
            this
            new-label)

      (set! tab-label
        new-label))

    (set-tab-label tab-label)

    (define (init-sections)
      (map (lambda (s)
             (new section%
                  [parent this]
                  [section-label (cadr s)]
                  [rows (cddr s)]))
           sections))

    (set! sections
      (init-sections))

    (define (set-sections cs)
      (set! sections cs)
      (send this
            change-children
            (lambda (children)
              sections)))

    (define/public
      (get-sections)

      sections)

    (define/public
      (move-child child
                  direction)

      (set! sections
        (case direction
          [(left) (move-left child
                             sections)]
          [(right) (move-right child
                               sections)]
          [else #f]))
      (set-sections sections))

    (define (find-section name [secs sections])
      (for/or ([section secs])
        (if (equal? name
                    (send section get-section-label))
          section
          #f)))

    (define/public
      (add-button section
                  name
                  template
                  clear)

      (send (find-section section)
            add-button name
            template
            clear))

    (define/public
      (add-row section)

      (send (find-section section)
            add-row))

    (define/public
      (add-section name
                   rows)

      (set! sections
        (cons (new section%
                   [parent this]
                   [section-label name]
                   [rows rows])
              sections))

      (set-sections sections))

    (define/public
      (remove-section section)

      (set! sections
        (filter (lambda (s)
                  (not (eqv? s
                             section)))
                sections))
      (set-sections sections))

    (define/public
      (re-parent-row row
                     section)

      (send (find-section section)
            put-row
            row))

    (define/public
      (serialize)

      (append `(tab ,tab-label)
              (map (lambda (section)
                     (send section serialize))
                   sections)))))
