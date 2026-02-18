# Form Handling in Jac Client

This example demonstrates both **manual** and **auto-rendered** form handling approaches in Jac client applications, showcasing the evolution from manual JSX to Formkit-style declarative forms.

## 🎯 Two Approaches Demonstrated

### 1. **Manual Form Handling** (Traditional)
- Full control over form JSX and styling
- Explicit field registration and state management
- Best for highly customized forms

### 2. **Auto-Rendered Forms with `JacForm`** ✨ (New!)
- Zero-config automatic form generation from schemas
- Formkit-style declarative approach
- Reduces boilerplate by ~80%
- Perfect for standard forms

## Project Structure

```
form-handling/
├── jac.toml                    # Project configuration with jac-client dependencies
├── main.jac                    # Main application with routing and navigation
│
├── Manual Forms (Traditional):
│   ├── SignupForm.cl.jac       # Manual signup form (~318 lines)
│   ├── RegForm.cl.jac          # Manual registration form (~488 lines)
│
├── Auto-Rendered Forms (JacForm):
│   ├── AutoSignupForm.cl.jac   # Auto-rendered signup (~60 lines)
│   ├── AutoRegForm.cl.jac      # Auto-rendered registration (~110 lines)
│   ├── AutoEventForm.cl.jac    # Auto-rendered event form with date/datetime/enum fields
│
├── components/
│   └── Schema.jac              # Reusable validation schemas
└── README.md                   # This file
```

## 🚀 Quick Start

Run the example:

```bash
cd form-handling
jac client run
```

Navigate between examples:
- **Manual Signup** - Traditional approach with full JSX
- **Manual Registration** - Complex multi-field manual form
- **Auto Signup** ✨ - JacForm auto-rendered signup
- **Auto Registration** ✨ - JacForm auto-rendered with grid layout
- **Auto Event Registration** ✨ - JacForm with date, datetime, and select (enum) fields

---

## 📚 Approach 1: Manual Form Handling

### Key Features

#### 1. Form State Management with `useJacForm`

```jac
# Initialize form with validation mode and schema
form = useJacForm("onTouched", signupSchema);

# Access form state
errors = form.formState.errors;
isSubmitting = form.formState.isSubmitting;
isDirty = form.formState.isDirty;
isValid = form.formState.isValid;
```

#### 2. Field Registration and Watching

```jac
# Register fields for form control
email_field = form.register("email");
password_field = form.register("password");

# Watch field values in real-time
password_value = form.watch("password");
```

#### 3. Manual JSX Rendering

```jac
<form onSubmit={form.handleSubmit(handleSubmit)}>
    <div>
        <label>Email</label>
        <input type="email" {...email_field} />
        {errors.email && <p>{errors.email.message}</p>}
    </div>
    {/* More fields... */}
    <button type="submit">Submit</button>
</form>
```

**Pros:** Full control, highly customizable  
**Cons:** Verbose, repetitive code

---

## ✨ Approach 2: Auto-Rendered Forms with `JacForm`

### Overview

The `JacForm` component brings **Formkit-style** form handling to jac-client. Define a schema, and let `JacForm` automatically generate the complete form UI.

### Basic Example

```jac
cl import from "@jac/runtime" { JacForm, jacSchema }

def:pub MyForm -> JsxElement {
    # 1. Define schema
    schema = jacSchema.object({
        email: jacSchema.string().email("Invalid email"),
        password: jacSchema.string().min(8, "Min 8 characters")
    });

    # 2. Define submit handler  
    async def handleSubmit(data: any) -> None {
        console.log("Submitted:", data);
    }

    # 3. Auto-render with JacForm
    return (
        <JacForm
            schema={schema}
            onSubmit={handleSubmit}
            field_config={{
                "email": {label: "Email", placeholder: "your@email.com"},
                "password": {label: "Password"}
            }}
            submitLabel="Sign Up"
        />
    );
}
```

**Result:** Fully functional form in ~20 lines instead of ~318!

