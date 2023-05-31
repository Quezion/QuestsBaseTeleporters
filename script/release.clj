(ns release
  (:require [babashka.cli :as cli]
            [babashka.fs :as fs]
            [clojure.pprint :as pprint]
            [shared :as shared]))

(def cli-options (merge (shared/cli-options)
                        {:zomboid-workshop {:default "/" :coerce :string}}))

(defn release!
  [_cli-opts]
  (println "TODO: Actually implement release copy-tree & watch on mod.info"))

(defn help []
  (println "Babashka script to release QuestsBaseTeleporters.")
  (->> (dissoc cli-options :workdir)
       (shared/cli-options->tablemaps)
       (pprint/print-table))
  (println ""))

(defn -main
  [& _]
  (let [cli-opts (cli/parse-opts *command-line-args* {:spec cli-options})]
    (cond
      (:help cli-opts) (help)
      :else (release! cli-opts))))
