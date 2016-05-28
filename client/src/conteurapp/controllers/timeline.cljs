(ns conteurapp.controllers.timeline
  (:require [keechma.controller :as controller :refer [dispatcher]]
            [cljs.core.async :refer [<!]]
            [conteurapp.api :refer [get-timeline]]
            [conteurapp.edb :as edb]
            [conteurapp.entities.event :as event])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(defn connect-socketio
  [app-db-atom]
  (let [conn (.-socket js/window)
        channel (.channel conn "data:events", #js{})
        channel-conn (.join channel)]
    (.log js/console conn channel channel-conn)
    (.receive channel-conn "ok" (fn [resp]
                                  (.log js/console "OK: " resp)))
    (.on channel "new_event" (fn [resp] 
                               (reset! app-db-atom
                                        (edb/append-collection @app-db-atom :events :list [(js->clj resp :keywordize-keys true)]))))
                                                          ; (.log js/console "MSG: " resp)))
    (.receive channel-conn "error" (fn [resp]
                                     (.log js/console "ERROR: " resp)))))

(defn load-events [app-db-atom id]
  (let [app-db @app-db-atom]
    (get-timeline id 
                  #(reset! app-db-atom (edb/insert-collection app-db :events :list (:data %))))))

(defn updater!
  [modifier-fn]
  (fn [app-db-atom args]
    (swap! app-db-atom modifier-fn args)))

(defrecord
  Controller []
  controller/IController
  (params [_ route-params] 
    (when (= (get-in route-params [:data :page]) "timeline")
      (get-in route-params [:data :id])))
  (start [this id app-db]
    (controller/execute this :load-events id)
    (edb/insert-collection app-db :events :list []))
  (handler [_ app-db-atom in-chan _]
    (connect-socketio app-db-atom)
    (dispatcher app-db-atom in-chan {:load-events load-events})))
