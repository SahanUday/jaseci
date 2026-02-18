# Form Handling in Jac Client

Auto-rendered, type-safe forms with JacForm - zero boilerplate, full validation.

---

## Overview

**JacForm** auto-generates complete form UIs from Zod schemas with built-in validation, error handling, and flexible layouts.

**Key Features:**

- Auto-render forms from schemas (~80% less code)
- Built-in validation
- Multiple layouts (vertical, grid, horizontal, inline)
- Built-in password toggle, validation errors
- Minimal styling, fully customizable

---

## Quick Start

```jac
cl import from "@jac/runtime" { JacForm, jacSchema }

def:pub MyForm -> JsxElement {
    schema = jacSchema.object({
        email: jacSchema.string().email("Invalid email"),
        password: jacSchema.string().min(8, "Min 8 characters")
    });

    async def handleSubmit(data: any) -> None {
        console.log("Submitted:", data);
    }

    return <JacForm schema={schema} onSubmit={handleSubmit} />;
}
```

---

## JacForm Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `schema` | `ZodSchema` | **required** | Zod validation schema defining form structure |
| `onSubmit` | `function` | **required** | Async handler called with validated data |
| `layout` | `string` | `"vertical"` | Layout: `vertical`, `grid`, `horizontal`, `inline` |
| `gridColumns` | `number` | `2` | Columns for grid layout |
| `field_config` | `dict` | `{}` | Per-field customization (label, type, placeholder, etc.) |
| `submitLabel` | `string` | `"Submit"` | Submit button text |
| `submitClassName` | `string` | `""` | CSS class for submit button |
| `className` | `string` | `""` | CSS class for form element |
| `validateMode` | `string` | `"onTouched"` | Validation timing: `onChange`, `onBlur`, `onTouched`, `onSubmit` |

**Example**

```jac
<JacForm
    schema={ZodSchema}       # Required: Zod validation schema
    onSubmit={function}      # Required: Async submit handler
    layout={string}          # Optional: "vertical" | "grid" | "horizontal" | "inline"
    gridColumns={number}     # Optional: Grid columns (default: 2)
    field_config={dict}      # Optional: Per-field configuration
    submitLabel={string}     # Optional: Submit button text
    submitClassName={string} # Optional: Submit button CSS class
    className={string}       # Optional: Form CSS class
    validateMode={string}    # Optional: Validation timing
/>
```

---

### jacSchema

| Method | Usage |
|--------|-------|
| `.string()` | String type |
| `.number()` | Number type |
| `.boolean()` | Boolean type |
| `.enum([...])` | Enum type (select/radio) |
| `.object({...})` | Object schema |
| `.min(n, msg)` | Min length/value |
| `.max(n, msg)` | Max length/value |
| `.email(msg)` | Email validation |
| `.url(msg)` | URL validation |
| `.regex(pattern, msg)` | Regex validation |
| `.optional()` | Make field optional |
| `.default(value)` | Default value |
| `.refine(fn, msg)` | Custom validation |

### Supported Field Types

| Type | Schema Example | Config | Notes |
|------|---------------|--------|-------|
| **Text** | `jacSchema.string()` | `type: "text"` | Default field type |
| **Email** | `jacSchema.string().email()` | `type: "email"` | With validation |
| **Password** | `jacSchema.string()` | `type: "password"` | Supports `showPasswordToggle` |
| **Tel** | `jacSchema.string()` | `type: "tel"` | Phone number input |
| **URL** | `jacSchema.string().url()` | `type: "url"` | With validation |
| **Number** | `jacSchema.number()` | `type: "number"` | Numeric input with min/max |
| **Date** | `jacSchema.string()` | `type: "date"` | Native date picker |
| **DateTime** | `jacSchema.string()` | `type: "datetime-local"` | Date and time picker |
| **Select** | `jacSchema.enum([...])` | `type: "select"` | Dropdown from enum values |
| **Radio** | `jacSchema.enum([...])` | `type: "radio"` | Radio buttons from enum values |
| **Textarea** | `jacSchema.string()` | `type: "textarea"`, `rows: 4` | Multi-line text |
| **Checkbox** | `jacSchema.boolean()` | `type: "checkbox"` | Works with `.optional()`, `.refine()` |

---

## Field Configuration

Each field in `field_config` accepts:

