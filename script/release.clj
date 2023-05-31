(ns release
  (:require [babashka.cli :as cli]
            [babashka.fs :as fs]
            [clojure.pprint :as pprint]
            [shared :as shared]))

(defn cli-options []
  (let [zomboid-workshop (fs/expand-home "~/Zomboid/Workshop")]
    (merge (shared/cli-options)
           {:zomboid-workshop {:default zomboid-workshop :coerce :string}
            :qbt-workshop {:default (str zomboid-workshop "/QuestsBaseTeleporters")
                           :coerce :string}})))

(defn release!
  [{:keys [target
           zomboid-workshop
           qbt-workshop] :as cli-opts}]
  (prn target zomboid-workshop qbt-workshop)
  (assert (fs/exists? zomboid-workshop) "Zomboid Workshop directory exists")
  (fs/delete-tree qbt-workshop)
  (fs/create-dir qbt-workshop)
  (fs/copy-tree target qbt-workshop)
  qbt-workshop)

(defn help []
  (println "Babashka script to release QuestsBaseTeleporters.")
  (->> (dissoc cli-options :workdir)
       (shared/cli-options->tablemaps)
       (pprint/print-table))
  (println ""))

(defn -main
  [& _]
  (let [cli-opts (cli/parse-opts *command-line-args* {:spec (cli-options)})]
    (cond
      (:help cli-opts) (help)
      :else (release! cli-opts))))
