use zed::settings::LspSettings;
use zed_extension_api as zed;

struct SouffleExtension;

impl SouffleExtension {
    fn java_binary(&self, worktree: &zed::Worktree) -> Result<String, String> {
        if let Some(java_path) = worktree.which("java") {
            return Ok(java_path);
        }

        match worktree
            .shell_env()
            .iter()
            .find(|(key, _)| key == "JAVA_HOME")
        {
            Some((_, home)) => Ok(format!("{home}/bin/java")),
            None => Err("Could not find `java`: put it on your PATH or set JAVA_HOME".to_string()),
        }
    }

    fn jar_path(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<String, String> {
        let configured_jar = LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .ok()
            .and_then(|settings| settings.settings)
            .and_then(|value| {
                value
                    .get("jar_path")
                    .and_then(|v| v.as_str())
                    .map(str::to_string)
            });

        match configured_jar {
            Some(jar) => Ok(jar),
            None => self.download_jar(language_server_id),
        }
    }

    fn download_jar(
        &mut self,
        language_server_id: &zed::LanguageServerId,
    ) -> Result<String, String> {
        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        let release = zed::latest_github_release(
            "jdaridis/souffle-lsp-plugin",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;
        let asset = release
            .assets
            .iter()
            .find(|&asset| asset.name.ends_with(".jar"))
            .ok_or("no .jar asset found in release")?;

        let version_dir = format!("souffle-lsp-{}", release.version);
        let jar_path = format!("{version_dir}/{}", asset.name);

        if !std::fs::metadata(&jar_path).map_or(false, |m| m.is_file()) {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            std::fs::create_dir_all(&version_dir).map_err(|e| e.to_string())?;
            zed::download_file(
                &asset.download_url,
                &jar_path,
                zed::DownloadedFileType::Uncompressed,
            )?;
        }

        // Hand `java` an absolute path because it runs with the project as its CWD
        // and the relative download path won't resolve.
        let jar_path = std::fs::canonicalize(&jar_path).map_err(|e| e.to_string())?;
        Ok(jar_path.to_string_lossy().into_owned())
    }
}

impl zed::Extension for SouffleExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> zed::Result<zed::Command> {
        let java_bin = self.java_binary(worktree)?;
        let jar = self.jar_path(language_server_id, worktree)?;
        Ok(zed::Command {
            command: java_bin,
            args: vec!["-jar".to_string(), jar],
            env: worktree.shell_env(),
        })
    }
}

zed::register_extension!(SouffleExtension);