| Property | Type | Description |
|----------|------|-------------|
| `type` | `string` | **Required** - Field type (see table above) |
| `label` | `string` | Display label for the field |
| `placeholder` | `string` | Placeholder text |
| `rows` | `number` | Textarea rows (default: 4) |
| `showPasswordToggle` | `boolean` | Show password visibility toggle (default: false) |
| `className` | `string` | CSS class for field wrapper |
| `inputClassName` | `string` | CSS class for input/select/textarea element |
| `labelClassName` | `string` | CSS class for label element |

**Example:**

```jac
field_config={{
    "email": {
        label: "Email Address",
        type: "email",
        placeholder: "you@example.com",
        inputClassName: "input-style"
    },
    "password": {
        label: "Password",
        type: "password",
        showPasswordToggle: True
    }
}}
```

---

## Layouts

| Layout | Usage | Best For |
|--------|-------|----------|
| `vertical` | `layout="vertical"` (default) | Mobile-first, single column forms |
| `grid` | `layout="grid"` `gridColumns={2}` | Multi-column desktop forms |
| `horizontal` | `layout="horizontal"` | Side-by-side fields with wrapping |
| `inline` | `layout="inline"` | Compact search bars, filters |

---

## Schema Validation

### String Validation

```jac
email = jacSchema.string()
    .min(1, "Required")
    .email("Invalid email");

password = jacSchema.string()
    .min(8, "Min 8 chars")
    .regex(RegExp("[A-Z]"), "Need uppercase")
    .regex(RegExp("\\d"), "Need number");

phone = jacSchema.string()
    .regex(RegExp("^[0-9]{10}$"), "10 digits required");
```

### Number Validation

```jac
age = jacSchema.number()
    .min(18, "Must be 18+")
    .max(120, "Invalid age");

quantity = jacSchema.number()
    .int("Must be integer")
    .positive("Must be positive");
```

### Enum Fields (Select/Radio)

```jac
role = jacSchema.enum(
    ["admin", "user", "guest"],
    "Please select a role"
);

# Config
field_config={{
    "role": {
        label: "User Role",
        type: "select",  # or "radio"
        placeholder: "Choose role"
    }
}}
```

### Boolean Fields (Checkbox)

```jac
# Required checkbox
agreeToTerms = jacSchema.boolean().refine(
    lambda v: any -> bool { return v == True; },
    "Must agree to terms"
);

# Optional checkbox
newsletter = jacSchema.boolean().optional();
```

### Optional & Default Values

```jac
middleName = jacSchema.string().optional();
country = jacSchema.string().default("USA");
notifications = jacSchema.boolean().default(false);
```

### Cross-Field Validation

```jac
schema = jacSchema.object({
    password: jacSchema.string().min(8),
    confirmPassword: jacSchema.string().min(8)
}).refine(
    lambda data: any -> bool {
        return data.password == data.confirmPassword;
    },
    {
        message: "Passwords must match",
        path: ["confirmPassword"]
    }
);
```

---

## Password Visibility Toggle

Built-in password toggle - independent state per field:

```jac
field_config={{
    "password": {
        label: "Password",
        type: "password",
        showPasswordToggle: True  # Shows "Show password" checkbox
    },
    "confirmPassword": {
        label: "Confirm Password",
        type: "password",
        showPasswordToggle: True  # Independent toggle
    }
}}
```

---

## Styling

JacForm uses minimal inline styles (only for functionality). All cosmetic styling via CSS classes.

### Custom Styling

```css
/* custom.css */
.my-form { max-width: 600px; margin: 0 auto; }
.my-input { padding: 0.5rem; border: 1px solid #ccc; }
.my-submit { background: blue; color: white; padding: 0.5rem 1rem; }
```

```jac
cl import from "./custom.css";

<JacForm
    className="my-form"
    submitClassName="my-submit"
    field_config={{
        "email": { inputClassName: "my-input" }
    }}
/>
```

### Per-Field Styling

```jac
field_config={{
    "email": {
        className: "field-wrapper",
        inputClassName: "primary-input",
        labelClassName: "primary-label"
    }
}}
```

---

## Working Examples

For comprehensive examples demonstrating all field types and features, see:

**[Form Handling Example Project](../../examples/form-handling/)**

- All field types (text, email, password, number, date, datetime, select, radio, textarea, checkbox, tel, url)
- Password visibility toggle
- Validation patterns
- Layout options
- Custom styling

---

## Related Documentation

- [Routing](../routing.md) - Navigate between forms
- [Error Handling](./error-handling.md) - Handle form submission errors
- [Styling Guide](../styling/) - Style your forms
- [Form Handling Examples](../../examples/form-handling/) - Complete working examples

For detailed examples, see the [form-handling example project](../../examples/form-handling/).