### JacForm Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `schema` | ZodSchema | **required** | Zod validation schema |
| `onSubmit` | Function | **required** | Async submit handler |
| `layout` | String | `"vertical"` | Layout: `"vertical"`, `"grid"`, `"horizontal"`, `"inline"` |
| `field_config` | Dict | `{}` | Field customization (labels, placeholders, className) |
| `submitLabel` | String | `"Submit"` | Submit button text |
| `submitClassName` | String | `""` | CSS class for submit button |
| `gridColumns` | Int | `2` | Columns for grid layout |
| `validateMode` | String | `"onTouched"` | Validation mode |
| `className` | String | `""` | Custom CSS class for form |

### Field Configuration

Each field in `field_config` can have:

| Property | Type | Description |
|----------|------|-------------|
| `label` | String | Display label for the field |
| `placeholder` | String | Placeholder text |
| `className` | String | CSS class for field wrapper div |
| `inputClassName` | String | CSS class for input/select element |
| `labelClassName` | String | CSS class for label element |

### Auto-Detection Features

`JacForm` automatically detects and renders:

1. **Field Types**
   - Email: `.email()` → `type="email"`
   - Password: Field name contains "password" → `type="password"`
   - Number: `.number()` → `type="number"`
   - URL: `.url()` → `type="url"`
   - Checkbox: `.boolean()` → `type="checkbox"` (works with `.optional()` and `.refine()`)
   - **Note**: Boolean fields are automatically unwrapped from `.optional()`, `.refine()`, and `.default()` wrappers

2. **Validation Errors**
   - Auto-rendered from Zod schema
   - User-friendly display with icons

### Layouts

#### Vertical (Default)
```jac
<JacForm schema={schema} onSubmit={handler} layout="vertical" />
```

#### Grid (Multi-column)
```jac
<JacForm 
    schema={schema} 
    onSubmit={handler} 
    layout="grid" 
    gridColumns={2} 
/>
```

#### Horizontal
```jac
<JacForm schema={schema} onSubmit={handler} layout="horizontal" />
```

#### Inline (Compact)
```jac
<JacForm schema={schema} onSubmit={handler} layout="inline" />
```

### Field Configuration

Customize individual fields:

```jac
field_config={{
    "email": {
        label: "Email Address",
        placeholder: "your@email.com",
        inputClassName: "jac-form-input"
    },
    "password": {
        label: "Choose Password",
        placeholder: "Min 8 characters",
        inputClassName: "jac-form-input"
    },
    "agreeToTerms": {
        label: "I agree to the terms and conditions"
    }
}}
```

---

## 🎨 Styling JacForm

JacForm uses a **minimal inline styles** approach, keeping only essential functional styles (width, boxSizing). All cosmetic styling is done via CSS classes.

### Default Theme

A default theme is provided at `assets/jacform-default.css`:

```jac
import from "./assets/jacform-default.css"

<JacForm
    schema={schema}
    onSubmit={handler}
    className="jac-form"
    submitClassName="jac-form-submit"
    field_config={{
        "email": {
            label: "Email",
            inputClassName: "jac-form-input",
            labelClassName: "jac-form-label"
        }
    }}
/>
```

### Custom Styling

Create your own CSS classes for complete customization:

```css
/* custom-form.css */
.my-form {}
.my-input {
    border: 1px solid blue;
    padding: 1rem;
}
.my-button {
    background: green;
    color: white;
}
```

```jac
import from "./custom-form.css"

<JacForm
    schema={schema}
    onSubmit={handler}
    className="my-form"
    submitClassName="my-button"
    field_config={{
        "email": {inputClassName: "my-input"}
    }}
/>
```

### Per-Field Styling

Style individual fields differently:

```jac
field_config={{
    "email": {
        inputClassName: "primary-input",
        labelClassName: "primary-label"
    },
    "optional": {
        inputClassName: "subtle-input",
        labelClassName: "subtle-label"
    }
}}
```

