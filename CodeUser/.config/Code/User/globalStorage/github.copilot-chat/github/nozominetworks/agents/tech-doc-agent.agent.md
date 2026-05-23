---
name: tech-doc-agent
description: Agent instructions for contributing to Nozomi Networks DITA-based technical documentation
disable-model-invocation: false
user-invocable: true
---
# Agent Instructions for nozomi-tech-docs

## Project Overview

The **nozomi-tech-docs** repository contains DITA-based (Darwin Information Typing Architecture) sources for Nozomi Networks' technical documentation website. This project uses Oxygen XML Publishing Engine to build webhelp and PDF documentation for multiple products including Guardian, Arc, Vantage, N2OS, CMC (Central Management Console), and other Nozomi Networks products.

## Technology Stack

- **Content Format**: DITA XML (`.dita` and `.ditamap` files)
- **Build Tool**: Oxygen XML Publishing Engine (via Docker)
- **CI/CD**: GitHub Actions workflows
- **Deployment**: AWS S3 + CloudFront
- **Release Notes**: Go-based YouTrack integration
- **Validation**: Schematron XML validation
- **Scripting**: Ruby, Go, Bash

## Repository Structure

```
nozomi-tech-docs/
├── products/              # Product-specific documentation
│   ├── arc/              # Arc product docs
│   ├── vantage/          # Vantage product docs
│   ├── guardian/         # Guardian product docs
│   ├── n2os/             # N2OS product docs
│   └── ...               # Other products
├── shared-content/       # Reusable DITA content
├── template/             # Publishing templates and CSS
│   ├── nozomi-docs/      # Brand-specific styles
│   ├── project.xml       # Main build configuration
│   └── template-*/       # Product-specific templates
├── scripts/              # Automation scripts
│   ├── release-notes/    # YouTrack integration
│   └── release/          # Release automation
├── oxygen/               # Docker build configuration
├── schematron/           # XML validation rules
├── ditaval/              # Conditional processing filters
├── .github/
│   ├── workflows/        # CI/CD pipelines
│   └── instructions/     # Coding guidelines
├── Makefile              # Build commands
└── *.ditamap             # Root documentation maps
```

## Core Concepts

### DITA Basics

1. **Topics**: Self-contained units of information (`.dita` files)
   - `concept`: Conceptual information
   - `task`: Step-by-step procedures
   - `reference`: Reference material (tables, specs)

2. **Maps**: Organizing and linking topics (`.ditamap` files)
   - Define document structure and hierarchy
   - Control navigation and TOC generation

3. **Content Reuse**: 
   - `conref`: Reference content from other topics
   - `conkeyref`: Reference content using keys
   - Shared content stored in `shared-content/`

### File Naming Conventions

Follow DITA naming conventions:
- Concept files: `c_<product>_<topic>.dita`
- Task files: `t_<product>_<topic>.dita`
- Reference files: `r_<product>_<topic>.dita`
- Map files: `<product>_<section>.ditamap`

Examples:
- `t_vantage_queries_customize_assertion_name_description.dita`
- `c_arc_licenses.dita`
- `r_n2os_release_features.dita`

## Development Workflow

### Prerequisites

1. **Oxygen License**: Place license key in `licensekey.txt` (root directory)
2. **Docker**: Required for building documentation
3. **AWS CLI & SAML2AWS**: For manual publishing (optional)

### Building Documentation

#### Build All Outputs (HTML + PDF)
```bash
make build
```

This creates:
- `out/webhelp-responsive/` - HTML output
- `out/pdf-output/` - PDF files
- `arc.zip` and `n2os.zip` - Archived documentation

#### Build HTML Only (Faster for Development)
```bash
make build-html
```

#### Run Schematron Validation
```bash
make schematron
```

### Working with DITA Files

#### Creating New Topics

1. **Determine topic type**: concept, task, or reference
2. **Choose appropriate template** from `template/`
3. **Follow naming convention**: `<type>_<product>_<topic>.dita`
4. **Add proper metadata**:
   ```xml
   <prolog>
       <critdates>
           <created date="YYYY-MM-DD"/>
           <revised modified="YYYY-MM-DD"/>
       </critdates>
       <metadata>
           <keywords>
               <keyword>relevant keyword</keyword>
           </keywords>
           <prodinfo>
               <prodname>Product Name</prodname>
           </prodinfo>
       </metadata>
   </prolog>
   ```

