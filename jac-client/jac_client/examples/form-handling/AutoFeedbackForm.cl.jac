cl import from "@jac/runtime" { JacForm, jacSchema }
cl import ".assets.jacform-default.css";

def:pub AutoFeedbackForm -> JsxElement {
    # Define feedback form schema - only for validation
    feedbackSchema = jacSchema.object(
        {
            name: jacSchema.string().min(2, "Name must be at least 2 characters").max(
                100, "Name must not exceed 100 characters"
            ),
            email: jacSchema.string().min(1, "Email is required").email(
                "Please enter a valid email address"
            ),
            rating: jacSchema.enum(
                ["excellent", "good", "fair", "poor"],
                "Please select a rating"
            ),
            category: jacSchema.enum(
                ["product", "service", "website", "support", "other"],
                "Please select a category"
            ),
            recommend: jacSchema.enum(
                ["yes", "no", "maybe"],
                "Please select an option"
            ),
            comments: jacSchema.string().min(
                10, "Please provide at least 10 characters of feedback"
            ).max(
                1000, "Comments must not exceed 1000 characters"
            ),
            improvements: jacSchema.string().max(
                500, "Suggestions must not exceed 500 characters"
            ).optional(),
            contactMe: jacSchema.boolean().optional()
        }
    );

    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Feedback form submitted:", data);
        alert("Thank you for your feedback! Check console for submitted data.");
    }

    return (
        <div
            style={{
                "maxWidth": "800px",
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
                Customer Feedback Form
            </h2>
            <p
                style={{
                    "textAlign": "center",
                    "color": "#666",
                    "marginBottom": "2rem",
                    "fontSize": "0.95rem"
                }}
            >
                Demonstrating radio buttons and textarea fields
            </p>
            
            <JacForm
                schema={feedbackSchema}
                onSubmit={handleSubmit}
                layout="vertical"
                className="jac-form"
                submitClassName="jac-form-submit"
                field_config={{
                    "name": {
                        label: "Your Name",
                        type: "text",
                        placeholder: "John Doe",
                        inputClassName: "jac-form-input"
                    },
                    "email": {
                        label: "Email Address",
                        type: "email",
                        placeholder: "john@example.com",
                        inputClassName: "jac-form-input"
                    },
                    "rating": {
                        label: "How would you rate your overall experience?",
                        type: "radio",
                        inputClassName: "jac-form-radio"
                    },
                    "category": {
                        label: "Feedback Category",
                        type: "select",
                        placeholder: "Select a category",
                        inputClassName: "jac-form-input"
                    },
                    "recommend": {
                        label: "Would you recommend us to others?",
                        type: "radio",
                        inputClassName: "jac-form-radio"
                    },
                    "comments": {
                        label: "Your Feedback",
                        type: "textarea",
                        placeholder: "Please share your detailed feedback here...",
                        rows: 6,
                        inputClassName: "jac-form-input"
                    },
                    "improvements": {
                        label: "Suggestions for Improvement (Optional)",
                        type: "textarea",
                        placeholder: "What could we do better?",
                        rows: 4,
                        inputClassName: "jac-form-input"
                    },
                    "contactMe": {
                        label: "I would like to be contacted about my feedback",
                        type: "checkbox"
                    }
                }}
                submitLabel="Submit Feedback"
            />
        </div>
    );
}
