(defproject conteurapp "0.1.0-SNAPSHOT"
  :description "TodoMVC implemented in Keechma"
  :url "http://github.com/floatingpointio/conteurapp"
  :license {:name "MIT"}

  :min-lein-version "2.5.3"
  
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [org.clojure/clojurescript "1.7.170"]
                 [org.clojure/core.async "0.2.374" :exclusions [org.clojure/tools.reader]]
                 [cljs-ajax "0.5.3"]
                 [keechma "0.1.0-SNAPSHOT"]]
  
  :plugins [[lein-figwheel "0.5.0-6"]
            [lein-cljsbuild "1.1.2" :exclusions [[org.clojure/clojure]]]
            [michaelblume/lein-marginalia "0.9.0"]]

  :source-paths ["src"]

  :clean-targets ^{:protect false} ["resources/public/js/compiled" "target"]

  :cljsbuild {:builds
              [{:id "dev"
                :source-paths ["src"]

                :figwheel {:on-jsload "conteurapp.core/on-js-reload"}

                :compiler {:main conteurapp.core
                           :asset-path "js/compiled/out"
                           :output-to "resources/public/js/compiled/conteurapp.js"
                           :output-dir "resources/public/js/compiled/out"
                           :source-map-timestamp true}}

               {:id "min"
                :source-paths ["src"]
                :compiler {:output-to "resources/public/js/compiled/conteurapp.js"
                           :main conteurapp.core
                           :optimizations :advanced
                           :pretty-print false}}]}

  :figwheel {:css-dirs ["resources/public/css"]})
