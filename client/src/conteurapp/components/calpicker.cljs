(ns conteurapp.components.calpicker
  (:require [keechma.ui-component :as ui]))

(defn render
  [ctx]
  (fn []
    (let [calendar-sub (ui/subscription ctx :calendars)]
      [:ul {:class "calendar-list"}
       (map 
         (fn [item]
           [:li {:key (:id item) :class "calendar-item"}
            [:a {:href (ui/url ctx {:page "timeline" :id (:id item)})} (:title item)]])
         @calendar-sub)])))

(def component
  (ui/constructor
    {:renderer render
     :subscription-deps [:calendars]}))
