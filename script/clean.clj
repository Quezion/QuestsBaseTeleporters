(ns clean
  (:require [babashka.cli :as cli]
            [babashka.fs :as fs]
            [clojure.pprint :as pprint]
            [shared :as shared]))

(def cli-options (shared/cli-options))

(def help-text
  (str "Cleans --target directory. Defaults to " (:default (:target cli-options))))

(defn clean!
  [{:keys [target]}]
  (println "Cleaning target directory at" target)
  (fs/delete-tree target))

(defn help []
  (println "\nCleans target build direcetory. Supported options:")
  (->> (dissoc cli-options :workdir)
       (shared/cli-options->tablemaps)
       (pprint/print-table))
  (println ""))

(defn -main
  [& _]
  (let [{:keys [target]
         :as cli-opts} (cli/parse-opts *command-line-args* {:spec cli-options})]
    (cond
      (:help cli-opts) (help)
      :else (clean! cli-opts))))