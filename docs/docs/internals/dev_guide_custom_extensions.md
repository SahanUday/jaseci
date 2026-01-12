# Developer Guide: Adding Custom File Extensions to Jac Client

This guide explains how to extend Jac Client's asset handling system to support additional file types beyond the default supported extensions. This is particularly useful for integrating specialized assets like Web Workers, Python scripts for Pyodide, WebAssembly modules, or custom configuration files.

## Overview

### What Are Custom Extensions?

Custom extensions allow you to include specialized file types in your Jac Client build that aren't part of the default asset types. These files are:

- Copied to the build output directory during compilation
- Served as static assets by the development server
- Accessible via standard HTTP paths from your application

### Default vs. Custom Extensions

**Default Extensions** (always supported, no configuration needed):

| Category | Extensions |
|----------|-----------|
| Images | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.svg`, `.ico` |
| Fonts | `.woff`, `.woff2`, `.ttf`, `.otf`, `.eot` |
| Media | `.mp4`, `.webm`, `.mp3`, `.wav` |
| Styles | `.css` |

**Custom Extensions** (require configuration):

- Any file type not in the default list
- Examples: `.js`, `.py`, `.wasm`, `.json`, `.txt`, `.xml`, etc.

## Quick Start

### Step 1: Create Your Project Structure

```bash
my-jac-project/
├── jac.toml              # Configuration file
├── src/
│   └── app.jac          # Entry point
└── assets/              # Asset directory
    └── custom/
        ├── worker.js    # Your custom file
        └── script.py    # Another custom file
```

### Step 2: Configure jac.toml

Add the `custom_extensions` configuration to your `jac.toml`:

```toml
[project]
name = "my-app"
version = "1.0.0"
entry-point = "src/app.jac"

[plugins.client.assets]
custom_extensions = [".js", ".py"]
```

### Step 3: Place Assets in the assets/ Directory

All custom asset files should be placed within the `assets/` directory at the root of your project. You can organize them in subdirectories:

```
assets/
├── workers/
│   ├── data-worker.js
│   └── compute-worker.py
├── configs/
│   └── settings.json
└── wasm/
    └── module.wasm
```

## Configuration Options

### Basic Configuration

The simplest form adds a list of extensions:

```toml
[plugins.client.assets]
custom_extensions = [".js", ".py", ".wasm", ".json"]
```

### Key Points

- **Extension format**: Always include the leading dot (`.js`, not `js`)
- **Case sensitivity**: Extensions are case-sensitive (`.JS` ≠ `.js`)
- **Multiple extensions**: Add as many as needed in the array
- **Additive nature**: Custom extensions don't replace default types

### Example Configurations

#### Web Worker Setup

```toml
[project]
name = "worker-app"
version = "1.0.0"
entry-point = "src/app.jac"

[plugins.client.assets]
custom_extensions = [".js", ".py"]
```

#### Configuration-Heavy Application

```toml
[plugins.client.assets]
custom_extensions = [".json", ".yaml", ".toml"]
```

#### High-Performance Computing

```toml
[plugins.client.assets]
custom_extensions = [".wasm", ".js", ".data"]
```

#### Mixed Media Application

```toml
[plugins.client.assets]
custom_extensions = [".json", ".txt", ".md", ".xml"]
```

## Implementation Details

### Build Process Flow

Understanding how custom extensions are processed:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Configuration Phase                                       │
│    - Parse jac.toml                                         │
│    - Extract custom_extensions from [plugins.client.assets] │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Discovery Phase                                           │
│    - Scan assets/ directory recursively                     │
│    - Match files against default + custom extensions        │
│    - Build list of files to copy                            │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Copy Phase                                                │
│    - Create .client-build/build/assets/ structure           │
│    - Copy matched files preserving directory structure      │
│    - Maintain relative paths                                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. Server Phase                                              │
│    - Development server routes /assets/* to build/assets/   │
│    - Custom MIME types handled for known extensions         │
│    - Static file serving enabled                            │
└─────────────────────────────────────────────────────────────┘
```

### Configuration Reading

The build system reads configuration using the `get_config()` function from the Jac configuration module:

```python
from jac.plugins.client.config import get_config

config = get_config()
custom_exts = config.get('plugins', {}).get('client', {}).get('assets', {}).get('custom_extensions', [])
```

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Asset Not Found (404)

**Symptoms:**

```
GET http://localhost:3000/assets/workers/worker.js 404 (Not Found)
```

**Causes & Solutions:**

1. **File not in assets/ directory**
   - Ensure file is placed in `assets/` at project root
   - Check subdirectory structure

2. **Extension not configured**
   - Verify extension is listed in `custom_extensions`
   - Check for typos (`.js` vs `.JS`)

3. **Build not run**
   - Run `jac client build` to copy assets
   - Restart development server if running

#### Issue 2: Extension Not Being Copied

**Symptoms:**

- File exists in `assets/` but not in `.client-build/build/assets/`

**Causes & Solutions:**

1. **Case sensitivity mismatch**

   ```toml
   # Wrong - file is worker.js not worker.JS
   custom_extensions = [".JS"]

   # Correct
   custom_extensions = [".js"]
   ```

2. **Missing dot prefix**

   ```toml
   # Wrong
   custom_extensions = ["js", "py"]

   # Correct
   custom_extensions = [".js", ".py"]
   ```

3. **Configuration syntax error**

   ```toml
   # Wrong - missing quotes
   custom_extensions = [.js, .py]

   # Correct
   custom_extensions = [".js", ".py"]
   ```

## Summary

Key takeaways for adding custom file extensions:

1. **Configuration is simple**: Add extensions to `[plugins.client.assets]` in `jac.toml`
2. **Always use dot prefix**: `.js`, not `js`
3. **Place files in assets/**: Build system only processes files in this directory
4. **Extensions are additive**: Custom extensions don't replace default types
5. **Access via /assets/ path**: Use `/assets/path/to/file.ext` in your code

## Additional Resources

- [Jac Import Patterns Documentation](./jac_import_patterns.md) - Complete import system reference
- [Jac Client Examples](https://github.com/jaseci-labs/jaseci/tree/main/jac-client/jac_client/examples) - Working examples

---
