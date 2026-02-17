"""Auto-rendered registration form using JacForm component.

This demonstrates advanced JacForm features with grid layout, multiple field types,
and comprehensive validation - all auto-rendered from the schema.

Compare this to RegForm.cl.jac to see the difference:
- RegForm.cl.jac: ~488 lines with manual JSX
- AutoRegForm.cl.jac: ~110 lines with JacForm auto-rendering

Note: Add the CSS file jacform-default.css to your HTML to use default styles,
or provide custom className values with your own CSS.
"""

cl import from "@jac/runtime" { JacForm, jacSchema }
cl import ".assets.jacform-default.css";

def:pub AutoRegForm -> JsxElement {
    # Define comprehensive registration schema
    registrationSchema = jacSchema.object(
        {
            firstName: jacSchema.string().min(1, "First name is required").max(
                50, "First name must not exceed 50 characters"
            ),
            lastName: jacSchema.string().min(1, "Last name is required").max(
                50, "Last name must not exceed 50 characters"
            ),
            email: jacSchema.string().min(1, "Email is required").email(
                "Please enter a valid email address"
            ),
            phone: jacSchema.string().min(
                10, "Phone number must be at least 10 digits"
            ).regex(
                RegExp("^[0-9\\-\\+\\(\\)\\s]*$"),
                "Phone number contains invalid characters"
            ),
            companyName: jacSchema.string().max(100).optional(),
            address: jacSchema.string().min(
                5, "Address must be at least 5 characters"
            ).max(
                100, "Address must not exceed 100 characters"
            ),
            city: jacSchema.string().min(2, "City must be at least 2 characters").max(
                50, "City must not exceed 50 characters"
            ),
            state: jacSchema.string().min(1, "State is required"),
            zipCode: jacSchema.string().regex(
                RegExp("^[0-9\\-]*$"), "Zip code contains invalid characters"
            ),
            country: jacSchema.string().min(1, "Country is required"),
            password: jacSchema.string().min(
                8, "Password must be at least 8 characters"
            ).regex(
                RegExp("[A-Z]"),
                "Password must contain at least one uppercase letter"
            ).regex(
                RegExp("[a-z]"),
                "Password must contain at least one lowercase letter"
            ).regex(
                RegExp("[0-9]"), "Password must contain at least one number"
            ).regex(
                RegExp("[!@#\\$%\\^&\\*]"),
                "Password must contain at least one special character (!@#$%^&*)"
            ),
            confirmPassword: jacSchema.string().min(
                8, "Confirm password must be at least 8 characters"
            ),
            agreeToTerms: jacSchema.boolean().refine(
                lambda v: any  -> bool { return v == True; },
                "You must agree to the terms and conditions"
            ),
            agreeToNewsletter: jacSchema.boolean().optional()
        }
    ).refine(
        lambda data: any  -> bool { return data.password == data.confirmPassword; },
        {message: "Passwords do not match", path: ["confirmPassword"],}
    );

    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Registration form submitted:", data);
    }

    return (
        <div
            style={{
                "maxWidth": "900px",
                "margin": "2rem auto",
                "padding": "2rem",
                "backgroundColor": "#ffffff",
                "borderRadius": "12px",
                "boxShadow": "0 4px 12px rgba(0,0,0,0.1)",
                "fontFamily": "system-ui, -apple-system, sans-serif"
            }}
        >
            <h2
                style={{
                    "textAlign": "center",
                    "color": "#1a1a2e",
                    "marginBottom": "0.5rem"
                }}
            >
                Complete Registration
            </h2>
            <p
                style={{
                    "textAlign": "center",
                    "color": "#666",
                    "marginBottom": "2rem",
                    "fontSize": "0.95rem"
                }}
            >
                Auto-rendered form with grid layout
            </p>

            <JacForm
                schema={registrationSchema}
                onSubmit={handleSubmit}
                layout="grid"
                gridColumns={2}
                className="jac-form"
                submitClassName="jac-form-submit"
                field_config={{
                    "firstName": {label: "First Name", placeholder: "John", inputClassName: "jac-form-input"},
                    "lastName": {label: "Last Name", placeholder: "Doe", inputClassName: "jac-form-input"},
                    "email": {label: "Email Address", placeholder: "john@example.com", inputClassName: "jac-form-input"},
                    "phone": {label: "Phone Number", placeholder: "+1 (555) 123-4567", inputClassName: "jac-form-input"},
                    "companyName": {label: "Company Name (Optional)", placeholder: "Acme Corp", inputClassName: "jac-form-input"},
                    "address": {label: "Street Address", placeholder: "123 Main St", inputClassName: "jac-form-input"},
                    "city": {label: "City", placeholder: "New York", inputClassName: "jac-form-input"},
                    "state": {label: "State/Province", placeholder: "NY", inputClassName: "jac-form-input"},
                    "zipCode": {label: "Zip Code", placeholder: "10001", inputClassName: "jac-form-input"},
                    "country": {label: "Country", placeholder: "USA", inputClassName: "jac-form-input"},
                    "password": {label: "Password", placeholder: "Min 8 characters", inputClassName: "jac-form-input"},
                    "confirmPassword": {label: "Confirm Password", placeholder: "Re-enter password", inputClassName: "jac-form-input"},
                    "agreeToTerms": {label: "I agree to the terms and conditions"},
                    "agreeToNewsletter": {label: "Subscribe to newsletter (optional)"}
                }}
                submitLabel="Complete Registration"
            />
        </div>
    );
}
