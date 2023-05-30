(require '[babashka.cli :as cli]
         '[babashka.fs :as fs])

(def cli-options {:port {:default 80 :coerce :long}
                  :target {:default "build/" :coerce :string}
                  :help {:coerce :boolean}})

(defn build!
  [_cli-opts]
  (let [workdir (fs/cwd)
        steam-workshop-wrapper (str workdir "/steamworkshop")
        dest (str workdir "/build/QuestsBaseTeleporters")
        src (str workdir "/src")]
    (fs/delete-tree dest)
    (fs/create-dir dest)
    (fs/copy-tree steam-workshop-wrapper dest {:replace-existing true})
    (fs/copy-tree src (str dest "/Contents/mods/QuestsBaseTeleporters"))))

(def help-text
  (str "Babashka script to build QuestsBaseTeleporters.
Set --target directory or defaults to " (:default (:target cli-options))))

(let [{:keys [port target arg]
       :as cli-opts} (cli/parse-opts *command-line-args* {:spec cli-options})]
  (cond
    (:help cli-opts) (prn help-text)
    :else (build! cli-opts)))
