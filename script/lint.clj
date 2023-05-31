(ns lint
  (:require [babashka.cli :as cli]
            [babashka.process :refer [shell]]
            [clojure.pprint :as pprint]
            [clojure.string :as str]
            [shared :as shared]))

(def cli-options (shared/cli-options))

(def lua-globals
  "Known 'good' global namespaces in the Project Zomboid codebase"
  ["Events"
   "ISMoveableDefinitions"])

(defn lint!
  "Lints code (output to console) & returns whether lint! passed"
  [{:keys [target]}]
  (println "===> Beginning script/lint of QuestsBaseTeleporters...")
  (shell {:continue true} (str "luacheck " target " --new-globals " (str/join " " lua-globals))))

(defn help []
  (println "Lints codefiles in QuestsBaseTeleporters. Requires 'luacheck' on PATH.\nSupported options:")
  (->> (dissoc cli-options :workdir)
       (shared/cli-options->tablemaps)
       (pprint/print-table)))

(defn -main
  [& _]
  (println "")
  (let [cli-opts (cli/parse-opts *command-line-args* {:spec cli-options})]
    (cond
      (:help cli-opts) (help)
      :else (lint! cli-opts)))
  (println ""))
