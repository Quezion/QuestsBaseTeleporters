(ns shared
  (:require [babashka.fs :as fs]))

(def _cli-options (atom nil))

(defn cli-options
  []
  (if-let [v @_cli-options]
    v
    (let [workdir (fs/cwd)
          opts {:workdir {:default workdir :coerce :string}
                :target {:default (str workdir "/build/QuestsBaseTeleporters") :coerce :string}
                :help {:coerce :boolean}}]
      (reset! _cli-options opts)
      opts)))

(defn cli-options->tablemaps
  "Casts CLI-Options map into sequence of maps appropriate for pprint/print-table"
  [cli-options]
  (reduce (fn [acc [k v]] (conj acc {:name k
                                     :default (if (= :boolean (:coerce v))
                                                (or (:default v) false)
                                                (:default v))
                                     :type (:coerce v)})) [] cli-options))