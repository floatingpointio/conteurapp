(ns conteurapp.entities.event
  (:require [conteurapp.edb :as edb])
  (:import [goog.ui IdGenerator]))

(def id-generator (IdGenerator.))

(defn id
  "Returns a new ID for the event."
  []
  (.getNextUniqueId id-generator))

(defn is-active?
  "Is a event in active state?"
  [event]
  (:completed event))

(defn has-title?
  "Checks if the event title is an empty string."
  [event]
  (pos? (count (clojure.string/trim (:title event)))))

(defn create-event
  "Creates a new event and adds it to a events list if
  the event has a non empty title."
  [app-db title]
  (let [event {:id (str "event" (id))
              :completed false
              :title title}]
    (if (has-title? event)
      (edb/prepend-collection app-db :events :list [event])
      app-db)))

(defn edit-event
  "Saves the id of the event that is being edited."
  [app-db event]
  (assoc-in app-db [:kv :editing-id] (:id event)))

(defn cancel-edit-event
  "Clears the id of the currently edited event."
  [app-db]
  (assoc-in app-db [:kv :editing-id] nil))

(defn update-event
  "Updates the event with new data if the event has a non empty title."
  [app-db event]
  (if (has-title? event)
    (-> app-db
        (cancel-edit-event)
        (edb/update-item-by-id :events (:id event) event))
    app-db))

(defn destroy-event
  "Removes the event from the EntityDB."
  [app-db event]
  (edb/remove-item app-db :events (:id event)))

(defn toggle-event
  "Toggles the `:completed` status."
  [app-db event]
  (update-event app-db (assoc event :completed (not (:completed event)))))

(defn events-by-status
  "Returns the events for a status."
  [app-db status]
  (let [events (edb/get-collection app-db :events :list)]
    (case status
      :completed (filter is-active? events)
      :active (filter (complement is-active?) events)
      events)))

(defn toggle-all
  "Marks all events as active or completed based on the `status` argument."
  [app-db status]
  (let [event-ids (map :id (events-by-status app-db :all))]
    (reduce #(edb/update-item-by-id %1 :events %2 {:completed status}) app-db event-ids)))

(defn destroy-completed
  "Removes all completed events from the EntityDB."
  [app-db]
  (let [completed-events (events-by-status app-db :completed)
        completed-events-ids (map :id completed-events)]
    (reduce #(edb/remove-item %1 :events %2) app-db completed-events-ids)))
