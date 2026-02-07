# Form Handling in Jac Client

This example demonstrates advanced form handling abstractions in Jac client applications, showcasing production-ready form management with validation, state handling, and user experience features.

## Project Structure

```
form-handling/
├── jac.toml                    # Project configuration with jac-client dependencies
├── main.jac                    # Main application entry with routing
├── SignupForm.cl.jac           # Simple signup form with password validation
├── RegForm.cl.jac              # Comprehensive registration form with multiple fields
├── components/
│   └── Schema.jac              # validation schemas for forms
└── README.md                   # This file
```

## Key Features Demonstrated

### 1. Form State Management with `useJacForm`

The `useJacForm` hook provides comprehensive form state management:

```jac
# Initialize form with validation mode and schema
form = useJacForm("onTouched", signupSchema);

# Access form state
errors = form.formState.errors;
isSubmitting = form.formState.isSubmitting;
isDirty = form.formState.isDirty;
isValid = form.formState.isValid;
```

### 2. Field Registration and Watching

Register form fields and watch their values:

```jac
# Register fields for form control
email_field = form.register("email");
password_field = form.register("password");

# Watch field values in real-time
password_value = form.watch("password");
```

### 3. Validation with `jacSchema`

Define robust validation schemas using `jacSchema`:

```jac
signupSchema = jacSchema.object({
    email: jacSchema.string().min(1, "Email is required").email("Invalid email address"),
    password: jacSchema.string().min(8, "Password must be at least 8 characters")
        .regex(RegExp("[A-Z]"), "Password must contain at least one uppercase letter")
        .regex(RegExp("\d"), "Password must contain at least one number")
        .regex(RegExp("[^A-Za-z0-9]"), "Password must contain at least one special character"),
    confirmPassword: jacSchema.string().min(8, "Confirm password must be at least 8 characters")
})
.refine(lambda data:any -> bool{return data.password == data.confirmPassword;}, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
});
```

### 4. Form Submission Handling

Handle form submissions with async functions:

```jac
async def handleSubmit(data: any) -> None {
    console.log("Form submitted:", data);
    # Handle successful submission
}
```

### 5. Real-time Validation and Error Display

Display validation errors with user-friendly messages:

```jac
{errors.email && <p style={{"color": "#ef4444"}}>{errors.email.message}</p>}
```

## Import Patterns

### Main Application (`main.jac`)

```jac
# Import form components
cl import from .SignupForm { SignupForm }
cl import from .RegForm { RegForm }

# Import routing utilities
cl import from "@jac/runtime" { Router, Routes, Route }
```

### Form Components

```jac
# Import form hooks and validation
cl import from "@jac/runtime" { useJacForm, jacSchema }

# Import custom schemas
cl import from ".components.Schema" { SignupSchema, RegisterSchema }
```

## Running the Example

To run your Jac client application:

```bash
jac start main.jac
```

Navigate to the served application to see the forms in action. The app includes routing between signup (`/`) and registration (`/register`) forms.

## Form Components Overview

### SignupForm (`SignupForm.cl.jac`)

- Email and password fields
- Password strength indicator
- Password confirmation matching
- Show/hide password toggle
- Real-time validation feedback

### RegForm (`RegForm.cl.jac`)

- Comprehensive user registration
- Multiple field types (text, phone, address, etc.)
- Complex validation rules
- Terms and conditions agreement
- Newsletter subscription option
- Accessibility features

### Schema (`components/Schema.jac`)

- Reusable Zod validation schemas
- Custom validation rules
- Cross-field validation (password matching)
- Optional field handling
