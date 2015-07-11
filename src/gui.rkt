#lang racket/gui

(require gonz/gui-helpers
         "parameters.rkt"
         "loader.rkt")

(define (main-window)
  (define top-frame (new frame% [label "Invoker 2.0 [2015-07-XX]"]
                         [alignment '(center top)]))

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

  (btn other-load top-frame "Load other"
       (lambda (b e)
         (load-components component-panel "other.blob")))
  
  (btn orig-load top-frame "Load orig."
       (lambda (b e)
         (load-components component-panel "components.blob")))

  (btn show-children top-frame "Children"
       (lambda (b e)
         (view-children top-frame)))

  (vpanel component-panel top-frame
          [alignment '(center top)])
  
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

(module+ main
  (require racket/pretty)
  (define top-frame (main-window))

  (pretty-print (view-children top-frame)))
