# Form Handling in Jac Client

Auto-rendered, type-safe forms with JacForm - zero boilerplate, full validation.

---

## Overview

**JacForm** auto-generates complete form UIs from Zod schemas with built-in validation, error handling, and flexible layouts.

**Key Features:**
- Auto-render forms from schemas (~80% less code)
- Type-safe validation with Zod
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

---

## Supported Field Types

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

### Default Theme

```jac
cl import from "./assets/jacform-default.css";

<JacForm
    className="jac-form"
    submitClassName="jac-form-submit"
    field_config={{
        "email": { inputClassName: "jac-form-input" }
    }}
/>
```

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

## Complete Example

```jac
cl import from "@jac/runtime" { JacForm, jacSchema }

def:pub RegistrationForm -> JsxElement {
    schema = jacSchema.object({
        email: jacSchema.string().email("Invalid email"),
        password: jacSchema.string().min(8, "Min 8 characters"),
        age: jacSchema.number().min(18, "Must be 18+"),
        role: jacSchema.enum(["user", "admin"], "Required"),
        newsletter: jacSchema.boolean().optional()
    });

    async def handleSubmit(data: any) -> None {
        console.log("Submitted:", data);
    }


    return (
        <JacForm
            schema={schema}
            onSubmit={handleSubmit}
            layout="vertical"
            submitLabel="Sign Up"
            field_config={{
                "email": {label: "Email", type: "email", placeholder: "you@example.com"},
                "password": {label: "Password", type: "password", showPasswordToggle: True},
                "age": {label: "Age", type: "number", placeholder: "18+"},
                "role": {label: "Role", type: "select", placeholder: "Choose role"},
                "newsletter": {label: "Subscribe to newsletter", type: "checkbox"}
            }}
        />
    );
}
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

## API Reference

### jacSchema (Zod)

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

---

## Best Practices

1. **Use `"onTouched"` validation** - Best UX, validates after user interacts with field
2. **Provide clear error messages** - "Email is required" better than "Required"  
3. **Use enums for dropdowns/radios** - Type-safe, auto-renders options
4. **Leverage CSS classes** - Separate styling from logic
5. **Keep schemas reusable** - Define in separate files, import as needed

---

## Summary

JacForm provides powerful, declarative form handling with minimal code:

- **Auto-rendering** from schemas
- **Type-safe validation** with Zod
- **Flexible layouts** and styling
- **Built-in features** (password toggle, error display)
- **~80% less code** than manual forms

For detailed examples, see the [form-handling example project](../../examples/form-handling/).

        email: jacSchema.string().email("Invalid email"),
        password: jacSchema.string().min(8, "Min 8 characters")
    });

    form = useJacForm("onTouched", schema);

    return (
        <form onSubmit={form.handleSubmit(handleSubmit)}>
            <input {...form.register("email")} />
            {form.formState.errors.email && <p>{form.formState.errors.email.message}</p>}
            <button type="submit">Submit</button>
        </form>
    );
}
```

### Learn More

For comprehensive examples of manual form handling including:

- Form state management
- Field registration patterns
- Real-time validation
- Complex multi-field forms
- Custom field components

See the complete working examples in the [form-handling example project](../../examples/form-handling/):

- **[SignupForm.cl.jac](../../examples/form-handling/SignupForm.cl.jac)** - Full manual signup form
- **[RegForm.cl.jac](../../examples/form-handling/RegForm.cl.jac)** - Complex registration with 14+ fields

---

## Schema Definition with jacSchema

`jacSchema` is a wrapper around Zod for type-safe form validation.

### Basic Types

```jac
cl import from "@jac/runtime" { jacSchema }

# String
email = jacSchema.string()
    .min(1, "Email is required")
    .email("Invalid email address");

# Number
age = jacSchema.number()
    .min(18, "Must be 18 or older")
    .max(120, "Invalid age");

# Boolean
agreeToTerms = jacSchema.boolean()
    .refine(
        lambda v -> bool { return v == True; },
        "You must agree to terms"
    );

# Date
birthDate = jacSchema.date();

# Enum
role = jacSchema.enum(["admin", "user", "guest"]);
```

### String Validation

