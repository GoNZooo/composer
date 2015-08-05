#lang racket/gui

(require racket/pretty)
(require racket/contract
         racket/match
         racket/list

         "parameters.rkt"
         "gui/template-content.rkt")

(provide make-components)
(define (make-components blob-components top-frame)

  (match blob-components
    [(list 'templates tabs ...)
     (new template-content%
          [parent top-frame]
          [tabs tabs]
          [alignment '(center top)])]))
