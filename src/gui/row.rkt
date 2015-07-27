#lang racket/gui

(require "../parameters.rkt"
         "parent-manipulation.rkt"
         "movable-button.rkt"
         "edit-row-dialog.rkt")

(provide row%)
(define row%
  (class horizontal-panel%
    (super-new)

    (init-field buttons)

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
                [clear #t]
                [callback
                  (lambda (button event)
                    (send button
                          copy-to-clipboard
                          (send event
                                get-time-stamp)))])]
          [(list 'button name text)
           (new movable-button%
                [parent this]
                [label name]
                [name name]
                [template text]
                [clear #f]
                [callback
                  (lambda (button event)
                    (send button
                          copy-to-clipboard
                          (send event
                                get-time-stamp)))])]
          ['() '()]))

      (map make-button
           bs))

    (set! buttons
      (make-buttons buttons))

    (define/public
      (move-child child direction)

      (set! buttons
        (case direction
          [(left)
           (move-left child
                      buttons)]
          [(right)
           (move-right child
                       buttons)]
          [else
            #f]))
      (set-children buttons))

    (define/public
      (get-sections)

      (send (send this
                  get-parent)
            get-sections))

    (define/public
      (get-section)

      (send (send this
                  get-parent)
            get-section))

    (define/public
      (add-button name template clear)

      (define new-button
        (new movable-button%
             [parent this]
             [label name]
             [name name]
             [template template]
             [callback
               (lambda (button event)
                 (send button
                       copy-to-clipboard
                       (send event
                             get-time-stamp)))]
             [clear clear]))

      (set! buttons
        (cons new-button
              buttons))
      (set-children buttons)
      new-button)

    (define/public
      (add-reparented-button new-button)
      
      (set! buttons
        (cons new-button
              buttons)))

    (define/public
      (remove-reparented-button old-button)
      
      (set! buttons
        (filter (lambda (b)
                  (not (eqv? b
                             old-button)))
                buttons)))

    (define/public
      (remove-button button)

      (set! buttons
        (filter (lambda (b)
                  (not (eqv? b
                             button)))
                buttons))
      (set-children buttons))

    (define/public
      (move direction)

      (send (send this
                  get-parent)
            move-child
            this
            direction))

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event
                            get-event-type)
                      'left-down)
              (equal? buttons
                      '()))
         (begin
           (set! inner-edit-row-dialog
             (new edit-row-dialog%
                  [parent #f]
                  [label "Edit row"]
                  [edited-row this]
                  [top-level-window (send this
                                          get-top-level-window)]
                  [sections (get-sections)]))
           (send inner-edit-row-dialog
                 show
                 #t))]
        [else #f]))

    (define/public
      (re-parent-button button
                        direction)

      (send (send this
                  get-parent)
            re-parent-button
            button
            direction))

    (define/public
      (re-parent-row direction)

      (send (send this
                  get-parent)
            re-parent-row
            this
            direction))

    (define/public
      (serialize)

      (cons 'row
            (map (lambda (child)
                   (send child
                         serialize))
                 (send this
                       get-children))))))
