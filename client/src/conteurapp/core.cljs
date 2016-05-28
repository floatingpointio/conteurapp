(ns conteurapp.core
  (:require [keechma.app-state :as app-state]
            [conteurapp.controllers.timeline :as timeline]
            [conteurapp.controllers.calpicker :as calpicker]
            [conteurapp.components :as components]
            [conteurapp.subscriptions :as subscriptions]))

(enable-console-print!)

(def app-definition
  {:routes [["", {:page "calpicker"}]
            ":page/:id"]
   :controllers {:calpicker (calpicker/->Controller)
                 :timeline (timeline/->Controller)}
   :components components/system
   :subscriptions subscriptions/subscriptions
   :html-element (.getElementById js/document "app")})
 
(defonce running-app (clojure.core/atom))

(defn start-app! []
  (reset! running-app (app-state/start! app-definition)))

(defn restart-app! []
  (let [current @running-app]
    (if current
      (app-state/stop! current start-app!)
      (start-app!))))

(restart-app!)

(defn on-js-reload []
  ;; optionally touch your app-state to force rerendering depending on
  ;; your application
  ;; (swap! app-state update-in [:__figwheel_counter] inc)
)
