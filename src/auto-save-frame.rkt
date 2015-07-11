#lang racket/gui

(provide auto-save-frame%)
(define auto-save-frame%
  (class frame%

    (init-field auto-save-callback)

    (define/override
      (on-close)
      
      (auto-save-callback))

    (super-new)))
