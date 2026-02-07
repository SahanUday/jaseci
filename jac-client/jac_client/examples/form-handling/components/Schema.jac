
cl import from "@jac/runtime" { jacSchema }

cl {
    def:pub SignupSchema -> any {
            # Define validation schema
            signupSchema = jacSchema.object({
                email: jacSchema.string().min(1, "Email is required").email("Invalid email address"),
                password: jacSchema.string().min(8, "Password must be at least 8 characters")
                    .regex(RegExp("[A-Z]"), "Password must contain at least one uppercase letter")   # pass regex as string by wrapping RegExp()
                    .regex(RegExp("\d"), "Password must contain at least one number")
                    .regex(RegExp("[^A-Za-z0-9]"), "Password must contain at least one special character"),
                confirmPassword: jacSchema.string().min(8, "Confirm password must be at least 8 characters")
            })
            .refine(lambda data:any -> bool{return data.password == data.confirmPassword;}, {
                message: "Passwords do not match",
                path: ["confirmPassword"], 
            });
            return signupSchema;
    }
    
    def:pub RegisterSchema -> any {
        # Define comprehensive validation schema
        registrationSchema = jacSchema.object({
            firstName: jacSchema.string()
                .min(1, "First name is required")
                .max(50, "First name must not exceed 50 characters"),
            lastName: jacSchema.string()
                .min(1, "Last name is required")
                .max(50, "Last name must not exceed 50 characters"),
            email: jacSchema.string()
                .min(1, "Email is required")
                .email("Please enter a valid email address"),
            phone: jacSchema.string()
                .min(10, "Phone number must be at least 10 digits")
                .regex(RegExp("^[0-9\\-\\+\\(\\)\\s]*$"), "Phone number contains invalid characters"),
            companyName: jacSchema.string()
                .optional()
                .refine(lambda v: any -> bool {
                    return v == None or v == "" or v.length >= 2;
                }, "Company name must be at least 2 characters if provided"),
            address: jacSchema.string()
                .min(5, "Address must be at least 5 characters")
                .max(100, "Address must not exceed 100 characters"),
            city: jacSchema.string()
                .min(2, "City must be at least 2 characters")
                .max(50, "City must not exceed 50 characters"),
            state: jacSchema.string()
                .min(1, "State is required"),
            zipCode: jacSchema.string()
                .regex(RegExp("^[0-9\\-]*$"), "Zip code contains invalid characters"),
            country: jacSchema.string()
                .min(1, "Country is required"),
            password: jacSchema.string()
                .min(8, "Password must be at least 8 characters")
                .regex(RegExp("[A-Z]"), "Password must contain at least one uppercase letter")
                .regex(RegExp("[a-z]"), "Password must contain at least one lowercase letter")
                .regex(RegExp("[0-9]"), "Password must contain at least one number")
                .regex(RegExp("[!@#\\$%\\^&\\*]"), "Password must contain at least one special character (!@#$%^&*)"),
            confirmPassword: jacSchema.string()
                .min(8, "Confirm password must be at least 8 characters"),
            agreeToTerms: jacSchema.boolean()
                .refine(lambda v: any -> bool { return v == True; }, "You must agree to the terms and conditions"),
            agreeToNewsletter: jacSchema.boolean()
                .optional()
        })
        .refine(lambda data:any -> bool { return data.password == data.confirmPassword; }, {
            message: "Passwords do not match",
            path: ["confirmPassword"],
        });
        return registrationSchema;
    }
}