---

## 🔍 Schema Definition with `jacSchema`

Both approaches use `jacSchema` (Zod wrapper) for validation:

### String Validation
```jac
email: jacSchema.string()
    .min(1, "Email is required")
    .email("Invalid email address")
```

### Regex Patterns
```jac
password: jacSchema.string()
    .min(8, "Min 8 characters")
    .regex(RegExp("[A-Z]"), "Must contain uppercase")
    .regex(RegExp("\\d"), "Must contain number")
    .regex(RegExp("[^A-Za-z0-9]"), "Must contain special character")
```

### Cross-Field Validation
```jac
schema.refine(
    lambda data -> bool { return data.password == data.confirmPassword; },
    {
        message: "Passwords do not match",
        path: ["confirmPassword"]
    }
);
```

### Optional Fields
```jac
companyName: jacSchema.string().optional()
```

### Boolean Fields (Checkboxes)

JacForm automatically renders boolean fields as checkboxes. It correctly handles wrapped types:

**Required Checkbox (with validation):**
```jac
agreeToTerms: jacSchema.boolean().refine(
    lambda v -> bool { return v == True; },
    "You must agree to the terms and conditions"
)
```

**Optional Checkbox:**
```jac
agreeToNewsletter: jacSchema.boolean().optional()
```

**With Default Value:**
```jac
newsletter: jacSchema.boolean().default(false)
```

**Field Config for Checkboxes:**
```jac
field_config={{
    "agreeToTerms": {
        label: "I agree to the terms and conditions"
    },
    "agreeToNewsletter": {
        label: "Subscribe to newsletter (optional)"
    }
}}
```

> **Note:** JacForm automatically unwraps `.optional()`, `.refine()`, and `.default()` wrappers to detect the underlying boolean type. This ensures checkboxes render correctly even with complex validation rules.

---

## 📊 Code Comparison

### SignupForm: Manual vs Auto-Rendered

| Aspect | Manual (SignupForm.cl.jac) | Auto (AutoSignupForm.cl.jac) |
|--------|----------------------------|-------------------------------|
| **Lines of Code** | ~318 lines | ~60 lines |
| **Boilerplate** | High | Minimal |
| **Customization** | Full control | Config-based |
| **Maintenance** | More effort | Easy |
| **Best For** | Custom designs | Standard forms |

### RegistrationForm: Manual vs Auto-Rendered

| Aspect | Manual (RegForm.cl.jac) | Auto (AutoRegForm.cl.jac) |
|--------|-------------------------|---------------------------|
| **Lines of Code** | ~488 lines | ~110 lines |
| **Layout** | Manual flex/grid | Auto grid layout |
| **Field Rendering** | Manual JSX per field | Auto from schema |
| **Error Handling** | Manual per field | Auto from schema |

---

## 🎯 When to Use Which Approach

### Use Manual Forms When:
- You need pixel-perfect custom designs
- Complex conditional rendering logic
- Non-standard form layouts
- Heavily branded UI requirements

### Use JacForm (Auto-Rendered) When:
- Building standard registration/login forms
- Rapid prototyping
- Consistent form styling across app
- Reducing development time
- Minimizing code maintenance

---

## 💡 Best Practices

### 1. Schema Reusability
```jac
# components/Schema.jac
def:pub SignupSchema -> any {
    return jacSchema.object({...});
}

# Use in multiple components
import from ".components.Schema" { SignupSchema }
schema = SignupSchema();
```

### 2. Field Configuration
```jac
# Keep field_config organized
field_config = {
    "email": {label: "Email Address", placeholder: "your@email.com"},
    "password": {label: "Password", placeholder: "Min 8 characters"}
}

<JacForm schema={schema} onSubmit={handler} field_config={field_config} />
```

### 3. Error Handling in Submit
```jac
async def handleSubmit(data: any) -> None {
    try {
        # Process form data
        console.log("Success:", data);
    } except Exception as e {
        console.error("Submission failed:", e);
    }
}
```

