"""form-handling - Entry Point.

Demonstrates both manual form handling and auto-rendered forms using JacForm.
"""

# Client-side UI
cl {
    import from .AutoSignupForm { AutoSignupForm }
    import from .AutoRegForm { AutoRegForm }
    import from .AutoEventForm { AutoEventForm }
    import from .AutoFeedbackForm { AutoFeedbackForm }
    import from "@jac/runtime" { Router, Routes, Route, Link }

    def:pub app -> JsxElement {
        return
            <Router>
                <div style={{fontFamily: "system-ui, -apple-system, sans-serif"}}>
                    <nav
                        style={{
                            backgroundColor: "#1a1a2e",
                            padding: "1rem 2rem",
                            boxShadow: "0 2px 4px rgba(0,0,0,0.1)"
                        }}
                    >
                        <div style={{maxWidth: "1200px", margin: "0 auto"}}>
                            <h1 style={{color: "#fff", margin: "0 0 1rem 0", fontSize: "1.5rem"}}>
                                Jac Form Handling Examples
                            </h1>
                            <div style={{display: "flex", gap: "1rem", flexWrap: "wrap"}}>
                                <Link
                                    to="/auto-signup"
                                    style={{
                                        color: "#10b981",
                                        textDecoration: "none",
                                        padding: "0.5rem 1rem",
                                        backgroundColor: "#fff",
                                        borderRadius: "6px",
                                        fontSize: "0.9rem",
                                        fontWeight: "600"
                                    }}
                                >
                                    ✨ Auto Signup (JacForm)
                                </Link>
                                <Link
                                    to="/auto-register"
                                    style={{
                                        color: "#10b981",
                                        textDecoration: "none",
                                        padding: "0.5rem 1rem",
                                        backgroundColor: "#fff",
                                        borderRadius: "6px",
                                        fontSize: "0.9rem",
                                        fontWeight: "600"
                                    }}
                                >
                                    ✨ Auto Registration (JacForm)
                                </Link>
                                <Link
                                    to="/auto-event"
                                    style={{
                                        color: "#10b981",
                                        textDecoration: "none",
                                        padding: "0.5rem 1rem",
                                        backgroundColor: "#fff",
                                        borderRadius: "6px",
                                        fontSize: "0.9rem",
                                        fontWeight: "600"
                                    }}
                                >
                                    ✨ Auto Event Registration (JacForm)
                                </Link>
                                <Link
                                    to="/auto-feedback"
                                    style={{
                                        color: "#10b981",
                                        textDecoration: "none",
                                        padding: "0.5rem 1rem",
                                        backgroundColor: "#fff",
                                        borderRadius: "6px",
                                        fontSize: "0.9rem",
                                        fontWeight: "600"
                                    }}
                                >
                                    ✨ Feedback Form (Radio & Textarea)
                                </Link>
                            </div>
                        </div>
                    </nav>
                    <Routes>
                        <Route path="/auto-signup" element={<AutoSignupForm />} />
                        <Route path="/auto-register" element={<AutoRegForm />} />
                        <Route path="/auto-event" element={<AutoEventForm />} />
                        <Route path="/auto-feedback" element={<AutoFeedbackForm />} />
                    </Routes>
                </div>
            </Router>;
    }
}
