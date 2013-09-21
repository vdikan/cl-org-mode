(in-package :cl-org-mode)


(defun mapc-nodes-preorder (fn node &aux (seen (make-hash-table :test 'eq)))
  (labels ((rec (node)
             (unless (gethash node seen)
               (setf (gethash node seen) t)
               (dolist (child (node.out node))
                 (funcall fn node)
                 (rec child)))))
    (rec node)))

(defun mapc-leaf-nodes (fn node &aux (seen (make-hash-table :test 'eq)))
  (labels ((rec (node)
             (unless (gethash node seen)
               (setf (gethash node seen) t)
               (if-let ((child (node.out node)))
                       (dolist (c child)
                         (rec c))
                       (funcall fn node)))))
    (rec node)))

(defun mapc-edges-preorder (fn node &aux (seen (make-hash-table :test 'equal)))
  (labels ((rec (from to)
             (unless (gethash (cons from to) seen)
               (setf (gethash (cons from to) seen) t)
               (funcall fn from to)
               (dolist (to-to (node.out to))
                 (rec to to-to)))))
    (dolist (child (node.out node))
      (rec node child))))

(defmacro do-nodes-preorder ((node graph) &body body)
  `(mapc-nodes-preorder (lambda (,node)
                          ,@body)
                        ,graph))

(defmacro do-leaf-nodes ((node graph) &body body)
  `(mapc-leaf-nodes (lambda (,node)
                  ,@body)
                ,graph))

(defmacro do-edges-preorder ((from to graph) &body body)
  `(mapc-edges-preorder (lambda (,from ,to)
                          ,@body)
                        ,graph))