### 4. Layout Selection
- **Vertical**: Default for mobile-first designs
- **Grid**: Multi-column forms on larger screens
- **Horizontal**: Side-by-side fields (name, surname)
- **Inline**: Compact forms (newsletter signup)

---

## 📦 Import Patterns

### Using JacForm
```jac
cl import from "@jac/runtime" { JacForm, jacSchema, useNavigate }
```

### Using Manual Forms
```jac
cl import from "@jac/runtime" { useJacForm, jacSchema }
```

### Custom Schemas
```jac
cl import from ".components.Schema" { SignupSchema, RegisterSchema }
```

---

## 🚀 Running the Example

```bash
cd form-handling
jac client run
```

Or from the parent directory:
```bash
jac client run jac_client/examples/form-handling
```

Navigate between examples using the navigation bar:
- **Manual Signup** - Traditional approach (~318 lines)
- **Manual Registration** - Complex manual form (~488 lines)
- **Auto Signup** ✨ - JacForm auto-rendered (~60 lines)
- **Auto Registration** ✨ - JacForm with grid layout (~110 lines)

---

## 📋 Component Overview

### Manual Forms

**SignupForm (`SignupForm.cl.jac`)**
- Email and password fields
- Password strength indicator
- Password confirmation matching
- Show/hide password toggle
- Real-time validation feedback

**RegForm (`RegForm.cl.jac`)**
- Comprehensive user registration
- Multiple field types (text, phone, address, etc.)
- Complex validation rules
- Terms and conditions agreement
- Newsletter subscription option
- Accessibility features

### Auto-Rendered Forms (JacForm)

**AutoSignupForm (`AutoSignupForm.cl.jac`)**
- Same functionality as SignupForm
- ~80% less code
- Auto field type detection
- Built-in password strength
- Vertical layout

**AutoRegForm (`AutoRegForm.cl.jac`)**
- Same functionality as RegForm
- ~77% less code
- Auto grid layout (2 columns)
- All validation from schema
- Built-in error handling

**AutoEventForm (`AutoEventForm.cl.jac`)**
- Demonstrates advanced field types:
  - **Date fields** (`eventDate`) - Native date picker
  - **DateTime fields** (`startDateTime`, `endDateTime`) - Date and time selection
  - **Select/Enum fields** (`eventType`, `ticketType`, `mealPreference`) - Dropdown menus
  - **Number fields** (`numberOfAttendees`) - Numeric input with min/max validation
  - **Boolean fields** (`agreeToTerms`, `marketingConsent`) - Checkboxes
- Grid layout (2 columns)
- Optional fields support
- Complex validation (required checkboxes)

### Shared Components

**Schema (`components/Schema.jac`)**
- Reusable Zod validation schemas
- Custom validation rules
- Cross-field validation (password matching)
- Optional field handling

---

## 🔮 Future Enhancements

The JacForm component is designed for iterative enhancement. Future versions may include:

- **Password strength indicators** (Weak/Medium/Strong)
- **Character counters** for fields with max length
- Custom field renderers
- Theme customization
- Advanced layouts (multi-step, wizard)
- File upload support
- Rich text editors
- Field dependencies and conditional logic

**Already Supported** ✅:
- Date and datetime pickers (via native HTML5 inputs)
- Select/dropdown fields (via `jacSchema.enum()`)
- Number inputs with validation
- Boolean checkboxes with validation
- Optional and required fields
- Grid, vertical, horizontal, and inline layouts

---

## 📝 Summary

This example demonstrates the power of **abstraction** in form handling:

1. **Manual Approach**: Full control, more code
2. **Auto-Rendered (JacForm)**: Less code, faster development

Both approaches use the same underlying validation (`jacSchema`) and form state management (`useJacForm`), but JacForm abstracts away the repetitive JSX rendering.

**Key Takeaway**: Choose based on your needs
- Custom designs → Manual
- Standard forms → JacForm

Happy form building! 🎉
