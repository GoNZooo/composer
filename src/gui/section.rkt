#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "section-label.rkt"
         "section-rows.rkt")

(provide section%)
(define section%
  (class vertical-panel%
    (super-new)

    (init-field section-label
                rows)

    (set! section-label
      (new section-label%
           [parent this]
           [label section-label]
           [alignment '(center top)]))

    (set! rows
      (new section-rows%
           [parent this]
           [rows (cdar rows)]
           [spacing 0]
           [alignment '(center top)]))

    (define/public
      (move direction)

      (send (send this get-parent)
            move-child
            this direction))

    (define/public
      (get-sections)

      (send (send this get-parent)
            get-sections))

    (define/public
      (get-section-label)

      (send section-label
            get-section-label))

    (define/public
      (set-section-label new-label)

      (send section-label
            set-section-label
            new-label))

    (define/public
      (serialize)

      (cons 'section
            (list (send section-label
                        serialize)
                  (send rows
                        serialize))))

    (define/public
      (add-button name template clear)

      (send rows
            add-button
            name
            template
            clear))

    (define/public
      (add-row)

      (send rows
            add-row))

    (define/public
      (put-row row)

      (send rows
            put-row
            row))

    (define/public
      (re-parent-row row
                     section)

      (send (send this
                  get-parent)
            re-parent-row
            row
            section))))
