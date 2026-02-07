"""login - Entry Point.

Combines server-side endpoints with client-side UI.
"""


# Client-side UI
cl {
    import from .RegForm { RegForm }
    import from .SignupForm { SignupForm }
    import from "@jac/runtime" { Router, Routes, Route }

    def:pub app -> JsxElement {
        return <Router>
            <div>
                <Routes>
                    <Route
                        path="/"
                        element={<SignupForm />}
                    />
                    <Route
                        path="/register"
                        element={<RegForm />}
                    />
                </Routes>
            </div>
        </Router>;
    }
}
