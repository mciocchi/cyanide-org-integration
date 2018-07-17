# cyanide-org-integration

## About

  The goal of cyanide-org-integration is to provide a simple and smooth
  interface to use [Org Mode](http://orgmode.org/) templates from a CyanIDE
  project.

  cyanide-org-integration provides a great advantage because it allows users to
  generate templates that are "project aware:" all properties of a
  cyanide-project are made available for users in their templates.

  cyanide-org-integration by default stores notes, documentation, and "to do"
  entries inside of an "org" folder in the root of the currently active project.

## Installation Instructions:

### Dependencies:

CyanIDE - refer to the documentation for [CyanIDE](https://github.com/mciocchi/cyanide "CyanIDE")
for installation instructions

### Configuration

The following snippet is an example illustrating how to enable org mode
integration for a CyanIDE project:

```
(require 'cyanide)
(require 'cyanide-org-integration)
(define-key cyanide-mode-map (kbd "C-c c c") 'cyanide-org-capture)

(cyanide-org-project :id 'dot-emacs
                     :display-name "dot-emacs"
                     :default-view 'cyanide-minimal-view
                     :load-hook '((lambda ()
                                  (dired (cyanide-project-oref :path))))
                     :tasks '()
                     :teardown-hook '()
                     :path "~/.emacs.d/")
```