#### Example Task Topic Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE task PUBLIC "-//OASIS//DTD DITA Task//EN" "task.dtd">
<task id="t_product_action_name">
    <title>Action Title</title>
    <shortdesc>Brief description of the task.</shortdesc>
    <prolog>
        <!-- metadata here -->
    </prolog>
    <taskbody>
        <context>
            <p>Background information about the task.</p>
        </context>
        <steps>
            <step>
                <cmd>First action.</cmd>
                <stepresult>What happens after this step.</stepresult>
            </step>
            <step>
                <cmd>Second action.</cmd>
            </step>
        </steps>
        <result>
            <p>Final outcome of the task.</p>
        </result>
        <example>
            <title>Example</title>
            <p>Concrete example demonstrating the task.</p>
        </example>
    </taskbody>
</task>
```

#### Content Reuse with Conrefs

To reuse content from shared files:

```xml
<step conref="../../../../shared-content/task-nav-elements.dita#task-elements-vantage/step_common_navigation">
    <cmd/>
</step>
```

### Updating Documentation Maps

When adding new topics, update the corresponding `.ditamap` file:

```xml
<topicref href="topics/path/to/file.dita">
    <topicref href="topics/path/to/subtopic.dita"/>
</topicref>
```

## CI/CD Workflows

### Build Workflow (`.github/workflows/build.yml`)

**Triggered by**: Pull requests and manual dispatch

**Actions**:
1. Builds documentation artifacts
2. For PRs: Deploys to staging environment at `https://techdocs-staging.eng.nozominetworks.com/development/<branch-name>/`
3. Comments on PR with deployment URL

### Deploy Workflow (`.github/workflows/deploy.yml`)

**Triggered by**: Manual workflow dispatch or scheduled daily

**Actions**:
1. Builds full documentation (HTML + PDF)
2. Deploys to staging or production S3 bucket
3. Invalidates CloudFront cache
4. Creates release archives for Arc and N2OS

### Release Notes Workflow

Automated generation from YouTrack issues using Go scripts in `scripts/release-notes/`.

## Release Process

### Automated Release (Recommended)

```bash
# For Arc releases
make release-arc

# For N2OS releases
make release-n2os

# For other products
make release-other
```

### Manual Release Notes Generation

1. Set up YouTrack token in `.env` file:
   ```bash
   TOKEN=<your_youtrack_token>
   ```

2. Generate release notes:
   ```bash
   cd scripts/release-notes
   go run release_notes.go <project> <issue-prefix> <version>
   ```

   Examples:
   - `go run release_notes.go Nozomi_Networks_OS N2OS RELEASE-23.3.0`
   - `go run release_notes.go Arc Arc v1.5.0`

3. Move generated `.dita` files to product release notes folder
4. Update product release notes ditamap

## Best Practices

### Writing Guidelines

1. **Be Concise**: Use clear, direct language
2. **Use Active Voice**: "Select the button" not "The button should be selected"
3. **Consistent Terminology**: Use product-specific terms consistently
4. **UI Elements**: Wrap in `<uicontrol>` tags: `<uicontrol>Save</uicontrol>`
5. **Code/Commands**: Use `<codeph>` for inline code, `<codeblock>` for blocks
6. **Keywords**: Add relevant keywords to metadata for searchability

### DITA Best Practices

1. **Keep Topics Focused**: Each topic should cover one concept/task
2. **Maximize Reuse**: Use conrefs for repeated content
3. **Proper Nesting**: Follow DITA information architecture guidelines
4. **Validate Regularly**: Run `make schematron` to catch errors
5. **Test Builds**: Build HTML locally before committing

### File Organization

1. **Place topics in appropriate product folders**: `products/<product>/topics/`
2. **Group related topics in subdirectories**: `products/vantage/topics/queries/`
3. **Store maps separately**: `products/<product>/maps/`
4. **Reusable content**: Always check `shared-content/` before creating duplicates

### Version Control

