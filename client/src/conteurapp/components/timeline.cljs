(ns conteurapp.components.timeline
  (:require [keechma.ui-component :as ui]))

(defn render
  [ctx]
  (fn []
    (let [event-sub (ui/subscription ctx :events)]
      [:ul {:class "event-list"}
       (map 
         (fn [item]
           [:li {:key (:id item) :class "event-item"} (:title item)])
         @event-sub)])))

(def component
  (ui/constructor
    {:renderer render
     :subscription-deps [:events]}))
