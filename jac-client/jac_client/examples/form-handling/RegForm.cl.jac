"""Comprehensive user registration form with advanced Zod validation.

Demonstrates production-level form handling with:
- Multiple form fields (personal, contact, address information)
- Complex validation rules
- Conditional field validation
- Terms & conditions checkbox
- Multi-step form state management
- Real-time field validation
- Accessibility features
"""

cl import from "@jac/runtime" { useJacForm, jacSchema }
cl import from ".components.Schema" { RegisterSchema }

def:pub RegForm(onSuccess: any) -> JsxElement {
    # Get the registration schema
    registrationSchema = RegisterSchema();

    # Initialize form with Zod validation
    form = useJacForm("onTouched", registrationSchema);
    errors = form.formState.errors;
    isSubmitting = form.formState.isSubmitting;
    isValid = form.formState.isValid;
    touchedFields = form.formState.touchedFields;

    # Register form fields
    firstName_field = form.register("firstName");
    lastName_field = form.register("lastName");
    email_field = form.register("email");
    phone_field = form.register("phone");
    companyName_field = form.register("companyName");
    address_field = form.register("address");
    city_field = form.register("city");
    state_field = form.register("state");
    zipCode_field = form.register("zipCode");
    country_field = form.register("country");
    password_field = form.register("password");
    password_value = form.watch("password");
    confirmPassword_field = form.register("confirmPassword");
    agreeToTerms_field = form.register("agreeToTerms");
    agreeToNewsletter_field = form.register("agreeToNewsletter");

    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Registration form submitted:", data);
    }

    # Helper function to render text input field
    def renderTextField(label: str, field: any, error: any, placeholder: str = "", helperText: str = "") -> JsxElement {
        return(
            <div style={{"marginBottom": "1.5rem"}}>
                <label style={{
                    "display": "block",
                    "marginBottom": "0.5rem",
                    "fontWeight": "600",
                    "color": "#333",
                    "fontSize": "0.95rem"
                }}>
                    {label}
                </label>
                <input
                    type="text"
                    placeholder={placeholder}
                    {...field}
                    style={{
                        "width": "100%",
                        "padding": "0.75rem 1rem",
                        "fontSize": "1rem",
                        "border": ("2px solid #ef4444" if error else "2px solid #e5e7eb"),
                        "borderRadius": "8px",
                        "outline": "none",
                        "boxSizing": "border-box",
                        "transition": "border-color 0.3s",
                        "fontFamily": "system-ui, -apple-system, sans-serif"
                    }}
                />
                {error && <p style={{
                    "color": "#ef4444",
                    "fontSize": "0.85rem",
                    "margin": "0.5rem 0 0 0",
                    "display": "flex",
                    "alignItems": "center",
                    "gap": "0.5rem"
                }}>
                    ⚠️ {error.message}
                </p>}
                {helperText && not error && <p style={{
                    "fontSize": "0.8rem",
                    "color": "#999",
                    "margin": "0.5rem 0 0 0"
                }}>
                    {helperText}
                </p>}
            </div>);
    }

    return(
        <div style={{
            "maxWidth": "700px",
            "margin": "2rem auto",
            "padding": "2rem",
            "backgroundColor": "#ffffff",
            "borderRadius": "12px",
            "boxShadow": "0 4px 12px rgba(0,0,0,0.1)",
            "fontFamily": "system-ui, -apple-system, sans-serif"
        }}>
            <h2 style={{
                "textAlign": "center",
                "color": "#1a1a2e",
                "marginBottom": "0.5rem"
            }}>
                Complete Registration
            </h2>
            <p style={{
                "textAlign": "center",
                "color": "#666",
                "marginBottom": "2rem",
                "fontSize": "0.95rem"
            }}>
                Please provide your information to create an account
            </p>

            <form onSubmit={form.handleSubmit(handleSubmit)}>
               
                <div style={{
                    "marginBottom": "2rem",
                    "paddingBottom": "1.5rem",
                    "borderBottom": "1px solid #e5e7eb"
                }}>
                    <h3 style={{
                        "color": "#1a1a2e",
                        "fontSize": "1.1rem",
                        "marginBottom": "1.5rem",
                        "fontWeight": "600"
                    }}>
                        Personal Information
                    </h3>

                    <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "1rem", "marginBottom": "1.5rem"}}>
                        {renderTextField("First Name", firstName_field, errors.firstName, "John")}
                        {renderTextField("Last Name", lastName_field, errors.lastName, "Doe")}
                    </div>

                    {renderTextField("Email Address", email_field, errors.email, "john@example.com")}
                    {renderTextField("Phone Number", phone_field, errors.phone, "+1 (555) 000-0000")}
                </div>

             
                <div style={{
                    "marginBottom": "2rem",
                    "paddingBottom": "1.5rem",
                    "borderBottom": "1px solid #e5e7eb"
                }}>
                    <h3 style={{
                        "color": "#1a1a2e",
                        "fontSize": "1.1rem",
                        "marginBottom": "1.5rem",
                        "fontWeight": "600"
                    }}>
                        Company Information (Optional)
                    </h3>
                    {renderTextField("Company Name", companyName_field, errors.companyName, "Acme Corp", "Leave blank if not applicable")}
                </div>

              
                <div style={{
                    "marginBottom": "2rem",
                    "paddingBottom": "1.5rem",
                    "borderBottom": "1px solid #e5e7eb"
                }}>
                    <h3 style={{
                        "color": "#1a1a2e",
                        "fontSize": "1.1rem",
                        "marginBottom": "1.5rem",
                        "fontWeight": "600"
                    }}>
                        Address
                    </h3>

                    {renderTextField("Street Address", address_field, errors.address, "123 Main Street")}

                    <div style={{"display": "grid", "gridTemplateColumns": "2fr 1fr", "gap": "1rem", "marginBottom": "1.5rem"}}>
                        {renderTextField("City", city_field, errors.city, "New York")}
                        {renderTextField("State/Province", state_field, errors.state, "NY")}
                    </div>

                    <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "1rem", "marginBottom": "1.5rem"}}>
                        {renderTextField("Zip/Postal Code", zipCode_field, errors.zipCode, "10001")}
                        {renderTextField("Country", country_field, errors.country, "United States")}
                    </div>
                </div>

           
                <div style={{
                    "marginBottom": "2rem",
                    "paddingBottom": "1.5rem",
                    "borderBottom": "1px solid #e5e7eb"
                }}>
                    <h3 style={{
                        "color": "#1a1a2e",
                        "fontSize": "1.1rem",
                        "marginBottom": "1.5rem",
                        "fontWeight": "600"
                    }}>
                        Security
                    </h3>

                    <div style={{"marginBottom": "1.5rem"}}>
                        <label style={{
                            "display": "block",
                            "marginBottom": "0.5rem",
                            "fontWeight": "600",
                            "color": "#333",
                            "fontSize": "0.95rem"
                        }}>
                            Password
                        </label>
                        <input
                            type="password"
                            placeholder="Minimum 8 characters"
                            {...password_field}
                            style={{
                                "width": "100%",
                                "padding": "0.75rem 1rem",
                                "fontSize": "1rem",
                                "border": ("2px solid #ef4444" if errors.password else "2px solid #e5e7eb"),
                                "borderRadius": "8px",
                                "outline": "none",
                                "boxSizing": "border-box",
                                "transition": "border-color 0.3s",
                                "fontFamily": "system-ui, -apple-system, sans-serif"
                            }}
                        />
                        {errors.password && <p style={{
                            "color": "#ef4444",
                            "fontSize": "0.85rem",
                            "margin": "0.5rem 0 0 0",
                            "display": "flex",
                            "alignItems": "center",
                            "gap": "0.5rem"
                        }}>
                            ⚠️ {errors.password.message}
                        </p>}
                        <p style={{
                            "fontSize": "0.8rem",
                            "color": "#999",
                            "margin": "0.5rem 0 0 0"
                        }}>
                            Must include: uppercase, lowercase, number, and special character
                        </p>
                    </div>

                    {password_value && (
                        <div style={{"marginBottom": "1.5rem"}}>
                            <label style={{
                                "display": "block",
                                "marginBottom": "0.5rem",
                                "fontWeight": "600",
                                "color": "#333",
                                "fontSize": "0.95rem"
                            }}>
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
                                    "border": ("2px solid #ef4444" if errors.confirmPassword else "2px solid #e5e7eb"),
                                    "borderRadius": "8px",
                                    "outline": "none",
                                    "boxSizing": "border-box",
                                    "transition": "border-color 0.3s",
                                    "fontFamily": "system-ui, -apple-system, sans-serif"
                                }}
                            />
                            {errors.confirmPassword && <p style={{
                                "color": "#ef4444",
                                "fontSize": "0.85rem",
                                "margin": "0.5rem 0 0 0",
                                "display": "flex",
                                "alignItems": "center",
                                "gap": "0.5rem"
                            }}>
                                ⚠️ {errors.confirmPassword.message}
                            </p>}
                        </div>
                    )}
                </div>

               
                <div style={{"marginBottom": "2rem"}}>
                    <div style={{
                        "marginBottom": "1rem",
                        "padding": "1rem",
                        "backgroundColor": "#f3f4f6",
                        "borderRadius": "8px"
                    }}>
                        <label style={{
                            "display": "flex",
                            "alignItems": "flex-start",
                            "gap": "0.75rem",
                            "cursor": "pointer",
                            "fontSize": "0.95rem"
                        }}>
                            <input
                                type="checkbox"
                                {...agreeToTerms_field}
                                style={{
                                    "marginTop": "0.25rem",
                                    "cursor": "pointer",
                                    "width": "18px",
                                    "height": "18px"
                                }}
                            />
                            <span>
                                I agree to the <span style={{"fontWeight": "600"}}>Terms and Conditions</span> and <span style={{"fontWeight": "600"}}>Privacy Policy</span>
                            </span>
                        </label>
                        {errors.agreeToTerms && <p style={{
                            "color": "#ef4444",
                            "fontSize": "0.85rem",
                            "margin": "0.5rem 0 0 2rem",
                            "display": "flex",
                            "alignItems": "center",
                            "gap": "0.5rem"
                        }}>
                            ⚠️ {errors.agreeToTerms.message}
                        </p>}
                    </div>

                    <label style={{
                        "display": "flex",
                        "alignItems": "flex-start",
                        "gap": "0.75rem",
                        "cursor": "pointer",
                        "fontSize": "0.95rem",
                        "color": "#666"
                    }}>
                        <input
                            type="checkbox"
                            {...agreeToNewsletter_field}
                            style={{
                                "marginTop": "0.25rem",
                                "cursor": "pointer",
                                "width": "18px",
                                "height": "18px"
                            }}
                        />
                        <span>
                            Send me updates and news about your service (optional)
                        </span>
                    </label>
                </div>

              
                <button
                    type="submit"
                    disabled={isSubmitting || not isValid}
                    style={{
                        "width": "100%",
                        "padding": "0.875rem",
                        "fontSize": "1rem",
                        "fontWeight": "600",
                        "backgroundColor": ("#3b82f6" if not (isSubmitting or not isValid) else "#93c5fd"),
                        "color": "white",
                        "border": "none",
                        "borderRadius": "8px",
                        "cursor": ("pointer" if not (isSubmitting or not isValid) else "not-allowed"),
                        "transition": "background-color 0.3s",
                        "fontFamily": "system-ui, -apple-system, sans-serif"
                    }}>
                    {"Processing..." if isSubmitting else "Create Account"}
                </button>
            </form>
        </div>);
}
