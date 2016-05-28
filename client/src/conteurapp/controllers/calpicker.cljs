(ns conteurapp.controllers.calpicker
  (:require [keechma.controller :as controller :refer [dispatcher]]
            [cljs.core.async :refer [<!]]
            [conteurapp.api :refer [get-calendars]]
            [conteurapp.edb :as edb]
            [conteurapp.entities.calendar :as calendar])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(defn load-calendars [app-db-atom]
  (let [app-db @app-db-atom]
    (get-calendars (fn [data]
                     (reset! app-db-atom
                             (edb/insert-collection @app-db-atom :calendars :list (:data data)))))))

(defrecord
  Controller []
  controller/IController
  (params [_ route-params] 
    (when (= (get-in route-params [:data :page]) "calpicker")
      true))
  (start [this params app-db]
    (controller/execute this :load-calendars)
    app-db)
  (handler [_ app-db-atom in-chan _]
    (dispatcher app-db-atom in-chan {:load-calendars load-calendars})))
