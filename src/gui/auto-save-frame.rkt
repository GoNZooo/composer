#lang racket/gui

(provide auto-save-frame%)
(define auto-save-frame%
  (class frame%

    (field auto-save-callback)

    (define/public
      (set-auto-save-callback callback)

      (set! auto-save-callback callback))

    (define/augment
      (on-close)

      (auto-save-callback))

    (super-new)))
