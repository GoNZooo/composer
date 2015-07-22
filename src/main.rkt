#lang racket/gui

(require racket/pretty

         gonz/gui-helpers

         "parameters.rkt"
         "loader.rkt"
         "gui/auto-save-frame.rkt"
         "gui/add-section-dialog.rkt"
         "gui/parent-manipulation.rkt")

(define (main-window)
  (define top-frame (new auto-save-frame%
                         [label "Invoker 1.0.2 [2015-07-21]"]
                         [alignment '(center top)]
                         [style (window-style)]))

  (define built-in-panel (new horizontal-panel%
                              [parent top-frame]
                              [alignment '(center top)]))

  (define edit-mode-notifier #f)
  (define edit-mode-notifier-extra #f)
  (define edit-mode-notifier-panel #f)

  (define (notifier-switch)
    (if (null? (send edit-mode-notifier-panel
                     get-children))
      (begin 
        (child+ edit-mode-notifier-panel
                edit-mode-notifier)
        (child+ edit-mode-notifier-panel
                edit-mode-notifier-extra))
      (begin
        (child- edit-mode-notifier-panel
                edit-mode-notifier)
        (child- edit-mode-notifier-panel
                edit-mode-notifier-extra))))

  (define add-section-dialog
    (new add-section-dialog%
         [parent top-frame]
         [label "Add section"]))

  (btn edit-mode-switch built-in-panel "Edit-mode"
       (lambda (button event)
         (edit-mode (not (edit-mode)))
         (notifier-switch)))

  (btn iconize-window built-in-panel "Iconize window"
       (lambda (button event)
         (send top-frame iconize #t)))

  (btn clear-clipboard built-in-panel "Clear clipboard"
       (lambda (button event)
         (send the-clipboard
               set-clipboard-string
               ""
               (send event get-time-stamp))))

  (btn add-button built-in-panel "Add section"
       (lambda (b e)
         (send add-section-dialog show #t)))

  (set! edit-mode-notifier-panel
    (new vertical-panel%
         [parent top-frame]
         [alignment '(center top)]))

  (set! edit-mode-notifier
    (new message%
         [parent edit-mode-notifier-panel]
         [label "Edit mode is currently on"]
         [style '(deleted)]
         [font (make-object font%
                            12
                            'modern)]))

  (set! edit-mode-notifier-extra
    (new message%
         [parent edit-mode-notifier-panel]
         [label "(click on component to edit)"]
         [style '(deleted)]
         [font (make-object font%
                            11
                            'modern)]))

  (define template-content-panel (make-components (call-with-input-file
                                                    "components.blob"
                                                    read)
                                                  top-frame))
  (send top-frame
        set-template-content-panel
        template-content-panel)

  (define (components)
    (serialize-object template-content-panel))

  (define (save-components [filename "components.blob"])
    (write-components-to-file (components) 
                              filename))

  (send top-frame set-auto-save-callback save-components)

  (define (print-components [frame top-frame])
    (pretty-print (components)))

  (send top-frame show #t)
  top-frame)

(define (serialize-object object)
  (send object serialize))

(define (write-components-to-file components [filename "components.blob"])
  (call-with-output-file
    filename
    (lambda (output-port)
      (pretty-write components output-port))
    #:exists 'replace))

(define top-frame (main-window))
