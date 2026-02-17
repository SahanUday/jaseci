# Form Handling in Jac Client

Build robust, type-safe forms with built-in validation and automatic UI generation using Jac Client's form handling abstractions.

---

## Table of Contents

- [Overview](#overview)
- [Two Approaches to Forms](#two-approaches-to-forms)
- [Getting Started](#getting-started)
- [JacForm: Auto-Rendered Forms](#jacform-auto-rendered-forms)
- [Manual Forms with useJacForm](#manual-forms-with-usejacform)
- [Schema Definition with jacSchema](#schema-definition-with-jacschema)
- [Field Type Detection](#field-type-detection)
- [Validation](#validation)
- [Styling](#styling)
- [API Reference](#api-reference)

---

## Overview

Jac Client provides two powerful approaches to form handling:

1. **Auto-Rendered Forms** (`JacForm`) - Zero-config form generation from schemas
2. **Manual Forms** (`useJacForm`) - Full control over form JSX and layout

Both approaches share the same foundation:

- **Type-safe validation** with Zod schemas
- **react-hook-form** under the hood for optimal performance
- **Real-time validation** with customizable validation modes
- **Declarative schema definitions** using `jacSchema`

**Key Benefits:**

- **Reduce Boilerplate**: ~80% less code with JacForm compared to manual forms
- **Type Safety**: Schema-based validation catches errors at development time
- **Performance**: Optimized re-renders with react-hook-form
- **DX**: Declarative, readable code that's easy to maintain
- **Flexible**: Choose auto-rendering for speed, manual for customization

---

## Two Approaches to Forms

### When to Use JacForm (Auto-Rendered)

✅ **Best for:**

- Standard CRUD forms
- Admin panels and dashboards
- Rapid prototyping
- Forms with consistent styling
- Data entry forms

**Pros:**

- Minimal code (~80% reduction)
- Automatic field rendering
- Built-in validation error display
- Consistent UI across forms
- Easy to maintain

**Cons:**

- Less control over individual field layout
- Custom field types require field_config
- Not ideal for complex multi-step forms

### When to Use useJacForm (Manual)

✅ **Best for:**

- Highly customized UIs
- Complex multi-step wizards
- Forms with conditional field rendering
- Custom field components
- Unique design requirements

**Pros:**

- Complete control over JSX
- Custom field components
- Complex conditional logic
- Pixel-perfect designs

**Cons:**

- More verbose code
- Manual error handling
- Repetitive field registration

---

## Getting Started

### Installation

Form handling utilities are built into `@jac/runtime`:

```jac
cl import from "@jac/runtime" {
    JacForm,        # Auto-rendered form component
    useJacForm,     # Manual form hook
    jacSchema       # Zod schema wrapper (alias for z)
}
```

### Quick Start: Auto-Rendered Form

```jac
cl import from "@jac/runtime" { JacForm, jacSchema }

def:pub SignupForm -> JsxElement {
    # Define schema
    schema = jacSchema.object({
        email: jacSchema.string().email("Invalid email"),
        password: jacSchema.string().min(8, "Min 8 characters")
    });

    # Handle submission
    async def handleSubmit(data: any) -> None {
        console.log("Form data:", data);
    }

    return (
        <JacForm
            schema={schema}
            onSubmit={handleSubmit}
            submitLabel="Sign Up"
        />
    );
}
```

That's it! You get a fully functional form with validation in ~15 lines of code.

---

## JacForm: Auto-Rendered Forms

`JacForm` is a powerful component that automatically generates form UI from your Zod schema.

### Basic Usage

```jac
<JacForm
    schema={mySchema}
    onSubmit={handleSubmit}
/>
```

### Complete Example with All Options

```jac
cl import from "@jac/runtime" { JacForm, jacSchema }

def:pub RegistrationForm -> JsxElement {
    # Define comprehensive schema
    schema = jacSchema.object({
        firstName: jacSchema.string().min(1, "Required"),
        lastName: jacSchema.string().min(1, "Required"),
        email: jacSchema.string().email("Invalid email"),
        phone: jacSchema.string().min(10, "Min 10 digits"),
        agreeToTerms: jacSchema.boolean().refine(
            lambda v -> bool { return v == True; },
            "You must agree to terms"
        ),
        newsletter: jacSchema.boolean().optional()
    }).refine(
        lambda data -> bool { return data.password == data.confirmPassword; },
        { message: "Passwords must match", path: ["confirmPassword"] }
    );

    async def handleSubmit(data: any) -> None {
        console.log("Registration data:", data);
    }

    return (
        <JacForm
            schema={schema}
            onSubmit={handleSubmit}
            layout="grid"
            gridColumns={2}
            className="registration-form"
            submitClassName="submit-button"
            submitLabel="Create Account"
            validateMode="onTouched"
            field_config={{
                "firstName": {
                    label: "First Name",
                    placeholder: "John",
                    inputClassName: "input-field"
                },
                "lastName": {
                    label: "Last Name",
                    placeholder: "Doe"
                },
                "agreeToTerms": {
                    label: "I agree to the terms and conditions"
                }
            }}
        />
    );
}
```

### Props Reference

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `schema` | ZodSchema | required | Zod schema defining form structure and validation |
| `onSubmit` | function | required | Async function called with validated form data |
| `layout` | string | `"vertical"` | Layout type: `"vertical"`, `"grid"`, `"horizontal"`, `"inline"` |
| `gridColumns` | number | `2` | Number of columns when layout is `"grid"` |
| `field_config` | dict | `{}` | Per-field configuration (label, placeholder, className) |
| `submitLabel` | string | `"Submit"` | Text for submit button |
| `submitClassName` | string | `""` | CSS class for submit button |
| `className` | string | `""` | CSS class for form element |
| `validateMode` | string | `"onTouched"` | When to validate: `"onChange"`, `"onBlur"`, `"onTouched"`, `"onSubmit"` |

### Layouts

#### Vertical (Default)

```jac
<JacForm
    schema={schema}
    onSubmit={handleSubmit}
    layout="vertical"
/>
```

Fields stack vertically, one per row.

#### Grid

```jac
<JacForm
    schema={schema}
    onSubmit={handleSubmit}
    layout="grid"
    gridColumns={2}
/>
```

Fields arranged in a responsive grid.

#### Horizontal

```jac
<JacForm
    schema={schema}
    onSubmit={handleSubmit}
    layout="horizontal"
/>
```

Fields arranged horizontally with wrapping.

#### Inline

```jac
<JacForm
    schema={schema}
    onSubmit={handleSubmit}
    layout="inline"
/>
```

Compact inline layout for search bars or filters.

### Field Configuration

Customize individual fields with `field_config`:

```jac
field_config={{
    "email": {
        label: "Email Address",           # Custom label
        placeholder: "you@example.com",   # Placeholder text
        className: "email-field",         # Field container class
        inputClassName: "email-input",    # Input element class
        labelClassName: "email-label"     # Label element class
    },
    "password": {
        label: "Choose Password",
        placeholder: "Min 8 characters"
    }
}}
```

---

## Manual Forms with useJacForm

For complete control over form UI, use the `useJacForm` hook. This approach gives you full control over JSX rendering, custom layouts, and complex conditional logic.

### Quick Example

```jac
cl import from "@jac/runtime" { useJacForm, jacSchema }

def:pub LoginForm -> JsxElement {
    schema = jacSchema.object({
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

Jac Client provides powerful, flexible form handling with two approaches:

- **JacForm** - Auto-generate forms from schemas with minimal code
- **useJacForm** - Full control over form UI for custom requirements

Both approaches share:

- Type-safe validation with Zod
- Optimized performance with react-hook-form
- Declarative, maintainable code
- Excellent developer experience

Choose the approach that best fits your needs, and enjoy building robust forms with confidence! 🚀
