# AI Agents Guidelines

This document provides instructions for AI Agents working with the implementations of this Terraform module template.

## Template Guidelines
- **Avoid In place Modification** for implementations terraform-module-template is a template repository should not contain implementations.
- **Use Separate Repository for Implementations**: Implementations should be stored in separate repositories to maintain modularity and version control.
  - New repositories should be named in a way that reflects their purpose and functionality, prefixed with `terraform-module-` followed by the cloud provider (e.g., `terraform-module-aws`, `terraform-module-gcp`, `terraform-module-azurerm`).
  - This template repository should be used as a boilerplate for new implementations.
  - Use GitHub Flow way of work for template and implementation repositories.
- **Supported Providers**:
 - AWS
 - GCP
 - Azure
 - MongoDB Atlas
 - Github
- **Not a template when:** under the following conditions, the repository is not a template 
  - The repository contains a `versions.tf` file at the root level, indicating that it has been initialized for a specific provider.
  - The repository has a `.cloudopsworks/.provider` file indicating the current provider in use.

## Implementation Repository Guidelines

- **Use the `tronador` CLI**: All commands should be run from the root of the repository. The `Makefile` is deprecated for `repos/*`, `fmt`, `lint` and `readme` — use the CLI for those. Only the operations the CLI does not implement remain `make`-based (see [Tronador CLI Coverage](#tronador-cli-coverage)).
- **Avoid modifying**: Avoid modifying the following: 
  - Any files originating from the cloud provider boilerplate (e.g., `aws.tf`, `google.tf`, `azurerm.tf`, `variables-azurerm.tf`, `locals.tf`) in `.cloudopsworks/boilerplate/` (except `versions.tf`).
  - Anything under `.cloudopsworks/boilerplate/`
  - `locals-vars.tf`, `variables.tf`, `AGENTS.md`, `CLAUDE.md`, `.github/**`, `Makefile`, `.gitignore`, `gitversion.yaml`
- **Use variables-module.tf**:
  - Rename the word `module` in `variables-module.tf` with a proper subname depending on the purpose of this module.
  - The subname must be no more than 12 chars (e.g., `variables-vpc.tf`).
- **Initialization**:
  - This template must be initialized on the target cloud provider using the `tronador` CLI.
  - For AWS: `tronador project init aws`
  - For GCP: `tronador project init gcp`
  - For Azure: `tronador project init azurerm`
  - For MongoDB Atlas: `tronador project init mongodb`
  - For Github: `tronador project init github`
  - The initialization process for each cloud will copy its boilerplate files to the root module.
  - If a `versions.tf` file exists (e.g., from `.cloudopsworks/boilerplate/aws`, `gcp`, `azurerm`, or any other supported provider), the module is already initialized and under development.
  - You can check the current provider in `.cloudopsworks/.provider`.
  - You can modify `versions.tf` to include additional providers to help with the resolution of your task.
- **Avoid creating spurious configuration files**:
    - Do not create any configuration files that are not required for the task at hand.
    - Only create files that are necessary for the specific functionality being implemented.
    - Do not create provider files or provider initialization implementation at all.
- **Locals management**:
  - Do not create local variables that are not used in the module.
  - Keep local variable names descriptive and consistent with the module's purpose.
  - Use locals to encapsulate complex expressions and improve readability.
- **Documentation**: See [Documentation Guidelines](#documentation-guidelines) section below.
- **Variables**:
  - Honor structured variables instead of lots of simple variables.
  - Prefer to have a single settings variable for simplicity and maintainability.
  - Use descriptive variable names that reflect their purpose.
  - Avoid using magic numbers and constants directly in code.
- **Mandatory Header**: Each .tf file must start with the following copyright header:
  ```hcl
  ##
  # (c) 2021-2026
  #     Cloud Ops Works LLC - https://cloudops.works/
  #     Find us on:
  #       GitHub: https://github.com/cloudopsworks
  #       WebSite: https://cloudops.works
  #     Distributed Under Apache v2.0 License
  #
  ```
- **Outputs**:
  - Place all module outputs in `outputs.tf` at the root of the module.
  - Every `outputs.tf` must start with the mandatory copyright header.
  - Provide a `description` for every output — no empty descriptions.
  - Mark outputs containing secrets or tokens with `sensitive = true`.
  - Export specific attributes, not entire resource objects (e.g., prefer `resource.this.id` over `resource.this`).
  - Use `snake_case` names consistent with the module's variable naming.
  - Group related outputs together with a blank line between groups.
  - Avoid outputs that duplicate inputs unless the provider transforms the value.
- **Formatting, Validation & Linting**:
  - Formatting: `tronador project format` (alias `tronador project fmt`)
  - Validation & Linting: `tronador project lint` (alias `tronador project validate`)
  - Both accept `--workdir <dir>`, `--json`, `--dry-run`, and `--engine tofu|terraform|auto`. Run `tronador project capabilities` to list what the detected implementation supports.
- **Repository Management**
  - Use process as described in the contributing guidelines: [GitHub Flow](https://cloudopsworks.co/resources/githubflow-way-of-work/)


## Versioning Management

Module versioning follows GitHub Flow — a simplified branching model where feature branches are created from and merged back into `master`. Branch and release operations are `make`-only — the `tronador` CLI does not cover `gitflow/*`.
- There is a skill related to this template module and their implementations, it can be found in the [Claude Code Skills - cw-release](https://github.com/cloudopsworks/claude-code-skills/tree/main/cw-release) can be used in any agent anyway, install and use it.

### General Rules

- **Never push directly to `master`**. All changes must flow through feature or hotfix branches and be merged via pull requests.
- Branches must be created before any change is committed.
- Follow [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`) for all module tags.
- There is no `develop` branch — all work flows directly through feature branches to `master`. This approach simplifies the development workflow and enables continuous integration and deployment from the main branch.
- Avoid in the commit comments explicitly mentioning `+semver:` changes within changesets, describe it with other words. The semver annotations should only be present in commit messages and PR descriptions to trigger the correct version bump in CI.
- Avoid scrubbing into Makefile or tronador utility scripts.
- Use `make` targets for branch and release operations, which the CLI does not cover.

<a id="tronador-cli-coverage"></a>
- **Use the `tronador` CLI.** The `Makefile` is deprecated for the `repos/*`, `fmt`, `lint` and `readme` families — the tables below map each retired `make` target to its CLI replacement. Only the operations listed as not covered remain `make`-based. All CLI commands accept the `--dry-run` and `--verbose` global flags plus a `--workdir <dir>` scoping flag.

  **Repository template lifecycle (`repos/*`)**

  | Deprecated `make` target       | `tronador` CLI replacement          |
  |--------------------------------|-------------------------------------|
  | `make repos/upgrade`           | `tronador repos upgrade`            |
  | `make repos/upgrade/major`     | `tronador repos upgrade major`      |
  | `make repos/upgrade/<version>` | `tronador repos upgrade <version>`  |
  | `make repos/upgrade/master`    | `tronador repos upgrade master`     |
  | `make repos/available`         | `tronador repos available`          |
  | `make repos/clean`             | `tronador repos clean`              |
  | `make repos/clean/template`    | `tronador repos clean template`     |
  | `make repos/push`              | `tronador repos push`               |
  | `make repos/recover`           | `tronador repos recover --pull-branch <ref>` |
  | `make repos/template/terraform-module` | `tronador repos template terraform-module` |
  | `make repos/template/init`     | `tronador repos template init`      |
  | `make repos/cicd/update`       | `tronador repos cicd update`        |

  **Project capabilities (`fmt`, `lint`, `init/*`)**

  Dispatched from the implementation marker under `.cloudopsworks/` — never through the Makefile.

  | Deprecated `make` target | `tronador` CLI replacement                     |
  |------------------------|--------------------------------------------------|
  | `make fmt`             | `tronador project format` (alias `fmt`)          |
  | `make lint`            | `tronador project lint` (alias `validate`)       |
  | `make init/<provider>` | `tronador project init <provider>`               |
  | —                      | `tronador project detect` — show detected implementation |
  | —                      | `tronador project capabilities` — list supported capabilities |

  **README generation (`readme/*`)**

  | Deprecated `make` target | `tronador` CLI replacement |
  |-------------------|---------------------------|
  | `make readme`     | `tronador readme build`   |
  | `make readme/lint`| `tronador readme lint`    |
  | `make readme/init`| `tronador readme init`    |
  | `make readme/deps`| `tronador readme deps`    |

  **Documentation generation (`docs/*`)**

  | Deprecated `make` target | `tronador` CLI replacement   |
  |--------------------------|------------------------------|
  | `make docs/targets.md`   | `tronador docs targets`      |
  | `make docs/terraform.md` | `tronador docs terraform`    |
  | `make docs/copyright-add`| `tronador docs copyright-add`|
  | —                        | `tronador docs init`         |

  **Not covered by the CLI — use `make`:** all `gitflow/*` targets (`gitflow/hotfix/start`, `gitflow/feature/start-no-develop:<name>`, `gitflow/*/publish`, `gitflow/*/finish`, `gitflow/version/tag`, `gitflow/version/publish`, `gitflow/version/semver`) and the `tag` / `tag_local` targets. Branch, tagging, and publish operations remain `make`-only. See [Pre-Release Tagging for Module Testing](#pre-release-tagging-for-module-testing-alpha--beta) for using `gitflow/version/tag` and `gitflow/version/publish` on a branch. `gitflow/version/file` is **not** part of any workflow in this repository — see [Version File (`_VERSION`)](#version-file).

  Two behavioural differences to be aware of when substituting the CLI for `make`:
  - `tronador project lint` runs `tofu validate` followed by `tofu fmt -check`. It does not run the provider-chomp step (`temp_provider`) or the `tofu/get-modules` + `tofu/get-plugins` pipeline, so fetch providers and modules first when linting a module that has not been initialised.
  - `tronador docs targets` still shells out to `make help` to enumerate targets, so a working Makefile is required for that one command.
- Use `gh` cli for PR merging and release management. If the `github-mcp-server` MCP is available in your environment, prefer its tools over the `gh` CLI for all GitHub operations (PR creation, merging, status checks, issue management).
  - When waiting for a PR status check to pass, use `gh pr checks <number> --watch` (or the equivalent `github-mcp-server` MCP tool if available)
- Plan consistently and thoroughly before starting any work.
- Do not finish or merge a feature or hotfix branch until it has been validated from a published pre-release tag — see [Release Gate](#release-gate).

### Semver Commit Annotations

To trigger the correct version bump in CI, include a semver annotation in your commit message or PR description:

| Change Type          | Annotation keywords                                     |
|----------------------|---------------------------------------------------------|
| Major / breaking     | `+semver: major` or `+semver: breaking`                 |
| Minor / feature      | `+semver: minor` or `+semver: feature`                  |
| Fix / patch          | `+semver: fix` or `+semver: patch` or `+semver: hotfix` |

> **Note:** `+semver: breaking` triggers a **MAJOR** bump. `.cloudopsworks/gitversion.yaml`
> puts it in `major-version-bump-message` alongside `major`, so there is no
> "minor-compatible breaking change" annotation — use `+semver: minor` for a change that is
> backwards compatible, and `+semver: major` or `+semver: breaking` for one that is not.
> Always confirm against the repository's own `major-version-bump-message` and
> `minor-version-bump-message` before relying on an annotation.

Example commit messages:
```
feat: add support for VPC endpoints +semver: minor
fix: correct IAM policy ARN +semver: fix
refactor!: remove deprecated outputs +semver: breaking   # MAJOR
```

### Module Dependency Management
- Honor git submodules for module dependencies with ref to the latest release tag possible.
- Lookup for the latest version of each module dependency when updating the submodule, specially under feature branches.
- Note that the `tronador repos upgrade` command will pull the latest template version, but it does not automatically update module dependencies. Always check and update submodule references as needed when upgrading the template or making significant changes.

### New Module Features and Provider Version Upgrades

All new features and provider version upgrades branch directly from `master` using the no-develop targets:

1. Create a feature branch from `master`:
   ```sh
   make gitflow/feature/start-no-develop:<feature-name>
   ```
2. Implement changes and validate:
   ```sh
   tronador project format
   tronador project lint
   ```
3. **Publish first** — the tag and finish steps both require the branch to exist on the remote:
   ```sh
   make gitflow/feature/publish:<feature-name>   # push branch to remote
   ```
4. Cut a pre-release tag and test the branch before finishing:
   ```sh
   make gitflow/version/tag       # -> v<x.y.z>-alpha.N
   make gitflow/version/publish   # push that tag
   ```
   See [Pre-Release Tagging for Module Testing](#pre-release-tagging-for-module-testing-alpha--beta).
5. Satisfy the [Release Gate](#release-gate), then finish — this creates the PR:
   ```sh
   make gitflow/feature/finish-no-develop:<feature-name>
   ```
6. After the PR is merged: in an implementation repository CI tags the release automatically; in **this template repository** cut it locally with `make gitflow/version/tag && make gitflow/version/publish` from an up-to-date `master`.

For provider upgrades, increment the semver digit accordingly: **MAJOR** for breaking provider changes (e.g., AWS `4.x` → `5.x`), **MINOR** for backwards-compatible upgrades.

### Workflow Version Upgrades and Documentation Fixes (Patch)

Workflow upgrades and documentation-only fixes are patch-level changes and use the **hotfix** branch type, not feature branches:

1. Start a hotfix branch from `master`:
   ```sh
   make gitflow/hotfix/start
   ```
2. Apply changes (run the template upgrade, then update docs as needed):
   ```sh
   tronador repos upgrade   # pulls latest template version
   # edit .boilerplate/inputs.yaml, README.yaml, etc.
   tronador readme build    # regenerate README.md last
   ```
3. Commit using conventional commits with `+semver: patch`:
   ```sh
   git commit -m "docs: sync inputs.yaml and update docs +semver: patch"
   ```
4. **Publish first** — the tag and finish steps both require the branch to exist on the remote:
   ```sh
   make gitflow/hotfix/publish   # push branch to remote
   ```
5. When the hotfix touches module code, cut a pre-release tag and test it before finishing:
   ```sh
   make gitflow/version/tag       # -> v<x.y.z>-beta.N
   make gitflow/version/publish   # push that tag
   ```
   See [Pre-Release Tagging for Module Testing](#pre-release-tagging-for-module-testing-alpha--beta). Documentation-only hotfixes may record the gate as not applicable.
6. Satisfy the [Release Gate](#release-gate), then finish — this creates the PR:
   ```sh
   make gitflow/hotfix/finish
   ```
7. Wait for all CI checks to pass, then merge with `gh` CLI (see [PR Merge Guidelines](#pr-merge-guidelines)).
8. In **this template repository only**, cut the release tag locally once the PR is merged and `master` is pulled — the merge-tagging workflow does not run here:
   ```sh
   git checkout master && git pull origin master
   make gitflow/version/tag && make gitflow/version/publish
   ```

<a id="version-file"></a>
### Version File (`_VERSION`)

`.cloudopsworks/_VERSION` (or `.github/_VERSION` on the `v5.9` workflow generation) records
the **template generation** this repository was last upgraded from. `tronador repos upgrade`
writes it, and parses the MAJOR and MINOR digits back out of it to resolve which template tag
to pull next.

**Only `cloudopsworks/terraform-module-template` may write this file**, through its own
release process. In every repository generated from that template — that is, in every
implementation module — the file is **read-only**:

- Do not hand-edit it.
- Do not stage or commit it.
- Do not run `make gitflow/version/file`.
- A value that trails this repository's latest release tag is **correct**, not drift. The file
  names the template generation, not this module's version. Do not "repair" it.

Overwriting it with the module's own release version makes the next `tronador repos upgrade`
resolve against the wrong template tag series.

### Pre-Release Tagging for Module Testing (alpha / beta)

Feature and hotfix branches can publish **intermediate pre-release tags** so a module can be consumed and exercised from a real Terragrunt `ref=` before its PR is merged. This is the supported way to validate a module change end-to-end without cutting a final release.

**This applies to both this template repository and every implementation repository.** The mechanism is identical in both — `.cloudopsworks/gitversion.yaml` and `.github/workflows/release-management.yml` are part of the template and are carried into each implementation, so the branch labels, the counter behaviour, and the automatic GitHub pre-release work the same everywhere. The one difference is who cuts the **final** release tag on `master`:

| Repository                | Pre-release tag on a branch | Final release tag on `master`                                        |
|---------------------------|-----------------------------|----------------------------------------------------------------------|
| Implementation repository | run the commands manually   | automatic — `.github/workflows/pr-merge-tagging.yml` runs the same two targets after the PR merge |
| This template repository   | run the commands manually   | run the same two commands locally on `master` after merging the PR — Actions do not currently fire for pull-request or merge events here |

Pre-release tagging on a branch is always manual, in both cases.

The two targets CI runs on `master` after a PR merge also work on any branch — `gitflow/version/tag` simply switches which GitVersion variable it reads:

| Current branch      | GitVersion variable | Tag produced        |
|---------------------|---------------------|---------------------|
| `master` / `main`   | `MajorMinorPatch`   | `v1.6.56`           |
| `feature/<name>`    | `SemVer`            | `v1.6.56-alpha.1`   |
| `hotfix/<version>`  | `SemVer`            | `v1.6.56-beta.1`    |
| `release/<version>` | `SemVer`            | `v1.6.56-beta.1`    |

The `alpha` / `beta` label comes from the branch configuration in `.cloudopsworks/gitversion.yaml` and is selected by the **branch prefix**, not by intent. Use only the sanctioned prefixes — any other branch name falls through to the `unknown` configuration and yields a tag labelled with the branch name (e.g. `v1.6.56-chore-foo.1`).

#### Workflow

Ordering is strict: both targets abort unless the remote branch tip equals local `HEAD`, so the branch must be published before it can be tagged.

1. Commit the work on the feature or hotfix branch.
2. Push the branch — required, the tag step verifies remote/local parity:
   ```sh
   make gitflow/feature/publish:<feature-name>   # or, on a hotfix branch: make gitflow/hotfix/publish
   ```
3. Create the pre-release tag locally:
   ```sh
   make gitflow/version/tag
   ```
4. Push that tag:
   ```sh
   make gitflow/version/publish
   ```
5. Consume the tag from a test deployment:
   ```hcl
   terraform {
     source = "git::https://github.com/<owner>/<repo>.git//?ref=v1.6.56-alpha.1"
   }
   ```

Repeat steps 1–4 as often as needed. **The pre-release counter advances on its own** — GitVersion runs the `feature` and `hotfix` branches in `ManualDeployment` mode with `prevent-increment.when-current-commit-tagged: false`, so each run reads the previous tag and bumps:

```
(no tag yet)    ->  v1.6.56-alpha.1
after alpha.1   ->  v1.6.56-alpha.2
after alpha.2   ->  v1.6.56-alpha.3
```

No manual version bookkeeping is required, and no `+semver:` annotation is needed to advance the counter. The annotations continue to govern only the final `MAJOR.MINOR.PATCH` computed for `master`.

#### Deploy-targeted variant

`gitflow/version/tag/<meta>` produces the same version with build metadata appended, for pinning a build to a specific deploy target:

```sh
make gitflow/version/tag/<meta>   # -> v1.6.56-alpha.3+deploy-<meta>
make gitflow/version/publish
```

#### Agent Responsibilities

- When the user asks to **test, try out, validate, or dogfood a work-in-progress branch** before its PR is finished or merged, the agent must cut and push a pre-release tag with `make gitflow/version/tag` followed by `make gitflow/version/publish`, then report the resulting tag and the exact `ref=` string to use. Never tell the user to merge first in order to test — that is what the pre-release tag exists to avoid.
- Cutting a pre-release tag pushes to a public remote and creates a GitHub pre-release. Confirm with the user before running `make gitflow/version/publish` unless they have already asked for the tag.
- Never cut a pre-release from `master` — on `master` the same target produces a final release tag.
- After a pre-release tag is published, report it back in the form the operator will paste, e.g. `?ref=v1.6.56-alpha.2`.

#### Release Gate

A feature or hotfix branch must not be finished or merged until its changes have been exercised from a published pre-release tag.

Before running `make gitflow/feature/finish-no-develop` / `make gitflow/hotfix/finish`, and again before `gh pr merge`, verify:

1. A pre-release tag exists for the work under review — check with `git tag --list --points-at HEAD` and `git describe --tags`.
2. That tag has been deployed and exercised against a real target, and the outcome reported.
3. `tronador project format` and `tronador project lint` pass at the branch tip.
4. No untested commits sit after the last pre-release tag — `git log <last-tag>..HEAD` must be empty, or a fresh tag must be cut and re-tested.

Items 1, 2 and 4 may be recorded as not applicable when the module has no deployable test
target.

If the gate cannot be satisfied — for example the module has no deployable test target — say so explicitly in the PR description rather than skipping it silently.

#### Rules and caveats

- **Publish the branch first.** `gitflow/version/tag` and `gitflow/version/publish` both compare `git ls-remote <branch>` against local `HEAD`, and refuse with `You must be in the latest commit of the branch to tag` otherwise.
- **One tag per commit, then publish.** `gitflow/version/publish` pushes exactly one tag, resolved through `git describe --tags --abbrev=0`. Always pair tag and publish; never stack two tags on the same commit and expect both to be pushed.
- **Floating major/minor tags are never touched.** `make tag` / `tag_local` — which force-move `v1` and `v1.6` — check out `master` first and are a separate path. Consumers pinned to `?ref=v1` will never resolve to a pre-release.
- **Pre-release tags do not perturb the final release version.** `gitflow/version/tag` on `master` reads `MajorMinorPatch`, so merged `-alpha.N` / `-beta.N` tags never leak into the release tag and do not shift the version CI computes after the PR merge.
- **A GitHub pre-release is published automatically.** `.github/workflows/release-management.yml` triggers on `v[0-9]+.[0-9]+.[0-9]+**`, which matches pre-release tags, and forwards `is_pre_release` to the release step. Pushing an `-alpha.N` tag creates a GitHub Release flagged as a pre-release; it does not become "Latest".
- **Pre-release tags are not a substitute for the PR.** They exist for testing only — the final version is still cut by merging the PR into `master`.

### PR Merge Guidelines

> **Note:** If the `github-mcp-server` MCP is available in your environment, prefer its tools (e.g., `merge_pull_request`, `get_pull_request`, `list_pull_request_commits`) over the `gh` CLI commands below. The MCP server provides structured responses and integrates directly with the agent workflow.

After all CI checks pass, merge using `gh pr merge` with a proper merge commit:

```sh
gh pr merge <PR_NUMBER> --repo <owner/repo> --merge \
  --subject "chore: merge <branch> - <short description> +semver: patch" \
  --body "$(cat <<'EOF'
## Summary

- Bullet point summary of changes

+semver: patch
EOF
)" --delete-branch=false
```

Key rules:
- Confirm the [Release Gate](#release-gate) is satisfied before merging — the branch must have been exercised from a published pre-release tag.
- Always use `--merge` (never `--squash` or `--rebase`) to preserve commit history.
- Include `+semver: <level>` in the **body** (not just the title) so GitVersion picks it up.
- Use `--delete-branch=false` when you only want to delete the local branch (do so separately with `git branch -d <branch>`).
- After merge, checkout and pull master: `git checkout master && git pull origin master`.

### Summary Table

> **Command column:** use the `tronador` CLI. The `Makefile` is deprecated for `repos/*`, `fmt`, `lint` and `readme`; only `gitflow/*` targets remain `make`-only.

| Change Type                                      | Branch Type | Merges Into | Command                 | Semver Impact | Annotation                          |
|--------------------------------------------------|-------------|-------------|-------------------------|---------------|-------------------------------------|
| Workflow version upgrade (patch)                 | `hotfix`    | `master`    | `tronador repos upgrade` | PATCH         | `+semver: patch`                    |
| Workflow version upgrade (minor)                 | `feature`   | `master`    | `tronador repos upgrade` | MINOR         | `+semver: minor`                    |
| Workflow version upgrade (major)                 | `feature`   | `master`    | `tronador repos upgrade major` | MAJOR      | `+semver: major`                    |
| Documentation fix / inputs.yaml sync            | `hotfix`    | `master`    | —                       | PATCH         | `+semver: patch`                    |
| Provider major version upgrade                   | `feature`   | `master`    | —                       | MAJOR         | `+semver: major`                    |
| Provider minor/patch version upgrade             | `feature`   | `master`    | —                       | MINOR / PATCH | `+semver: minor` / `+semver: patch` |
| New module feature                               | `feature`   | `master`    | —                       | MINOR         | `+semver: feature`                  |
| Bug fix                                          | `feature`   | `master`    | —                       | PATCH         | `+semver: fix`                      |
| Intermediate pre-release for module testing      | `feature` / `hotfix` | — (not merged) | `make gitflow/version/tag` + `make gitflow/version/publish` | PRE-RELEASE   | — (counter auto-advances)           |
| Breaking / incompatible change                   | `feature`   | `master`    | —                       | MAJOR         | `+semver: major` or `+semver: breaking` |


## Documentation Guidelines

> Act as an expert documentation professional and Terraform/Terragrunt DevOps expert.
> Generated documentation must be human-legible; tables are encouraged for clarity.

- **Source file**: Documentation is maintained in `README.yaml`. Inner sections may use Markdown formatting.
- **Badges**:
  - If the module has a public repository, include badges for Latest Release and Last Updated, linking to the appropriate GitHub owner/repo.
  - Locate it between the `name` or `logo` and `license` fields.
  - Template:
    ```yaml
    badges:
      - name: Latest Release
        image: https://img.shields.io/github/release/<owner/repo>.svg?style=for-the-badge
        url: https://github.com/<owner/repo>/releases/latest
      - name: Last Updated
        image: https://img.shields.io/github/last-commit/<owner/repo>.svg?style=for-the-badge
        url: https://github.com/<owner/repo>/commits
    ```
- **Inline variable documentation**:
  - Complete inline documentation in `variables-module.tf` (or its renamed equivalent; there may be multiple `variables-*.tf` files).
  - Document each variable attribute in YAML format within the variable declaration block.
  - After each attribute, add a comment indicating whether it is `(Required)` or `(Optional)`, a short description, and the default value when applicable. Example:
    ```yaml
    id: "sampleid"   # (Required) Unique identifier for the resource.
    ```
    - If the attribute is a complex object, document as a YAML block before the variable declaration as commented lines.
    - For attributes that accept a predefined set of values (e.g., `state` with possible values `present` or `absent`), include a comment listing the valid options.
    - Description must contain the marker of optionality and default value. Avoid embedding complex YAML descriptions, make a general description, then add the specifics in the comments.
  - Infer and document the possible values for each attribute using the upstream Terraform provider documentation as the source.
- **README.yaml fields**: Once inline documentation is complete, update `README.yaml` to properly document the following fields:
  - `name`
  - `description`
  - `introduction`
  - `usage` — write examples using Terragrunt HCL; avoid plain Terraform HCL.
    - Lead with the Terragrunt scaffolding workflow (see [Terragrunt Scaffolding in Usage Examples](#terragrunt-scaffolding-in-usage-examples) below).
    - After scaffolding, show the resulting `inputs.yaml` with all module-specific variables from `.boilerplate/inputs.yaml`, fully commented per the `(Required)`/`(Optional)` style.
    - Show the rendered `terragrunt.hcl` as generated by scaffold — including the `locals` block that loads `inputs.yaml` as `local.local_vars` and the `inputs` block mapping each variable. Do not hand-author the `terragrunt.hcl` from scratch; represent what scaffold produces.
    - Include all module variables with their full inline-documented YAML structure mirroring `.boilerplate/inputs.yaml`.
  - `examples` and `quickstart`
- **Updates**: Apply the same criteria above whenever new variables or resources are added to the module.
  - copyrights.year: if not specified or blank, set "2021", should be an year not a range, if there is a year specified leave it as is.
  - badges: adjust the badge.image links to point to the correct repository (owner/repo).
- **README.md generation**: Run `tronador readme build` as the **last step** after all documentation updates are complete.

### Terragrunt Scaffolding in Usage Examples

When documenting `usage` in `README.yaml`, the example must show operators how to bootstrap a new deployment using Terragrunt's built-in scaffold command. See the official reference: https://docs.terragrunt.com/reference/cli/commands/scaffold

Rules:
- **Never use `--working-dir`** — it is not a valid flag for the scaffold command.
- **Always create the target directory first** before running scaffold. Scaffold writes its output into the current working directory, so the operator must create and enter it beforehand.
- The scaffold command sources `.boilerplate/boilerplate.yml` to generate `terragrunt.hcl`, `inputs.yaml`, and `local-tags.json` in the target directory.

**Canonical scaffolding workflow to include in `usage`:**

```sh
# 1. Create and enter the target deployment directory
mkdir -p <environment>/<region>/<spoke>/<module-name>
cd <environment>/<region>/<spoke>/<module-name>

# 2. Scaffold the module (do NOT use --working-dir)
terragrunt scaffold github.com/<owner>/<repo>

# 3. Edit inputs.yaml with deployment-specific values
#    (all keys and comments are pre-populated from .boilerplate/inputs.yaml)
vi inputs.yaml

# 4. Apply
terragrunt apply
```

After the commands, include an annotated example of the generated `inputs.yaml` (using the exact keys and `(Required)`/`(Optional)` comments from `.boilerplate/inputs.yaml`) and the generated `terragrunt.hcl` showing how `local.local_vars` wires `inputs.yaml` into the `inputs` block.

### `.boilerplate/inputs.yaml` Guidelines

The `.boilerplate/inputs.yaml` file is the per-deployment configuration file loaded by `terragrunt.hcl` as `local.local_vars`. It must be kept in sync with the module's `variables-*.tf` files and serve as self-documenting configuration for operators.

- **Scope**: Include **all** module-specific variables — those defined in `variables-module.tf` (or its renamed equivalent variables-*.tf).
  - Include **both scalar top-level variables** (e.g., `name`, `name_prefix`, `project_id`, `run_hoop`) **and** complex object variables (e.g., `settings`). A common mistake is to only document the complex object and forget the plain scalars.
  - Do **not** include variables that the Terragrunt hierarchy supplies automatically:
    - `is_hub` — injected by the boilerplate/template engine
    - `spoke_def` — sourced from `spoke-inputs.yaml`
    - `org` — sourced from `env-inputs.yaml`
    - `extra_tags` — built from merged tag files
- **Comment format**: Mirror the `(Required)` / `(Optional)` YAML comment style used in `variables-*.tf`. For every key, add an inline comment with:
  - Whether it is required or optional
  - A short description
  - The default value and any notes on valid values or format
  - Example values where helpful
  - **Avoid** embedding any go-template syntax, for example, do not include `{{ env "ORG" }}` in the comment. Instead, describe the expected value and source (e.g., "Organization ID, sourced from env-inputs.yaml").
- **Complex objects**: Expand all sub-keys of object variables (e.g., `settings`) as commented lines, even when the default is `{}`. This makes all available options visible to the operator without them needing to read the Terraform source.
- **Module transformations**: If the module transforms an input value before passing it to the provider (e.g., converting a region string to uppercase-underscore format for the Atlas API), document both the expected input format and the resulting API value in the comment.
- **Sync on change**: Whenever a variable is added, removed, or modified in `variables-*.tf`, update `.boilerplate/inputs.yaml` accordingly in the same commit.
- **Scaffolding output**: This file is the template that `terragrunt scaffold` copies into new deployment directories. Every key, comment, and default must be accurate — operators fill in values here without reading the Terraform source.