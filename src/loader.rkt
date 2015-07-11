#lang racket/gui

(require racket/pretty)
(require racket/contract
         racket/match
         racket/list


         "parent-manipulation.rkt"
         "parameters.rkt"
         "movable-button.rkt"
         "movable-horizontal-panel.rkt")

(provide make-components)
(define (make-components blob-components top-frame)

  (define (row->components row-components)
    (define row-panel
      (new movable-horizontal-panel%
           [parent top-frame]
           [alignment '(center top)]))

    (define (make-component c)

      (define (make-callback template #:clear [clear? #f])

        (define (get-clipboard-content timestamp)
          (send the-clipboard
                get-clipboard-string
                timestamp))

        (define (set-clipboard-content timestamp)
          (send the-clipboard
                set-clipboard-string
                template
                timestamp))

        (define (add-clipboard-content timestamp)
          (define (with-newlines str)
            (match str
              [(pregexp "\n\n$")
               str]
              [(pregexp "\n$")
               (string-append str "\n")]
              [_
                (string-append str "\n\n")]))

          (send the-clipboard
                set-clipboard-string
                (string-append (with-newlines (get-clipboard-content timestamp))
                               template)
                timestamp))

        (lambda (button event)
          (if clear?
            (set-clipboard-content (send event get-time-stamp))
            (add-clipboard-content (send event get-time-stamp))))) 

      (match c
        [(list 'label content)
         (new message% [parent row-panel] [label content])]
        [(list 'button text template-text)
         (new movable-button%
              [parent row-panel]
              [label text]
              [callback
                (make-callback template-text)]
              [template-text template-text])]
        [(list 'button text template-text 'clear)
         (new movable-button%
              [parent row-panel]
              [label text]
              [callback (make-callback template-text
                                       #:clear #t)]
              [template-text template-text])]))

    (match row-components
      [(list 'row components ...)
       (for-each make-component components)]))

  ;(pretty-print blob-components)
  (match blob-components
    [(list 'column rows ...)
     (for-each row->components rows)]
    [(list rows ...)
     (for-each row->components rows)]))

(provide load-components)
(define (load-components top-frame [filename "components.blob"])
  (for-each
    (lambda (child)
      (send top-frame delete-child child))
    (send top-frame get-children))

  (make-components (call-with-input-file filename read)
                   top-frame))

