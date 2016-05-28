(ns conteurapp.components
  (:require [conteurapp.components.app :as app]
            [conteurapp.components.timeline :as timeline]
            [conteurapp.components.calpicker :as calpicker]))

(def system
  {:main app/component
   :timeline timeline/component
   :calpicker calpicker/component})
