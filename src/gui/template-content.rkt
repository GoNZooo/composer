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

    (init-sections sections)

    (define/public (move-child child direction)
                   (set-children
                     (case direction
                       [(left) (move-left child (send this get-children))]
                       [(right) (move-right child (send this get-children))]
                       [else #f])))

    (define/public
      (serialize)

      (cons 'templates (map (lambda (child)
                              (send child serialize))
                            (send this get-children))))
    ))
