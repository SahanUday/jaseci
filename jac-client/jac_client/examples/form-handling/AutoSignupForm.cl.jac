cl import from "@jac/runtime" { JacForm, jacSchema, useNavigate }
cl import ".assets.jacform-default.css";

def:pub AutoSignupForm -> JsxElement {
    navigate = useNavigate();
    
    # Define schema with Zod directly
    signupSchema = jacSchema.object(
        {
            email: jacSchema.string().min(1, "Email is required").email(
                "Invalid email address"
            ),
            password: jacSchema.string().min(
                8, "Password must be at least 8 characters"
            ).regex(
                RegExp("[A-Z]"),
                "Password must contain at least one uppercase letter"
            ).regex(
                RegExp("\d"), "Password must contain at least one number"
            ).regex(
                RegExp("[^A-Za-z0-9]"),
                "Password must contain at least one special character"
            ),
            confirmPassword: jacSchema.string().min(
                8, "Confirm password must be at least 8 characters"
            )
        }
    ).refine(
        lambda data: any  -> bool { return data.password == data.confirmPassword; },
        {message: "Passwords do not match", path: ["confirmPassword"],}
    );

    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Signup form submitted:", data);
        navigate("/auto-register");
    }

    return
        <div
            style={{
                "maxWidth": "500px",
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
                Create Account
            </h2>
            <p
                style={{
                    "textAlign": "center",
                    "color": "#666",
                    "marginBottom": "2rem",
                    "fontSize": "0.95rem"
                }}
            >
                Join us today and get started (Auto-rendered form)
            </p>
            <JacForm
                schema={signupSchema}
                onSubmit={handleSubmit}
                layout="vertical"
                className="jac-form"
                submitClassName="jac-form-submit"
                field_config={{
                    "email": {
                        label: "Email Address",
                        type: "email",
                        placeholder: "your@email.com",
                        className: "jac-form-field",
                        inputClassName: "jac-form-input",
                        labelClassName: "jac-form-label"
                    },
                    "password": {
                        label: "Password",
                        type: "password",
                        placeholder: "Minimum 8 characters",
                        className: "jac-form-field",
                        inputClassName: "jac-form-input",
                        labelClassName: "jac-form-label"
                    },
                    "confirmPassword": {
                        label: "Confirm Password",
                        type: "password",
                        placeholder: "Re-enter your password",
                        className: "jac-form-field",
                        inputClassName: "jac-form-input",
                        labelClassName: "jac-form-label"
                    }
                }}
                submitLabel="Create Account"
            />
        </div>;
}
