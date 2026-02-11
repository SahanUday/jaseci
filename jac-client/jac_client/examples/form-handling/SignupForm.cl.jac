"""Simple signup form component with Zod validation.

Demonstrates production-level form handling with:
- Email validation
- Password strength requirements
- Password confirmation matching
- Form state management
- Error handling and display
"""

cl import from "@jac/runtime" { useJacForm, jacSchema, useNavigate }
cl import from ".components.Schema" { SignupSchema }

def:pub SignupForm(onSuccess: any) -> JsxElement {
    # Get the signup schema
    signupSchema = SignupSchema();

    # Initialize form with Zod validation
    form = useJacForm("onTouched", signupSchema);
    errors = form.formState.errors;
    isSubmitting = form.formState.isSubmitting;
    isDirty = form.formState.isDirty;
    has showPassword: bool = False;

    # Register form fields
    email_field = form.register("email");
    password_field = form.register("password");
    password_value = form.watch("password");
    confirmPassword_field = form.register("confirmPassword");

    navigate = useNavigate();
    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Signup form submitted:", data);
        navigate("/register");
    }

    # Function returns JSX directly
    def getStrength(pwd: str) -> JsxElement {
        if (not pwd or pwd.length == 0) {
            return
                <></>;  # nothing to show if password is empty

        }
        has_upper = RegExp("[A-Z]").test(pwd);
        has_number = RegExp("\d").test(pwd);
        has_special = RegExp("[^A-Za-z0-9]").test(pwd);

        if has_upper and has_number and has_special and pwd.length >= 8 {
            return (
                <p
                    style={{
                        "color": "#16a34a",
                        "fontSize": "0.85rem",
                        "margin": "0.5rem 0 0 0",
                        "display": "flex",
                        "alignItems": "center",
                        "gap": "0.5rem"
                    }}
                >
                    Password strength: Strong
                </p>
            );
        } elif (has_upper or has_number or has_special) and pwd.length >= 8 {
            return (
                <p
                    style={{
                        "color": "#f97316",
                        "fontSize": "0.85rem",
                        "margin": "0.5rem 0 0 0",
                        "display": "flex",
                        "alignItems": "center",
                        "gap": "0.5rem"
                    }}
                >
                    Password strength: Medium
                </p>
            );
        } else {
            return (
                <p
                    style={{
                        "color": "#ef4444",
                        "fontSize": "0.85rem",
                        "margin": "0.5rem 0 0 0",
                        "display": "flex",
                        "alignItems": "center",
                        "gap": "0.5rem"
                    }}
                >
                    Password strength: Weak
                </p>
            );
        }
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
                Join us today and get started
            </p>
            <form onSubmit={form.handleSubmit(handleSubmit)}>
                <div style={{"marginBottom": "1.5rem"}}>
                    <label
                        style={{
                            "display": "block",
                            "marginBottom": "0.5rem",
                            "fontWeight": "600",
                            "color": "#333",
                            "fontSize": "0.95rem"
                        }}
                    >
                        Email Address
                    </label>
                    <input
                        type="email"
                        placeholder="your@email.com"
                        {...email_field}
                        style={{
                            "width": "100%",
                            "padding": "0.75rem 1rem",
                            "fontSize": "1rem",
                            "border": (
                                "2px solid #ef4444"
                                if errors.email
                                else "2px solid #e5e7eb"
                            ),
                            "borderRadius": "8px",
                            "outline": "none",
                            "boxSizing": "border-box",
                            "transition": "border-color 0.3s",
                            "fontFamily": "system-ui, -apple-system, sans-serif"
                        }}
                    />
                    {errors.email
                    && <p
                        style={{
                            "color": "#ef4444",
                            "fontSize": "0.85rem",
                            "margin": "0.5rem 0 0 0",
                            "display": "flex",
                            "alignItems": "center",
                            "gap": "0.5rem"
                        }}
                    >
                        ⚠️ {errors.email.message}
                    </p>}
                </div>
                <div style={{"marginBottom": "1.5rem"}}>
                    <label
                        style={{
                            "display": "block",
                            "marginBottom": "0.5rem",
                            "fontWeight": "600",
                            "color": "#333",
                            "fontSize": "0.95rem"
                        }}
                    >
                        Password
                    </label>
                    <input
                        type={"text" if showPassword else "password"}
                        placeholder="Minimum 8 characters"
                        {...password_field}
                        style={{
                            "width": "100%",
                            "padding": "0.75rem 1rem",
                            "fontSize": "1rem",
                            "border": (
                                "2px solid #ef4444"
                                if errors.password
                                else "2px solid #e5e7eb"
                            ),
                            "borderRadius": "8px",
                            "outline": "none",
                            "boxSizing": "border-box",
                            "transition": "border-color 0.3s",
                            "fontFamily": "system-ui, -apple-system, sans-serif"
                        }}
                    />
                    {getStrength(password_value)}
                    {errors.password
                    && <p
                        style={{
                            "color": "#ef4444",
                            "fontSize": "0.85rem",
                            "margin": "0.5rem 0 0 0",
                            "display": "flex",
                            "alignItems": "center",
                            "gap": "0.5rem"
                        }}
                    >
                        {errors.password.message}
                    </p>}
                    <p
                        style={{
                            "fontSize": "0.8rem",
                            "color": "#999",
                            "margin": "0.5rem 0 0 0"
                        }}
                    >
                        Must include: uppercase, lowercase, number, and special character
                    </p>
                    <label style={{"cursor": "pointer"}}>
                        <input
                            type="checkbox"
                            checked={showPassword}
                            onChange={lambda -> None { setShowPassword(
                                not showPassword
                            );}}
                            style={{"marginRight": "0.5rem"}}
                        />
                        Show password
                    </label>
                </div>
                <div style={{"marginBottom": "2rem"}}>
                    <label
                        style={{
                            "display": "block",
                            "marginBottom": "0.5rem",
                            "fontWeight": "600",
                            "color": "#333",
                            "fontSize": "0.95rem"
                        }}
                    >
                        Confirm Password
                    </label>
                    <input
                        type="password"
                        placeholder="Re-enter your password"
                        {...confirmPassword_field}
                        style={{
                            "width": "100%",
                            "padding": "0.75rem 1rem",
                            "fontSize": "1rem",
                            "border": (
                                "2px solid #ef4444"
                                if errors.confirmPassword
                                else "2px solid #e5e7eb"
                            ),
                            "borderRadius": "8px",
                            "outline": "none",
                            "boxSizing": "border-box",
                            "transition": "border-color 0.3s",
                            "fontFamily": "system-ui, -apple-system, sans-serif"
                        }}
                    />
                    {errors.confirmPassword
                    && <p
                        style={{
                            "color": "#ef4444",
                            "fontSize": "0.85rem",
                            "margin": "0.5rem 0 0 0",
                            "display": "flex",
                            "alignItems": "center",
                            "gap": "0.5rem"
                        }}
                    >
                        {errors.confirmPassword.message}
                    </p>}
                </div>
                <button
                    type="submit"
                    disabled={isSubmitting || not isDirty}
                    style={{
                        "width": "100%",
                        "padding": "0.75rem",
                        "backgroundColor": (
                            "#3b82f6"
                            if not (isSubmitting or not isDirty)
                            else "#93c5fd"
                        ),
                        "color": "#fff",
                        "border": "none",
                        "borderRadius": "8px",
                        "fontSize": "1rem",
                        "fontWeight": "600",
                        "cursor": (
                            "pointer"
                            if not (isSubmitting or not isDirty)
                            else "not-allowed"
                        ),
                        textDecoration: "none",
                        "transition": "background-color 0.3s"
                    }}
                >
                    Create Account
                </button>
            </form>
        </div>;
}
