#lang racket/gui

(provide parent-of)
(define/contract (parent-of element)
  (struct? . -> . struct?)

  (send element get-parent))

(provide children-of)
(define/contract (children-of parent)
  (struct? . -> . (listof struct?))

  (send parent get-children))

(provide new-children)
(define (new-children parent children)
  (send parent
        change-children
        (lambda (c)
          children)))

(provide move-left-in-container)
(define (move-left-in-container e
                                #:compare [comp eqv?])
  (new-children (parent-of e)
                (move-left e (children-of (parent-of e)))))

(provide move-right-in-container)
(define (move-right-in-container e
                                #:compare [comp eqv?])
  (new-children (parent-of e)
                (move-right e (children-of (parent-of e)))))

(define (move-left i lst
                   #:compare [comp eqv?])

  (define (found-item? item)
    (comp item i))

  (match lst
    [(list (? found-item? found)
           after ...)
     lst]
    [(list before ... prev
           (? found-item? found))
     (append before
             (list found prev))]
    [(list before ... prev
           (? found-item? found)
           next
           after ...)
     (append before
             (list found prev next)
             after)]))

(define (move-right i lst
                    #:compare [comp eqv?])

  (define (found-item? item)
    (equal? item i))

  (match lst
    [(list (? found-item? found)
           next
           after ...)
     (append (list next found)
             after)]
    [(list before ...
           (? found-item? found))
     lst]
    [(list before ... prev
           (? found-item? found)
           next
           after ...)
     (append before
             (list prev next found)
             after)]))
