(define (create-client-thread! platform client)
  (create-thread
   #f
   (lambda ()
     (let loop ()
       (when-available
        ((client 'raw-event-receiver)) ;; This may be blocking
        (lambda (raw-event)
	  (let ((event (make-event platform raw-event)))
            ;; TODO: put in queue instead and have a thread that handles all events in that queue
            ;; (display (string ";; Got " platform " event: ")) (write raw-event) (newline)
	    (display (string "Main received " platform " event " event)) (newline)
	    (handle-event! event))))
       (loop)))
   (symbol platform '-thread)))
	 
(for-each (lambda (pair)
	    (let ((platform (car pair))
		  (client (cdr pair)))
	      (create-client-thread! platform client)))
	  *all-clients*)
