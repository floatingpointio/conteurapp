(ns conteurapp.components.app
  (:require [keechma.ui-component :as ui]))

(defn render
  [ctx]
  (fn []
    (let [page (get-in @(ui/current-route ctx) [:data :page])]
      (case page
        "timeline" [(ui/component ctx :timeline)]
        "calpicker" [(ui/component ctx :calpicker)]
        [:div page]))))

(def component
  (ui/constructor
   {:renderer render
    :component-deps [:calpicker :timeline]}))
