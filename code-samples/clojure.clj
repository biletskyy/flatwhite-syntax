(ns com.stuartsierra.component.platform
  "Platform-specific implementation details for Component on
  Clojure(JVM). This is not a public API.")

(set! *warn-on-reflection* true)

(defn argument-error [^String message]
  (IllegalArgumentException. message))

(defn type-name
  "Returns a string name for the type/class of x."
  [x]
  (let [t (type x)]
    (if (class? t)
      (.getName ^Class t)
      (str t))))

(defn alter-ex-data
  "Returns a new ExceptionInfo with the same details as throwable and
  ex-data as the result of (apply f (ex-data throwable) args)."
  [^Throwable throwable f & args]
  (let [^Throwable ex
        (ex-info (.getMessage throwable)
                 (apply f (ex-data throwable) args)
                 (.getCause throwable))]
    ;; .getStackTrace should never be null, but .setStackTrace
    ;; doesn't allow null, so we'll be careful
    (when-let [stacktrace (.getStackTrace throwable)]
      (.setStackTrace ex stacktrace))
    ex))


(ns com.clojurebook.url-shortener
  (:use [compojure.core :only (GET PUT POST defroutes)])
  (:require (compojure handler route)
            [ring.util.response :as response]))


(def ^:private counter (atom 0))

(def ^:private mappings (ref {}))

(defn url-for
  [id]
  (@mappings id))

(defn shorten!
 "Stores the given URL under a new unique identifier, or the given identifier
  if provided.  Returns the identifier as a string.
  Modifies the global mapping accordingly."
 ([url]
  (let [id (swap! counter inc)
        id (Long/toString id 36)]
    (or (shorten! url id)
        (recur url))))
 ([url id]
  (dosync
    (when-not (@mappings id)
      (alter mappings assoc id url)
      id))))

(defn retain
  [& [url id :as args]]
  (if-let [id (apply shorten! args)]
    {:status 201
     :headers {"Location" id}
     :body (format "URL %s assigned the short identifier %s" url id)}
    {:status 409 :body (format "Short URL %s is already taken" id)}))

(defn redirect
  [id]
  (if-let [url (url-for id)]
    (response/redirect url)
    {:status 404 :body (str "No such short URL: " id)}))

(defroutes app*
  (GET "/" request "Welcome!")
  (PUT "/:id" [id url] (retain url id))
  (POST "/" [url] (if (empty? url)
                    {:status 400 :body "No `url` parameter provided"}
                    (retain url)))
  (GET "/:id" [id] (redirect id))
  (GET "/list/" [] (interpose "\n" (keys @mappings)))
  (compojure.route/not-found "Sorry, there's nothing here."))

(def app (compojure.handler/api app*))

;; ; To run locally:
;; (use '[ring.adapter.jetty :only (run-jetty)])
;; (def server (run-jetty #'app {:port 8080 :join? false}))
