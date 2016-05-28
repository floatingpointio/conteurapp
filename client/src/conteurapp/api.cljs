(ns conteurapp.api
  (:require [ajax.core :refer [GET]]))

(defn error-handler [{:keys [status status-text]}]
  (.log js/console (str "something bad happened: " status " " status-text)))

(defn get-timeline [calendar-id cb]
  (GET (str "http://dev.conteurapp.com/api/events?calendar_id=" calendar-id)
       {:handler cb
        :error-handler error-handler
        :response-format :json
        :keywords? true}))

(defn get-calendars [cb]
  (GET (str "http://dev.conteurapp.com/api/calendars")
       {:handler cb
        :error-handler error-handler
        :response-format :json
        :keywords? true}))

