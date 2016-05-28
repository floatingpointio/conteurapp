(ns conteurapp.subscriptions
  (:require [conteurapp.edb :as edb]
            [conteurapp.entities.event :as event]
            [conteurapp.entities.calendar :as calendar])
  (:require-macros [reagent.ratom :refer [reaction]]))

(defn calendars
  [app-db]
  (reaction
   (let [db @app-db]
     (edb/get-collection db :calendars :list))))

(defn events
  [app-db]
  (reaction
   (let [db @app-db]
     (edb/get-collection db :events :list))))

(def subscriptions {:events events :calendars calendars})
