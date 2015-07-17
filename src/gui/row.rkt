#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "movable-button.rkt"
         "edit-row-dialog.rkt")

(provide row%)
(define row%
  (class horizontal-panel%
    (super-new)

    (init buttons)

    (define inner-edit-row-dialog #f)

    (define (set-children cs)
      (send this
            change-children
            (lambda (children)
              cs)))

    (define (make-buttons bs)
      (define (make-button b)
        (match b
          [(list 'button name text clear)
           (new movable-button%
                [parent this]
                [label name]
                [name name]
                [template text]
                [clear #t])]
          [(list 'button name text)
           (new movable-button%
                [parent this]
                [label name]
                [name name]
                [template text]
                [clear #f])]
          ['() '()]))

      (map make-button bs))

    (define inner-buttons (make-buttons buttons))

    (define/public
      (move-child child direction)

      (set! inner-buttons (case direction
                            [(left) (move-left child inner-buttons)]
                            [(right) (move-right child inner-buttons)]
                            [else #f]))
      (set-children inner-buttons))

    (define/public
      (get-sections)
      
      (send (send this get-parent)
            get-sections))

    (define/public
      (get-section)
      
      (send (send this get-parent)
            get-section))

    (define/public
      (add-button name template clear)
      
      (set! inner-buttons (cons (new movable-button%
                                     [parent this]
                                     [label name]
                                     [name name]
                                     [template template]
                                     [clear clear])
                                inner-buttons))
      (set-children inner-buttons))

    (define/public
      (remove-button button)

      (set! inner-buttons
        (filter (lambda (b)
                  (not (eqv? b
                             button)))
                inner-buttons))
      (set-children inner-buttons))

    (define/public
      (move direction)

      (send (send this get-parent) move-child this direction))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? inner-buttons '())
              (send event get-shift-down)
              (send event get-control-down))
         (begin
           (set! inner-edit-row-dialog
             (new edit-row-dialog%
                  [parent this]
                  [label "Edit row"]
                  [edited-row this]))
           (send inner-edit-row-dialog
                 show
                 #t))]
        [else #f]))

    (define/public
      (serialize)

      (cons 'row (map (lambda (child)
                        (send child serialize))
                      (send this get-children))))))
