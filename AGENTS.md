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

- **Use make as provided**: All commands should be run from the root of the repository.
- **Avoid modifying**: Avoid modifying the following: 
  - Any files originating from the cloud provider boilerplate (e.g., `aws.tf`, `google.tf`, `azurerm.tf`, `variables-azurerm.tf`, `locals.tf`) in `.cloudopsworks/boilerplate/` (except `versions.tf`).
  - Anything under `.cloudopsworks/boilerplate/`
  - `locals-vars.tf`, `variables.tf`, `AGENTS.md`, `CLAUDE.md`, `.github/**`, `Makefile`, `.gitignore`, `gitversion.yaml`
- **Use variables-module.tf**:
  - Rename the word `module` in `variables-module.tf` with a proper subname depending on the purpose of this module.
  - The subname must be no more than 12 chars (e.g., `variables-vpc.tf`).
- **Initialization**:
  - This template must be initialized on the target cloud provider using `Makefile`.
  - For AWS: `make init/aws`
  - For GCP: `make init/gcp`
  - For Azure: `make init/azurerm`
  - For MongoDB Atlas: `make init/mongodb`
  - For Github: `make init/github`
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
  - Formatting: `make fmt`
  - Validation & Linting: `make lint`
- **Repository Management**
  - Use process as described in the contributing guidelines: [GitHub Flow](https://cloudopsworks.co/resources/githubflow-way-of-work/)


## Versioning Management

Module versioning follows GitHub Flow — a simplified branching model where feature branches are created from and merged back into `master`. Use `make` targets whenever available for branch and release operations.
- There is a skill related to this template module and their implementations, it can be found in the [Claude Code Skills - cw-release](https://github.com/cloudopsworks/claude-code-skills/tree/main/cw-release) can be used in any agent anyway, install and use it.

### General Rules

- **Never push directly to `master`**. All changes must flow through feature or hotfix branches and be merged via pull requests.
- Branches must be created before any change is committed.
- Follow [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`) for all module tags.
- There is no `develop` branch — all work flows directly through feature branches to `master`. This approach simplifies the development workflow and enables continuous integration and deployment from the main branch.
- Avoid in the commit comments explicitly mentioning `+semver:` changes within changesets, describe it with other words. The semver annotations should only be present in commit messages and PR descriptions to trigger the correct version bump in CI.
- Avoid scrubbing into Makefile or tronador utility scripts.
- Use `make` targets whenever available for branch and release operations.
- Use `gh` cli for PR merging and release management.
  - When waiting for a PR status check to pass, use `gh pr checks <number> --watch`
- Plan consistently and thoroughly before starting any work.

### Semver Commit Annotations

To trigger the correct version bump in CI, include a semver annotation in your commit message or PR description:

| Change Type        | Annotation keywords                                           |
|--------------------|---------------------------------------------------------------|
| Major change only  | `+semver: major`                                              |
| Minor / feature    | `+semver: minor` or `+semver: feature` or `+semver: breaking` |
| Fix / patch        | `+semver: fix` or `+semver: patch` or `+semver: hotfix`       |

> **Note:** `+semver: breaking` triggers a **MINOR** bump (per GitVersion config), not MAJOR. Use `+semver: major` explicitly for breaking/incompatible changes that require a MAJOR version bump.

Example commit messages:
```
feat: add support for VPC endpoints +semver: minor
fix: correct IAM policy ARN +semver: fix
refactor!: remove deprecated outputs +semver: breaking
```

### Module Dependency Management
- Honor git submodules for module dependencies with ref to the latest release tag possible.
- Lookup for the latest version of each module dependency when updating the submodule, specially under feature branches.
- Note that the `make repos/upgrade` command will pull the latest template version, but it does not automatically update module dependencies. Always check and update submodule references as needed when upgrading the template or making significant changes.

### New Module Features and Provider Version Upgrades

All new features and provider version upgrades branch directly from `master` using the no-develop targets:

1. Create a feature branch from `master`:
   ```sh
   make gitflow/feature/start-no-develop:<feature-name>
   ```
2. Implement changes and validate:
   ```sh
   make fmt
   make lint
   ```
3. **Publish first**, then finish — the finish step requires the branch to exist on the remote:
   ```sh
   make gitflow/feature/publish:<feature-name>         # push branch to remote (required before finish)
   make gitflow/feature/finish-no-develop:<feature-name>  # creates the PR
   ```

For provider upgrades, increment the semver digit accordingly: **MAJOR** for breaking provider changes (e.g., AWS `4.x` → `5.x`), **MINOR** for backwards-compatible upgrades.

### Workflow Version Upgrades and Documentation Fixes (Patch)

Workflow upgrades and documentation-only fixes are patch-level changes and use the **hotfix** branch type, not feature branches:

1. Start a hotfix branch from `master`:
   ```sh
   make gitflow/hotfix/start
   ```
2. Apply changes (run `make repos/upgrade` for template upgrades, then update docs as needed):
   ```sh
   make repos/upgrade   # pulls latest template version
   # edit .boilerplate/inputs.yaml, README.yaml, etc.
   make readme          # regenerate README.md last
   ```
3. Commit using conventional commits with `+semver: patch`:
   ```sh
   git commit -m "docs: sync inputs.yaml and update docs +semver: patch"
   ```
4. **Publish first**, then finish — the finish step requires the branch to exist on the remote:
   ```sh
   make gitflow/hotfix/publish   # push branch to remote (required before finish)
   make gitflow/hotfix/finish    # creates the PR
   ```
5. Wait for all CI checks to pass, then merge with `gh` CLI (see [PR Merge Guidelines](#pr-merge-guidelines)).

### PR Merge Guidelines

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
- Always use `--merge` (never `--squash` or `--rebase`) to preserve commit history.
- Include `+semver: <level>` in the **body** (not just the title) so GitVersion picks it up.
- Use `--delete-branch=false` when you only want to delete the local branch (do so separately with `git branch -d <branch>`).
- After merge, checkout and pull master: `git checkout master && git pull origin master`.

### Summary Table

| Change Type                                      | Branch Type | Merges Into | Make Target             | Semver Impact | Annotation                          |
|--------------------------------------------------|-------------|-------------|-------------------------|---------------|-------------------------------------|
| Workflow version upgrade (patch)                 | `hotfix`    | `master`    | `make repos/upgrade`    | PATCH         | `+semver: patch`                    |
| Workflow version upgrade (minor)                 | `feature`   | `master`    | `make repos/upgrade`    | MINOR         | `+semver: minor`                    |
| Workflow version upgrade (major)                 | `feature`   | `master`    | `make repos/upgrade/major` | MAJOR      | `+semver: major`                    |
| Documentation fix / inputs.yaml sync            | `hotfix`    | `master`    | —                       | PATCH         | `+semver: patch`                    |
| Provider major version upgrade                   | `feature`   | `master`    | —                       | MAJOR         | `+semver: major`                    |
| Provider minor/patch version upgrade             | `feature`   | `master`    | —                       | MINOR / PATCH | `+semver: minor` / `+semver: patch` |
| New module feature                               | `feature`   | `master`    | —                       | MINOR         | `+semver: feature`                  |
| Bug fix                                          | `feature`   | `master`    | —                       | PATCH         | `+semver: fix`                      |
| Breaking / incompatible change (MAJOR bump)      | `feature`   | `master`    | —                       | MAJOR         | `+semver: major`                    |
| Breaking / incompatible change (minor-compatible)| `feature`   | `master`    | —                       | MINOR         | `+semver: breaking`                 |


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
- **README.md generation**: Run `make readme` as the **last step** after all documentation updates are complete.

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
- **Complex objects**: Expand all sub-keys of object variables (e.g., `settings`) as commented lines, even when the default is `{}`. This makes all available options visible to the operator without them needing to read the Terraform source.
- **Module transformations**: If the module transforms an input value before passing it to the provider (e.g., converting a region string to uppercase-underscore format for the Atlas API), document both the expected input format and the resulting API value in the comment.
- **Sync on change**: Whenever a variable is added, removed, or modified in `variables-*.tf`, update `.boilerplate/inputs.yaml` accordingly in the same commit.
- **Scaffolding output**: This file is the template that `terragrunt scaffold` copies into new deployment directories. Every key, comment, and default must be accurate — operators fill in values here without reading the Terraform source.