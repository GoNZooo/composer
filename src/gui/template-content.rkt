#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "section.rkt")

(require racket/pretty)
(provide template-content%)
(define template-content%
  (class vertical-panel%
    (super-new)

    (init-field sections)

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define/public
      (get-sections)
      
      inner-sections)

    (define (make-sections sections)
      (set-children (map (lambda (s)
                           (new section%
                                [parent this]
                                [section-label (cadr s)]
                                [rows (cddr s)]))
                         sections)))

    (define (init-sections sections)
      (map (lambda (s)
             (new section%
                  [parent this]
                  [section-label (cadr s)]
                  [rows (cddr s)]))
           sections))

    (define inner-sections (init-sections sections))

    (define/public
      (move-child child direction)

      (set! inner-sections
        (case direction
          [(left) (move-left child inner-sections)]
          [(right) (move-right child inner-sections)]
          [else #f]))
      (set-children inner-sections))

    (define (find-section name [sections inner-sections])
      (for/or ([section sections])
        (if (equal? name (send section get-section-label))
          section
          #f)))

    (define/public
      (add-button section name template clear)
      
      (send (find-section section)
            add-button name template clear))

    (define/public
      (add-row section)
      
      (send (find-section section)
            add-row))

    (define/public
      (add-section name)
      
      (set! inner-sections
        (cons (new section%
                   [parent this]
                   [section-label name]
                   [rows '((rows (row ())))])
              inner-sections))
      
      (set-children inner-sections))

    (define/public
      (serialize)

      (cons 'templates (map (lambda (section)
                              (send section serialize))
                            inner-sections)))
    ))
