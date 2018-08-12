;; This file is part of cyanide-org-integration.
;;
;; cyanide-org-integration is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; cyanide-org-integration is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along with
;; cyanide-org-integration.  If not, see <http://www.gnu.org/licenses/>.

(require 'cyanide-project)

(defclass cyanide-org-project (cyanide-project)
  ((org-files :initarg :org-files
              :initform '("org/notes.org" "org/documentation.org")
              :type list)
   (org-agenda-files :initarg :org-files
                     :initform '("org/todo.org")
                     :type list)
   (org-capture-templates :initarg :org-capture-templates
                          :type list
                          :initform
'`(("n" "Note"
 entry
 (file+headline ,(concat (cyanide-project-oref :path)  "org/notes.org")
                ,(concat (cyanide-project-oref :display-name)  " Notes"))
 "* %U %^{Note}
%?")

("d" "Documentation"
 entry (file+headline ,(concat (cyanide-project-oref :path)
                               "org/documentation.org")
                      ,(concat (cyanide-project-oref :display-name)
                               " Documentation"))
 "* %^{Headline}
%?
Last updated: %U")

("t" "To Do"
 entry (file+headline ,(concat (cyanide-project-oref :path)
                               "org/todo.org")
                      ,(concat (cyanide-project-oref :display-name)
                               " To Do"))
"* TO DO [\#C] %T %^{To Do}
")))))

(defun cyanide-org-project-builder (kwargs)
  "Constructor for `cyanide-org-project'."
  (cyanide-kwargobj-builder 'cyanide-org-project
                            kwargs
                            '(:id
                              :display-name
                              :default-view
                              :path)
                            'cyanide-project-collection))

;; Temporarily bind org-capture-templates to a project-local value, and then
;; revert the binding to preserve its previous value. This allows org to operate
;; on templates defined in a cyanide-project init file.
(defun cyanide-org-capture ()
  (interactive)
  (if (and cyanide-current-project
           (slot-exists-p (cyanide-get-current-project) 'org-capture-templates))
      (progn (when (bound-and-true-p org-capture-templates)
               (setq org-capture-templates-orig org-capture-templates))
             (setq org-capture-templates (eval
                                          (cyanide-project-oref
                                           :org-capture-templates)))
             (org-capture)
             (if (bound-and-true-p org-capture-templates-orig)
                 (setq org-capture-templates org-capture-templates-orig)
               (makunbound 'org-capture-templates))
             (makunbound 'org-capture-templates-orig))
    (org-capture))) ; else

(provide 'cyanide-org-integration)
