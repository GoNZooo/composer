#lang racket/gui

(require "../parameters.rkt"
         "edit-button-dialog.rkt")

(provide movable-button%)
(define movable-button%
  (class button%
    (init label)
    (super-new [label ""])
    (send this
          set-label
          label)

    (init-field clear
                template
                name)
    
    (define/override
      (set-label new-label)
      
      ; Fetch the old label
      (define prev-text (send this
                              get-label))

      ; Fetch the total button size of the old button
      (define prev-button-width (send this
                                      min-width))
      (define prev-button-height (send this
                                       min-height))

      ; Fetch the size of the text that was in the button
      (define-values (prev-text-width prev-text-height)
        (get-window-text-extent prev-text
                                normal-control-font
                                #t))

      ; Calculate how much extra space is used; "extra"
      (define width-extra (- prev-button-width
                             prev-text-width))
      (define height-extra (- prev-button-height
                              prev-text-height))

      ; Calculate the size of the new text
      (define-values (new-text-width new-text-height)
        (get-window-text-extent new-label
                                normal-control-font
                                #t))

      ; Set the label
      (super set-label
             new-label)
      ; Set the new min-width and min-height for the button
      ; by adding the size of the new text and the 'extra'
      (send this
            min-width
            (+ width-extra
               new-text-width))
      (send this
            min-height
            (+ height-extra
               new-text-height)))

    (define/public
      (move direction)

      (send (send this
                  get-parent)
            move-child
            this
            direction))

    (define inner-edit-button-dialog #f)

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (begin
           (set! inner-edit-button-dialog
             (new edit-button-dialog%
                  [label "Edit button"]
                  [parent #f]
                  [edited-button this]
                  [sections (send (send this
                                        get-parent)
                                  get-sections)]
                  [top-level-window (send this
                                          get-top-level-window)]))
           (send inner-edit-button-dialog
                 show #t))]
        [else #f]))

    (define/public
      (get-template)

      template)

    (define/public
      (get-button-label)

      (send this
            get-label))

    (define/public
      (get-clear)

      clear)

    (define/public
      (get-section)

      (send (send this
                  get-parent)
            get-section))

    (define/public
      (set-name n)

      (set! name
        n)
      (send this
            set-label
            name))

    (define/public
      (get-name)

      name)

    (define/public
      (set-template t)

      (set! template
        t))

    (define/public
      (set-clear c)

      (set! clear
        c))

    (define/public
      (set-button-values label
                         template
                         clear)
      
      (set-label label)
      (set-template template)
      (set-clear clear))

    (define (ensure-newlines str)
      (cond
        [(equal? str "")
         ""]
        [(equal? (substring str
                            (- (string-length str)
                               2))
                 "\n\n")
         str]
        [(equal? (substring str
                            (sub1 (string-length str)))
                 "\n")
         (string-append str
                        "\n")]
        [else
          (string-append str
                         "\n\n")]))

    (define/public
      (copy-to-clipboard timestamp)

      (if clear
        (send the-clipboard
              set-clipboard-string
              template
              timestamp)
        (let ([current-content (send the-clipboard
                                     get-clipboard-string
                                     timestamp)])
          (send the-clipboard
                set-clipboard-string
                (string-append (ensure-newlines current-content)
                               template)
                timestamp))))

    (define/public
      (re-parent-button direction)

      (send (send this
                  get-parent)
            re-parent-button
            this
            direction))

    (define/public
      (serialize)

      (if clear
        `(button ,(send this get-label)
                 ,template clear)
        `(button ,(send this get-label)
                 ,template)))))