```jac
# Email validation
email = jacSchema.string().email("Invalid email");

# URL validation
website = jacSchema.string().url("Invalid URL");

# Regex validation
phone = jacSchema.string()
    .regex(
        RegExp("^[0-9]{10}$"),
        "Phone must be 10 digits"
    );

# Length constraints
username = jacSchema.string()
    .min(3, "Min 3 characters")
    .max(20, "Max 20 characters");

# Password with complexity rules
password = jacSchema.string()
    .min(8, "Min 8 characters")
    .regex(RegExp("[A-Z]"), "Must contain uppercase")
    .regex(RegExp("[a-z]"), "Must contain lowercase")
    .regex(RegExp("[0-9]"), "Must contain number")
    .regex(RegExp("[!@#$%^&*]"), "Must contain special char");
```

### Optional and Default Values

```jac
# Optional field
middleName = jacSchema.string().optional();

# Field with default value
country = jacSchema.string().default("USA");

# Optional boolean (for checkboxes)
newsletter = jacSchema.boolean().optional();
```

### Object Schema

```jac
userSchema = jacSchema.object({
    firstName: jacSchema.string().min(1, "Required"),
    lastName: jacSchema.string().min(1, "Required"),
    email: jacSchema.string().email("Invalid email"),
    age: jacSchema.number().min(18, "Must be 18+")
});
```

### Cross-Field Validation

Validate one field based on another:

```jac
schema = jacSchema.object({
    password: jacSchema.string().min(8, "Min 8 characters"),
    confirmPassword: jacSchema.string().min(8, "Min 8 characters")
}).refine(
    lambda data -> bool {
        return data.password == data.confirmPassword;
    },
    {
        message: "Passwords must match",
        path: ["confirmPassword"]  # Show error on confirmPassword field
    }
);
```

### Complex Validation

```jac
# Email with domain restriction
corporateEmail = jacSchema.string()
    .email("Invalid email")
    .refine(
        lambda email -> bool {
            return email.endsWith("@company.com");
        },
        "Must be a company email"
    );

# Conditional validation
companyName = jacSchema.string()
    .optional()
    .refine(
        lambda v -> bool {
            return v == None or v == "" or v.length >= 2;
        },
        "Company name must be at least 2 characters if provided"
    );
```

---

## Field Type Detection

JacForm automatically detects field types from your schema and renders appropriate inputs.

### Automatic Detection

| Schema Type | Rendered Input | Example |
|-------------|----------------|---------|
| `.string().email()` | `<input type="email">` | Email validation |
| `.string()` with "password" in name | `<input type="password">` | Password fields |
| `.number()` | `<input type="number">` | Numeric input |
| `.string().url()` | `<input type="url">` | URL validation |
| `.date()` | `<input type="date">` | Date picker |
| `.boolean()` | `<input type="checkbox">` | Checkbox |
| `.enum([...])` | `<select>` | Dropdown |
| Default | `<input type="text">` | Text input |

### Boolean Fields (Checkboxes)

JacForm automatically unwraps boolean types even when wrapped with modifiers:

```jac
schema = jacSchema.object({
    # Required checkbox
    agreeToTerms: jacSchema.boolean().refine(
        lambda v -> bool { return v == True; },
        "You must agree to terms"
    ),

    # Optional checkbox
    newsletter: jacSchema.boolean().optional(),

    # Checkbox with default
    notifications: jacSchema.boolean().default(true)
});
```

All three render as checkboxes with proper boolean value handling.

### Implementation Details

JacForm uses a recursive unwrapping algorithm to detect types:

```jac
# Unwraps nested types like:
# ZodOptional → ZodBoolean → renders as checkbox
# ZodEffects (from .refine()) → ZodBoolean → renders as checkbox
# ZodDefault → ZodString → renders as text input
```

This ensures correct rendering even with complex validation rules.

---

## Validation

### Validation Timing

Control when validation occurs:

```jac
# Validate after user touches field (default, best UX)
<JacForm validateMode="onTouched" ... />

# Validate on every keystroke (may be annoying)
<JacForm validateMode="onChange" ... />

# Validate when user leaves field
<JacForm validateMode="onBlur" ... />

# Validate only on submit (fastest, least helpful)
<JacForm validateMode="onSubmit" ... />
```

**Recommendation:** Use `"onTouched"` for best user experience.

### Error Display

#### Auto-Rendered Forms

JacForm automatically displays validation errors:

```jac
<JacForm schema={schema} onSubmit={handleSubmit} />
```

Errors appear below each field with the message from your schema.

#### Manual Forms

Access and display errors manually:

