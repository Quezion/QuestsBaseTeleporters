(ns build
  (:require [babashka.cli :as cli]
            [babashka.fs :as fs]
            [clean :refer [clean!]]
            [clojure.pprint :as pprint]
            [clojure.string :as str]
            [lint :refer [lint!]]
            [shared :as shared]))

(def cli-options (let [{:keys [workdir] :as opts} (shared/cli-options)]
                   (merge opts
                          {:steam-workshop {:default (str (:default workdir) "/steamworkshop") :coerce :string}
                           :src {:default (str (:default workdir) "/src") :coerce :string}})))

(defn build!
  [{:keys [src steam-workshop target workdir] :as cli-opts}]
  (println "===> Beginning script/build of QuestsBaseTeleporters <===")
  (println "Working directory is" (str workdir))
  (clean! {:target target})
  (lint! {:target (str workdir "/src")})
  (println "")
  (println "Building library... [src steamworkshop target]")
  (prn [src steam-workshop target])
  (fs/create-dir target)
  (fs/copy-tree steam-workshop target {:replace-existing true})
  (fs/copy-tree src (str target "/Contents/mods/QuestsBaseTeleporters"))
  (println "===> Build complete <==="))

(defn help []
  (println "Builds QuestsBaseTeleporters. Supported options:")
  (->> (dissoc cli-options :workdir)
       (shared/cli-options->tablemaps)
       (pprint/print-table)))

(defn -main
  [& _]
  (println "")
  (let [cli-opts (cli/parse-opts *command-line-args* {:spec cli-options})]
    (cond
      (:help cli-opts) (help)
      :else (build! cli-opts)))
  (println ""))