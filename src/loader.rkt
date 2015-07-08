#lang racket/gui

(require racket/contract
         racket/match
         
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
       (map make-component components)]))

  (map row->components blob-components))

(define (main-window)
  (define top-frame (new frame% [label "WindowSpecTest"]))
  
  (define components
    (make-components (call-with-input-file "components.blob" read)
                     top-frame))
  
  (send top-frame show #t))

(module+ main
  (main-window))