1. **Feature Branches**: Create branch named after JIRA ticket (e.g., `N2EOS-6608`)
2. **Descriptive Commits**: Reference ticket numbers in commit messages
3. **PR Description**: Explain documentation changes clearly
4. **Review Changes**: Preview deployment URL in PR comments before merging

## Common Tasks

### Adding a New Product Section

1. Create product directory structure:
   ```
   products/new-product/
   ├── topics/
   │   └── section/
   └── maps/
   ```

2. Create root ditamap: `new-product.ditamap`

3. Add to build configuration in `template/project.xml`

4. Create product-specific template in `template/template-new-product/`

### Updating Existing Documentation

1. Locate relevant `.dita` file in `products/<product>/topics/`
2. Make changes following DITA markup conventions
3. Update `<revised modified="YYYY-MM-DD"/>` in prolog
4. Build locally to verify: `make build-html`
5. Commit and create PR

### Adding Images

1. Place images in appropriate directory:
   - Product images: `products/<product>/images/`
   - Shared images: `shared-content/icons-svg/` or `template/images/`

2. Reference in DITA:
   ```xml
   <fig>
       <title>Image Title</title>
       <image href="images/filename.png">
           <alt>Alternative text description</alt>
       </image>
   </fig>
   ```

### Creating Cross-References

```xml
<!-- Link to another topic -->
<xref href="path/to/topic.dita"/>

<!-- Link to specific section within topic -->
<xref href="topic.dita#topic_id/section_id"/>

<!-- External link -->
<xref href="https://example.com" format="html" scope="external">Link text</xref>
```

## Troubleshooting

### Build Failures

1. **License Error**: Ensure `licensekey.txt` exists and contains valid Oxygen license
2. **Docker Issues**: Verify Docker is running: `docker ps`
3. **Validation Errors**: Run `make schematron` to see specific XML issues
4. **Missing References**: Check file paths in conrefs and hrefs are correct

### Preview/Deployment Issues

1. **Branch Not Deploying**: Check PR is open and build completed successfully
2. **404 on Preview**: Wait for CloudFront cache invalidation (5-10 minutes)
3. **Missing Content**: Verify ditamap includes all new topics

### Schematron Validation

Common validation issues:
- Missing required attributes (e.g., `id` on topic element)
- Invalid element nesting
- Broken conrefs or cross-references
- Missing metadata elements

## Additional Resources

### DITA Documentation
- [DITA Specification](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=dita)
- [DITA Best Practices](https://www.oxygenxml.com/dita/styleguide/)
- [Oxygen XML Documentation](https://www.oxygenxml.com/doc/)

### Internal Resources
- YouTrack: Issue tracking and release notes source
- Staging Site: https://techdocs-staging.eng.nozominetworks.com/
- AWS S3 Bucket: `n2-technicaldocs-2-staging` (staging), production bucket configured in workflows

## Key Contacts

When contributing to documentation:
1. **Check CODEOWNERS**: See `.github/CODEOWNERS` for area-specific reviewers
2. **Product Owners**: Coordinate with product teams for technical accuracy
3. **Documentation Team**: For DITA/structural questions

## Agent-Specific Guidelines

As an AI agent contributing to this repository:

1. **Always validate DITA**: Use proper XML structure and DITA-compliant elements
2. **Follow naming conventions strictly**: File names must match pattern for topic type
3. **Maintain consistency**: Check existing files in same product area for style
4. **Update metadata**: Always include creation/revision dates in prolog
5. **Test before committing**: Suggest running `make build-html` to verify changes
6. **Cross-reference properly**: Use relative paths from file location
7. **Reuse when possible**: Search `shared-content/` before creating new content
8. **Branch naming**: Use JIRA ticket format (e.g., `DOCS-123`) for documentation work

## Examples of Recent Changes

For reference, recent PR work includes:
- **N2EOS-6608**: Adding assertion customization features (name/description interpolation)
- **DOCS-928/DOCS-929**: Documentation for assertion customization capabilities

These examples demonstrate the typical workflow of documentation changes accompanying product feature development.

---

**Last Updated**: December 12, 2025
**Repository**: https://github.com/NozomiNetworks/nozomi-tech-docs
