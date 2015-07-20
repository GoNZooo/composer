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

    (define inner-buttons (make-buttons buttons))

    (define/public
      (move-child child direction)

      (set! inner-buttons
        (case direction
          [(left)
           (move-left child
                      inner-buttons)]
          [(right)
           (move-right child
                       inner-buttons)]
          [else
            #f]))
      (set-children inner-buttons))

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

      (set! inner-buttons
        (cons new-button
              inner-buttons))
      (set-children inner-buttons)
      new-button)

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
              (equal? inner-buttons
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

    (define (replace-button button
                            name
                            template
                            clear
                            [buttons inner-buttons]
                            [replaced-button #f]
                            [new-buttons '()])
      (cond
        [(null? buttons)
         (values replaced-button
                 (reverse new-buttons))]
        [(eqv? button
               (car buttons))
         (let ([new-button (new movable-button%
                                [parent this]
                                [label name]
                                [name name]
                                [template template]
                                [clear clear])])
           (replace-button button
                           name
                           template
                           clear
                           (cdr buttons)
                           new-button
                           (cons new-button
                                 new-buttons)))]

        [else
          (let ([new-button (new movable-button%
                                 [parent this]
                                 [label (send (car buttons)
                                              get-label)]
                                 [name (send (car buttons)
                                             get-name)]
                                 [template (send (car buttons)
                                                 get-template)]
                                 [clear (send (car buttons)
                                              get-clear)])])
            (replace-button button
                            name
                            template
                            clear
                            (cdr buttons)
                            replaced-button
                            (cons new-button
                                  new-buttons)))]))

    (define/public
      (recreate-button button
                       name
                       template
                       clear)

      (define-values
        (new-button new-buttons)
        (replace-button button
                        name
                        template
                        clear))
      (send this
            begin-container-sequence)
      (set! inner-buttons new-buttons)
      (set-children inner-buttons)
      (send this
            end-container-sequence)
      new-button)

    (define/public
      (re-parent-button button
                        direction)

      (send (send this get-parent)
            re-parent-button
            button
            direction))

    (define/public
      (re-parent-row direction)

      (send (send this get-parent)
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
