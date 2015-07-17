#lang racket/gui

(require "../parameters.rkt"
         "edit-section-dialog.rkt")

(provide section-label%)
(define section-label%
  (class horizontal-panel%
    (super-new)

    (init-field label)

    (define label-message (new message%
                               [parent this]
                               [label label]))

    (define inner-edit-section-dialog #f)

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-control-down)
              (send event get-shift-down))
         (let ([inner-edit-section-dialog
                 (new edit-section-dialog%
                      [parent #f]
                      [edited-section (send this get-parent)]
                      [label "Edit section"])])
           (send inner-edit-section-dialog
                 show
                 #t))]
        [else #f]))

    (define/public
      (serialize)
      (send label-message get-label))))
