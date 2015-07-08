#lang racket/gui

(require racket/contract
         racket/match
         racket/pretty
         
         gonz/gui-helpers)

(define (make-components blob-components top-frame)

  (define (row->components row-components)
    (hpanel rpanel top-frame
            [alignment '(center top)])

    (define (make-component c)

      (define (make-callback p #:clear [clear? #f])
        (lambda (b e)
          (if clear?
            (printf "Reading from after clear: ~a~n" p)
            (printf "Reading from: ~a~n" p))))

      (match c
        [(list 'label content) (new message% [parent rpanel] [label content])]
        [(list 'button text path)
         (new button%
              [parent rpanel]
              [label text]
              [callback (make-callback path)])]
        [(list 'button text path 'clear)
         (new button%
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

  (btn other-load top-frame "Load other"
       (lambda (b e)
         (load-components component-panel "other.blob")
         (pretty-print (view-children top-frame))
         ))
  
  (btn orig-load top-frame "Load orig."
       (lambda (b e)
         (load-components component-panel "components.blob")
         (pretty-print (view-children top-frame))
         ))

  (vpanel component-panel top-frame
          [alignment '(center top)])
  
  (send top-frame show #t))

(module+ main
  (main-window))
