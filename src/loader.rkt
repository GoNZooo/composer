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
    [(list 'templates sections ...)
     (new template-content%
          [parent top-frame]
          [sections sections]
          [alignment '(center top)])]))
