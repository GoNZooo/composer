#lang racket/gui

(require "../parameters.rkt"
         "edit-button-dialog.rkt")

(provide movable-button%)
(define movable-button%
  (class button%
    (super-new)

    (init-field clear
                template
                name)

    (define/public
      (move direction)

      (send (send this get-parent) move-child this direction))

    (define inner-edit-button-dialog #f)

    (define/override
      (on-subwindow-event receiver event)

      (cond
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down)
              (send event get-shift-down)
              (send event get-control-down))
         (begin
           (set! inner-edit-button-dialog
             (new edit-button-dialog%
                  [label "Edit button"]
                  [parent #f]
                  [edited-button this]
                  [sections (send (send this get-parent)
                                  get-sections)]
                  [top-level-window (send this get-top-level-window)]))
           (send inner-edit-button-dialog
                 show #t))]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'left-down))
         (move 'left)]
        [(and (edit-mode)
              (equal? (send event get-event-type)
                      'right-down))
         (move 'right)]
        [else #f]))

    (define/public
      (get-template)

      template)

    (define (ensure-newlines str)
      (cond
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
        (send the-x-selection-clipboard
              set-clipboard-string
              template
              timestamp)
        (let ([current-content (send the-x-selection-clipboard
                                     get-clipboard-string
                                     timestamp)])
          (string-append (ensure-newlines current-content)
                         template))))

    (define/public
      (get-button-label)

      (send this get-label))

    (define/public
      (get-clear)
      
      clear)

    (define/public
      (get-section)
      
      (send (send this get-parent)
            get-section))

    (define/public
      (set-name n)
      
      (set! name n))

    (define/public
      (set-template t)
      
      (set! template t))

    (define/public
      (set-clear c)
      
      (set! clear c))

    (define/public
      (serialize)

      (if clear
        `(button ,(send this get-label) ,template clear)
        `(button ,(send this get-label) ,template)))))
