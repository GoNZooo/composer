#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "section-label.rkt"
         "section-rows.rkt")

(provide section%)
(define section%
  (class vertical-panel%
    (super-new)

    (init rows)
    (init-field section-label)

    (define inner-section-label (new section-label%
                                     [parent this]
                                     [label section-label]
                                     [alignment '(center top)]))

    (define inner-section-rows (new section-rows%
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

      section-label)

    (define/public
      (set-section-label label)

      (set! section-label
        label))

    (define/public
      (serialize)

      (cons 'section
            (list (send inner-section-label serialize)
                  (send inner-section-rows serialize))))

    (define/public
      (add-button name template clear)
      
      (send inner-section-rows
            add-button name template clear))

    (define/public
      (add-row)
      
      (send inner-section-rows
            add-row))

    (define/public
      (put-row row)
      
      (send row
            reparent
            inner-section-rows))
    
    (define/public
      (re-parent-row row
                     section)
      
      (send (send this
                  get-parent)
            re-parent-row
            row
            section))))
