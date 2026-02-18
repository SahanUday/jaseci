cl import from "@jac/runtime" { JacForm, jacSchema }
cl import ".assets.jacform-default.css";

def:pub AutoEventForm -> JsxElement {
    # Define event registration schema with date, datetime, and enum fields
    eventSchema = jacSchema.object(
        {
            eventName: jacSchema.string().min(3, "Event name must be at least 3 characters").max(
                100, "Event name must not exceed 100 characters"
            ),
            eventType: jacSchema.enum(
                ["conference", "workshop", "seminar", "webinar", "networking"],
                "Please select an event type"
            ),
            eventDate: jacSchema.string().min(1, "Event date is required"),
            startDateTime: jacSchema.string().min(1, "Start date and time is required"),
            endDateTime: jacSchema.string().optional(),
            attendeeName: jacSchema.string().min(1, "Attendee name is required").max(
                100, "Name must not exceed 100 characters"
            ),
            attendeeEmail: jacSchema.string().min(1, "Email is required").email(
                "Please enter a valid email address"
            ),
            ticketType: jacSchema.enum(
                ["general", "vip", "student", "speaker"],
                "Please select a ticket type"
            ),
            numberOfAttendees: jacSchema.number().min(1, "At least 1 attendee required").max(
                10, "Maximum 10 attendees allowed"
            ),
            mealPreference: jacSchema.enum(
                ["vegetarian", "vegan", "non-vegetarian", "gluten-free", "none"],
                "Please select a meal preference"
            ),
            specialRequirements: jacSchema.string().max(
                500, "Special requirements must not exceed 500 characters"
            ).optional(),
            agreeToTerms: jacSchema.boolean().refine(
                lambda v: any  -> bool { return v == True; },
                "You must agree to the event terms and conditions"
            ),
            marketingConsent: jacSchema.boolean().optional()
        }
    );

    # Form submission handler
    async def handleSubmit(data: any) -> None {
        console.log("Event registration submitted:", data);
        # Here you could send the data to an API
        alert("Event registration successful! Check console for submitted data.");
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
                Event Registration
            </h2>
            <p
                style={{
                    "textAlign": "center",
                    "color": "#666",
                    "marginBottom": "2rem",
                    "fontSize": "0.95rem"
                }}
            >
                Auto-rendered form with date, datetime, and select fields
            </p>
            
            <JacForm
                schema={eventSchema}
                onSubmit={handleSubmit}
                layout="grid"
                gridColumns={2}
                className="jac-form"
                submitClassName="jac-form-submit"
                field_config={{
                    "eventName": {
                        label: "Event Name",
                        type: "text",
                        placeholder: "Annual Tech Conference 2026",
                        inputClassName: "jac-form-input"
                    },
                    "eventType": {
                        label: "Event Type",
                        type: "select",
                        placeholder: "Select event type",
                        inputClassName: "jac-form-input"
                    },
                    "eventDate": {
                        label: "Event Date",
                        type: "date",
                        inputClassName: "jac-form-input"
                    },
                    "startDateTime": {
                        label: "Start Date & Time",
                        type: "datetime-local",
                        inputClassName: "jac-form-input"
                    },
                    "endDateTime": {
                        label: "End Date & Time (Optional)",
                        type: "datetime-local",
                        inputClassName: "jac-form-input"
                    },
                    "attendeeName": {
                        label: "Attendee Name",
                        type: "text",
                        placeholder: "John Doe",
                        inputClassName: "jac-form-input"
                    },
                    "attendeeEmail": {
                        label: "Attendee Email",
                        type: "email",
                        placeholder: "john@example.com",
                        inputClassName: "jac-form-input"
                    },
                    "ticketType": {
                        label: "Ticket Type",
                        type: "select",
                        placeholder: "Select ticket type",
                        inputClassName: "jac-form-input"
                    },
                    "numberOfAttendees": {
                        label: "Number of Attendees",
                        type: "number",
                        placeholder: "1",
                        inputClassName: "jac-form-input"
                    },
                    "mealPreference": {
                        label: "Meal Preference",
                        type: "select",
                        placeholder: "Select meal preference",
                        inputClassName: "jac-form-input"
                    },
                    "specialRequirements": {
                        label: "Special Requirements (Optional)",
                        type: "text",
                        placeholder: "Any dietary restrictions, accessibility needs, etc.",
                        inputClassName: "jac-form-input"
                    },
                    "agreeToTerms": {
                        label: "I agree to the event terms and conditions",
                        type: "checkbox"
                    },
                    "marketingConsent": {
                        label: "I would like to receive event updates and marketing emails",
                        type: "checkbox"
                    }
                }}
                submitLabel="Register for Event"
            />
        </div>
    );
}
