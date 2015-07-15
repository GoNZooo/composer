#lang racket/gui

(provide auto-save-frame%)
(define auto-save-frame%
  (class frame%

    (field [auto-save-callback
             (lambda ()
               #f)]
           [template-content-panel #f])
    
    (define/public
      (set-auto-save-callback callback)

      (set! auto-save-callback callback))

    (define/augment
      (on-close)

      (auto-save-callback))

    (define/public
      (set-template-content-panel panel)
      
      (set! template-content-panel panel))

    (define/public
      (get-template-content-panel)
      
      template-content-panel)

    (define/public
      (add-button section name template clear)
      
      (send template-content-panel
            add-button
            section name template clear))

    (define/public
      (add-row section)
      
      (send template-content-panel
            add-row
            section))

    (super-new)))
