#lang racket/gui

(require racket/pretty
         
         gonz/gui-helpers

         "movable-button.rkt"
         "movable-horizontal-panel.rkt"
         "auto-save-frame.rkt"
         "parameters.rkt"
         "loader.rkt")

(define (main-window)

  (define (components [frame top-frame])
    (serialize-object (car (reverse (view-children frame)))))

  (define (save-components [frame top-frame]
                           [filename "components.blob"])
    (write-components-to-file (components) 
                              filename))
  
  (define (print-components [frame top-frame])
    (pretty-print (components)))

  (define top-frame (new auto-save-frame%
                         [label "Invoker 2.0 [2015-07-XX]"]
                         [alignment '(center top)]
                         [auto-save-callback save-components]
                         [style (window-style)]))

  (define built-in-panel (new horizontal-panel%
                              [parent top-frame]))

  (btn edit-mode-switch built-in-panel "Edit-mode"
       (lambda (b e)
         (edit-mode (not (edit-mode)))))

  (btn clear-clipboard built-in-panel "Clear clipboard"
       (lambda (b e)
         (send the-clipboard
               set-clipboard-string
               ""
               (send e get-time-stamp))))

  (btn iconize-window built-in-panel "Iconize window"
       (lambda (b e)
         (send built-in-panel iconize #t)))

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
      (pretty-write components output-port))
    #:exists 'replace))


(module+ main
  (define top-frame (main-window))
  )
