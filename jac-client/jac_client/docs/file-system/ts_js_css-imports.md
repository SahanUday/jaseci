# TS, JS and CSS File Imports

Jac's properly handles imports of TypeScript, TSX, JavaScript, and CSS/SCSS files from nested directories inside the `.jac` files  other than `main.jac` in jac-client projects. This ensures that custom components and stylesheets are correctly processed and copied to the compiled directory while preserving their folder structure.

## Overview

The following file types are supported for import in JAC files:

- **TypeScript files** (`.ts`, `.tsx`) - React components, utilities, and type definitions
- **JavaScript files** (`.js`) - Legacy components and utilities
- **CSS and SCSS files** (`.css`, `.scss`) - Stylesheets for component styling

## Project Structure Example

Here's a typical jac-client project structure demonstrating nested directories:

```
my/
├── main.jac
├── components/
│   └── Button.tsx
├── styles/
│   └── homePage.css
└── pages/
    └── level1/
        └── homePage.jac
```

## Import Syntax

### Importing from Nested Directories

JAC uses a dot-prefix notation for relative imports, where each dot represents a directory level:

- `.` - Current directory
- `..` - Parent directory  
- `...` - Two levels up
- `....` - Three levels up, and so on

### TypeScript/TSX Component Imports

Import React components from TypeScript files using the `cl import` syntax:

**From same directory:**
```jac
cl import from ".components/Button.tsx" { Button }
```

**From nested subdirectories:**
```jac
// In pages/level1/homePage.jac <-- importing from components/ (two levels up)
cl import from "...components/Button.tsx" { Button }
```

**Example: Button.tsx Component**
```tsx
import React from 'react';

interface ButtonProps {
  label: string;
  onClick?: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  label,
  onClick,
  variant = 'primary',
  disabled = false
}) => {
  const baseStyles: React.CSSProperties = {
    padding: '0.75rem 1.5rem',
    fontSize: '1rem',
    fontWeight: '600',
    borderRadius: '0.5rem',
    border: 'none',
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: 'all 0.2s ease',
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    primary: {
      backgroundColor: disabled ? '#9ca3af' : '#3b82f6',
      color: '#ffffff',
    },
    secondary: {
      backgroundColor: disabled ? '#e5e7eb' : '#6b7280',
      color: '#ffffff',
    },
  };

  return (
    <button
      style={{ ...baseStyles, ...variantStyles[variant] }}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
};

export default Button;
```

### CSS File Imports

Import stylesheets without destructuring:

**From same directory:**
```jac
cl import ".styles/homePage.css";
```

**From nested subdirectories:**
```jac
// In pages/level1/homePage.jac <-- importing from styles/ (two levels up)
cl import "...styles/homePage.css";
```

**Example: homePage.css**
```css
.home-container {
  padding: 2rem;
  font-family: Arial, sans-serif;
}

.button-row {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}
```

### JAC Module Imports

Import other JAC modules containing components:

**From nested directories:**
```jac
// In main.jac <-- importing from pages/level1/
cl import from ".pages/level1/homePage" { Home }
```

## Complete Working Example

### File: pages/level1/homePage.jac

```jac
cl import from react { useState, useEffect }
cl import from "...components/Button.tsx" { Button }
cl import "...styles/homePage.css";

cl {
    def:pub Home -> any {
        [count, setCount] = useState(0);

        useEffect(
            lambda -> None { console.log("Count:", count); },
            [count]
        );

        return <div className="home-container">
            <h1>Hello, World!</h1>

            <p>Count: {count}</p>

            <div className="button-row">
                <Button
                    label="Increment"
                    onClick={lambda -> None { setCount(count + 1); }}
                    variant="primary"
                />
                <Button
                    label="Reset"
                    onClick={lambda -> None { setCount(0); }}
                    variant="secondary"
                />
            </div>
        </div>;
    }
}
```

### File: main.jac

```jac
cl import from ".pages/level1/homePage" { Home }
cl import from "@jac-client/utils" { Router, Routes, Route, Link, Navigate, useNavigate }

cl {
    def:pub app -> any {
        return <Router>
            <div style={{"fontFamily": "system-ui, sans-serif"}}>
                <Routes>
                    <Route
                        path="/"
                        element={<Home />}
                    />
                </Routes>
            </div>
        </Router>;
    }
}
```

## Key Points

1. **Relative Path Resolution**: Use dots to navigate directory hierarchies (`.` for current, `..` for parent, etc.)

2. **File Extensions**: Always include the full file extension (`.tsx`, `.ts`, `.js`, `.css`)

3. **Named Exports**: Use curly braces `{ }` for importing named exports from TS/JS files

4. **CSS Imports**: Import CSS files without destructuring - they're loaded globally

5. **Compiled Output**: All imported files are copied to `.jac/client/compiled/` maintaining the original directory structure


## Troubleshooting

- **Import Not Found**: Verify the relative path dots match the directory depth
- **Component Not Rendering**: Check that exports in TSX files use named or default exports correctly
- **CSS Not Applied**: Ensure className attributes match the CSS selectors
- **Type Errors**: TypeScript interfaces in `.tsx` files work as expected with JAC's type system

