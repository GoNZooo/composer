#lang racket/gui

(require gonz/gui-helpers
         "movable-button.rkt"
         "movable-horizontal-panel.rkt"
         "parameters.rkt"
         "loader.rkt")

(define (main-window)
  (define top-frame (new frame% [label "Invoker 2.0 [2015-07-XX]"]
                         [alignment '(center top)]))

  (define (save-current-components [frame top-frame]
                                   [filename "components.blob"])
    (write-components-to-file
      (serialize-object
        (car (reverse (view-children frame))))
      filename))

  (btn edit-mode-switch top-frame "Edit-mode"
       (lambda (b e)
         (edit-mode (not (edit-mode)))))

  (btn clear-clipboard top-frame "Clear clipboard"
       (lambda (b e)
         (send the-clipboard
               set-clipboard-string
               ""
               (send e get-time-stamp))))

  (btn iconize-window top-frame "Iconize window"
       (lambda (b e)
         (send top-frame iconize #t)))

  (btn show-children top-frame "Children"
       (lambda (b e)
         (view-children top-frame)))

  (btn write-components-button top-frame "Write components"
       (lambda (b e)
         (save-current-components)))

  (vpanel component-panel top-frame
          [alignment '(center top)])

  (load-components component-panel "components.blob")
  (send top-frame show #t)
  top-frame)

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

(define (serialize-object object)
  (define (is-button? o)
    (is-a? o button%))
  (define (is-column? o)
    (is-a? o vertical-panel%))
  (define (is-row? o)
    (is-a? o movable-horizontal-panel%))
  (define (is-label? o)
    (is-a? o message%))

  (define (get-symbol o)
    (match o
      [(? is-button? b)
       'button]
      [(? is-column? c)
       'column]
      [(? is-row? r)
       'row]
      [(? is-label? l)
       'label]))

  (define (get-parameters o)
    (match o
      [(? is-button? b)
       `(,(send b get-label)
          ,(send b get-template))]
      [(? is-label? l)
       `(,(send l get-label))]))

  (match object
    [(list parent children ...)
     (cons (get-symbol parent)
           (map serialize-object children))]
    [child
      (cons (get-symbol child)
            (get-parameters child))]))

(define (write-components-to-file components [filename "components.blob"])
  (call-with-output-file
    filename
    (lambda (output-port)
      (write (serialize-object components)))
    #:exists 'replace))


(module+ main
  (require racket/pretty)
  (define top-frame (main-window))

  (pretty-print (serialize-object (car (reverse (view-children
                                                  top-frame))))))
