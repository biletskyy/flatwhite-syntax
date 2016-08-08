; Conway's Game of Life, based on the work of:
;; Laurent Petit https://gist.github.com/1200343
;; Christophe Grand http://clj-me.cgrand.net/2011/08/19/conways-game-of-life

(ns ^{:doc "Conway's Game of Life."}
 game-of-life)

;; Core game of life's algorithm functions

(defn neighbours
  "Given a cell's coordinates, returns the coordinates of its neighbours."
  [[x y]]
  (for [dx [-1 0 1] dy (if (zero? dx) [-1 1] [-1 0 1])]
    [(+ dx x) (+ dy y)]))

(defn step
  "Given a set of living cells, computes the new set of living cells."
  [cells]
  (set (for [[cell n] (frequencies (mapcat neighbours cells))
             :when (or (= n 3) (and (= n 2) (cells cell)))]
         cell)))

;; Utility methods for displaying game on a text terminal

(defn print-board
  "Prints a board on *out*, representing a step in the game."
  [board w h]
  (doseq [x (range (inc w)) y (range (inc h))]
    (if (= y 0) (print "\n"))
    (print (if (board [x y]) "[X]" " . "))))

(defn display-grids
  "Prints a squence of boards on *out*, representing several steps."
  [grids w h]
  (doseq [board grids]
    (print-board board w h)
    (print "\n")))

;; Launches an example board

(def
  ^{:doc "board represents the initial set of living cells"}
   board #{[2 1] [2 2] [2 3]})


(ns com.clojurebook.url-shortener
  (:require (compojure handler route)
            [ring.util.response :as response]))

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