```jac
form = useJacForm("onTouched", schema);
errors = form.formState.errors;

return (
    <form onSubmit={form.handleSubmit(handleSubmit)}>
        <input {...form.register("email")} />
        {errors.email &&
            <p style={{color: "red"}}>
                ⚠️ {errors.email.message}
            </p>
        }
    </form>
);
```

### Custom Validation

```jac
# Async validation (e.g., check username availability)
username = jacSchema.string()
    .min(3, "Min 3 characters")
    .refine(
        async lambda username -> bool {
            response = await fetch(f"/api/check-username/{username}");
            data = await response.json();
            return data.available;
        },
        "Username already taken"
    );
```

---

## Styling

### Approach 1: CSS Classes (Recommended)

JacForm uses minimal inline styles for functionality only. All cosmetic styling is done via CSS classes.

**Default Theme:**

```jac
# Import default styles
cl import from "./assets/jacform-default.css"

<JacForm
    schema={schema}
    onSubmit={handleSubmit}
    className="jac-form"
    submitClassName="jac-form-submit"
    field_config={{
        "email": { inputClassName: "jac-form-input" }
    }}
/>
```

**Custom Theme:**

```css
/* custom-form.css */
.my-form {
    max-width: 600px;
    margin: 0 auto;
    padding: 2rem;
}

.my-input {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
}

.my-input:focus {
    border-color: #3b82f6;
    outline: none;
}

.my-submit {
    background: #3b82f6;
    color: white;
    padding: 0.75rem 2rem;
    border-radius: 8px;
    border: none;
    cursor: pointer;
}
```

```jac
cl import from "./custom-form.css"

<JacForm
    className="my-form"
    submitClassName="my-submit"
    field_config={{
        "email": { inputClassName: "my-input" }
    }}
/>
```

### Approach 2: Inline Styles

For dynamic or component-scoped styles:

```jac
<div style={{
    maxWidth: "600px",
    margin: "0 auto",
    padding: "2rem"
}}>
    <JacForm
        schema={schema}
        onSubmit={handleSubmit}
        field_config={{
            "email": {
                className: "email-field",
                inputClassName: "email-input"
            }
        }}
    />
</div>
```

### Per-Field Styling

Customize individual fields:

```jac
field_config={{
    "email": {
        className: "primary-field",
        inputClassName: "primary-input",
        labelClassName: "primary-label"
    },
    "optional": {
        className: "secondary-field",
        inputClassName: "secondary-input"
    }
}}
```

---

## API Reference

### JacForm Component

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

### useJacForm Hook

```jac
form = useJacForm(validateMode: string, schema: ZodSchema)
```

**Returns:**

- `form.register(fieldName)` - Register a field
- `form.watch(fieldName)` - Watch field value
- `form.handleSubmit(onSubmit)` - Submit handler
- `form.formState.errors` - Validation errors
- `form.formState.isSubmitting` - Submission state
- `form.formState.isDirty` - Has form changed?
- `form.formState.isValid` - Is form valid?
- `form.formState.touchedFields` - Touched fields

### jacSchema (Zod Wrapper)

```jac
# String
jacSchema.string()
    .min(n, message)
    .max(n, message)
    .email(message)
    .url(message)
    .regex(pattern, message)

# Number
jacSchema.number()
    .min(n, message)
    .max(n, message)
    .int(message)
    .positive(message)

# Boolean
jacSchema.boolean()

# Date
jacSchema.date()

# Enum
jacSchema.enum([value1, value2, ...])

# Object
jacSchema.object({ field: schema, ... })

# Modifiers
.optional()
.default(value)
.refine(validator, message)
```

### Field Config Object

```jac
field_config={{
    "fieldName": {
        label: string,          # Field label text
        placeholder: string,    # Input placeholder
        className: string,      # Field container CSS class
        inputClassName: string, # Input element CSS class
        labelClassName: string  # Label element CSS class
    }
}}
```

---

## Related Documentation

- [Routing](../routing.md) - Navigate between forms
- [Error Handling](./error-handling.md) - Handle form submission errors
- [Styling Guide](../styling/) - Style your forms
- [Form Handling Examples](../../examples/form-handling/) - Complete working examples

---

## Summary

JacForm provides powerful, declarative form handling with minimal code:

- **Auto-rendering** from schemas
- **Type-safe validation** with Zod
- **Flexible layouts** and styling
- **Built-in features** (password toggle, error display)
- **~80% less code** than manual forms

For detailed examples, see the [form-handling example project](../../examples/form-handling/).
