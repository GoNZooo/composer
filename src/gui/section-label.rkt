#lang racket/gui

(require "../parameters.rkt"
         "edit-section-dialog.rkt"
         "parent-manipulation.rkt")

(provide section-label%)
(define section-label%
  (class horizontal-panel%
    (super-new)

    (init-field label)

    (set! label
      (new message%
           [parent this]
           [label label]
           [font (make-object font%
                              12
                              'modern
                              'normal
                              'bold)]))

    (define inner-edit-section-dialog #f)

    (define/public
      (set-section-label new-label)

      (child- this
              label)
      (set! label
        (new message%
             [parent this]
             [label new-label]
             [font (make-object font%
                                12
                                'modern
                                'normal
                                'bold)])))

    (define/public
      (get-section-label)
      
      (send label
            get-label))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
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

      (send label get-label))))
