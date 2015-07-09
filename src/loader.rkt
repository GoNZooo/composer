#lang racket/gui

(require racket/contract
         racket/match
         racket/list
         racket/pretty
         
         gonz/gui-helpers)

(define edit-mode (make-parameter #f))

(define movable-button%
  (class button%

    (define/override
      (on-subwindow-event receiver event)
      
      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-control-down))
         (move-left-in-container (parent-of receiver))]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-control-down))
         (move-right-in-container (parent-of receiver))]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (move-left-in-container receiver)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down))
         (move-right-in-container receiver)]
        [else #f]))

    (super-new)))

(define movable-message%
  (class message%

    (define/override
      (on-subwindow-event receiver event)
      
      (printf "Event ~a @ ~a~n"
              (send event get-event-type)
              receiver)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-control-down))
         (move-left-in-container (parent-of receiver))]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down)
              (send event get-control-down))
         (move-right-in-container (parent-of receiver))]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (move-left-in-container receiver)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down))
         (move-right-in-container receiver)]
        [else #f]))

    (super-new)))

(define (parent-of element)
  (send element get-parent))
(define (children-of parent)
  (send parent get-children))

(define (new-children parent children)
  (send parent
        change-children
        (lambda (c)
          children)))

(define (move-left-in-container e
                                #:compare [comp eqv?])
  (new-children (parent-of e)
                (move-left e (children-of (parent-of e)))))

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

(define (make-components blob-components top-frame)

  (define (row->components row-components)
    (hpanel rpanel top-frame
            [alignment '(center top)])

    (define (make-component c)

      (define (make-callback p #:clear [clear? #f])
        
        (lambda (b e)
          (printf "Reading from path: ~a~n" p)))

      (match c
        [(list 'label content)
         (new movable-message% [parent rpanel] [label content])]
        [(list 'button text path)
         (new movable-button%
              [parent rpanel]
              [label text]
              [callback (make-callback path)])]
        [(list 'button text path 'clear)
         (new movable-button%
              [parent rpanel]
              [label text]
              [callback (make-callback path #:clear #t)])]))

    (match row-components
      [(list 'row components ...)
       (for-each make-component components)]))

  (for-each row->components blob-components))

(define (load-components top-frame [filename "components.blob"])
  (for-each
    (lambda (child)
      (send top-frame delete-child child))
    (send top-frame get-children))

  (make-components (call-with-input-file filename read)
                   top-frame))

(define (view-children object)
  (define (children-of o)
    (with-handlers
      ([exn:fail:object?
         (lambda (exn)
           #f)])
    (send o get-children)))

  (define children (children-of object))
  (if children
    (cons object (map view-children children))
    object))

(define (main-window)
  (define top-frame (new frame% [label "WindowSpecTest"]
                         [alignment '(center top)]))

  (btn edit-mode-switch top-frame "Edit-mode"
       (lambda (b e)
         (edit-mode (not (edit-mode)))))

  (btn other-load top-frame "Load other"
       (lambda (b e)
         (load-components component-panel "other.blob")))
  
  (btn orig-load top-frame "Load orig."
       (lambda (b e)
         (load-components component-panel "components.blob")))

  (vpanel component-panel top-frame
          [alignment '(center top)])
  
  (send top-frame show #t))


(module+ main
  (main-window)
  )
