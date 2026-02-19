"""Unit tests for JacForm and useJacForm form handling abstractions."""

import gc;
import os;
import tempfile;
import shutil;
import time;
import pytest;
import from pathlib { Path }
import from subprocess { Popen, run }
import from playwright.sync_api { sync_playwright }

import from .test_helpers {
    get_env_with_npm,
    get_free_port,
    get_jac_command,
    wait_for_port
}

# ---- Test Fixtures ----

def create_test_form_app -> dict {
    """Create a minimal Jac app with form handling for testing.
    
    Returns dict with:
        - temp_dir: temporary directory path
        - app_path: path to the created app
        - original_cwd: original working directory
    """
    jac_cmd = get_jac_command();
    env = get_env_with_npm();
    
    temp_dir = tempfile.mkdtemp();
    original_cwd = os.getcwd();
    
    try {
        os.chdir(temp_dir);
        
        # Create minimal Jac client app
        app_name = "test-form-app";
        create_result = run(
            [*jac_cmd, "create", app_name, "--use", "client"],
            capture_output=True,
            text=True,
            env=env,
        );
        
        if create_result.returncode != 0 {
            pytest.fail(f"Failed to create test app: {create_result.stderr}");
        }
        
        app_path = os.path.join(temp_dir, app_name);
        
        return {
            "temp_dir": temp_dir,
            "app_path": app_path,
            "original_cwd": original_cwd
        };
    } except Exception as e {
        # Cleanup on error
        os.chdir(original_cwd);
        shutil.rmtree(temp_dir, ignore_errors=True);
        raise e;
    }
}

def cleanup_test_app(context: dict) -> None {
    """Cleanup test app created by create_test_form_app."""
    os.chdir(context["original_cwd"]);
    shutil.rmtree(context["temp_dir"], ignore_errors=True);
}

# ---- Basic Form Schema Tests ----

test "jacSchema object creation" {
    """Test basic schema creation with jacSchema."""
    # This test verifies that jacSchema can create basic validation schemas
    # The actual implementation is in client_runtime.impl.jac
    
    # We'll test schema creation by building a test form file
    context = create_test_form_app();
    
    try {
        app_path = context["app_path"];
        
        # Create a test form with basic schema
        test_form_code = '''
cl import from "@jac/runtime" { jacSchema }

cl {
    def:pub testBasicSchema -> any {
        schema = jacSchema.object({
            email: jacSchema.string().email("Invalid email"),
            password: jacSchema.string().min(8, "Min 8 characters")
        });
        return schema;
    }
}
''';
        
        test_file = os.path.join(app_path, "test_schema.jac");
        with open(test_file, "w") as f {
            f.write(test_form_code);
        }
        
        # Compile the test file
        jac_cmd = get_jac_command();
        compile_result = run(
            [*jac_cmd, "build"],
            capture_output=True,
            text=True,
            cwd=app_path,
        );
        
        # Should compile without errors
        assert compile_result.returncode == 0, (
            f"Schema compilation failed:\n{compile_result.stderr}"
        );
        
    } finally {
        cleanup_test_app(context);
    }
}

test "jacSchema validation patterns" {
    """Test schema creation with various validation patterns."""
    context = create_test_form_app();
    
    try {
        app_path = context["app_path"];
        
        # Create test with complex validation
        test_form_code = '''
cl import from "@jac/runtime" { jacSchema }

cl {
    def:pub testComplexSchema -> any {
        schema = jacSchema.object({
            # String validations
            email: jacSchema.string().email("Invalid email"),
            username: jacSchema.string().min(3, "Min 3").max(20, "Max 20"),
            phone: jacSchema.string().regex(RegExp("^[0-9]{10}$"), "10 digits"),
        
        # Number validation
        age: jacSchema.number().min(18, "Must be 18+").max(120, "Invalid"),
        
        # Boolean
        agreed: jacSchema.boolean(),
        
        # Optional
        middleName: jacSchema.string().optional(),
        
        # Enum
        role: jacSchema.enum(["user", "admin", "guest"], "Required")
    });
    
    return schema;
    }
}
''';
        
        test_file = os.path.join(app_path, "test_complex_schema.jac");
        with open(test_file, "w") as f {
            f.write(test_form_code);
        }
        
        # Compile the test file
        jac_cmd = get_jac_command();
        compile_result = run(
            [*jac_cmd, "build"],
            capture_output=True,
            text=True,
            cwd=app_path,
        );
        
        assert compile_result.returncode == 0, (
            f"Complex schema compilation failed:\n{compile_result.stderr}"
        );
        
    } finally {
        cleanup_test_app(context);
    }
}

test "cross field validation with refine" {
    """Test schema with cross-field validation."""
    context = create_test_form_app();
    
    try {
        app_path = context["app_path"];
        
        test_form_code = '''
cl import from "@jac/runtime" { jacSchema }

cl {
    def:pub testRefineSchema -> any {
        schema = jacSchema.object({
            password: jacSchema.string().min(8, "Min 8 characters"),
            confirmPassword: jacSchema.string().min(8, "Min 8 characters")
        }).refine(
            lambda data: any -> bool { 
            return data.password == data.confirmPassword; 
        },
        {
            message: "Passwords must match",
            path: ["confirmPassword"]
        }
    );
    
    return schema;
    }
}
''';
        
        test_file = os.path.join(app_path, "test_refine_schema.jac");
        with open(test_file, "w") as f {
            f.write(test_form_code);
        }
        
        jac_cmd = get_jac_command();
        compile_result = run(
            [*jac_cmd, "build"],
            capture_output=True,
            text=True,
            cwd=app_path,
        );
        
        assert compile_result.returncode == 0, (
            f"Refine schema compilation failed:\n{compile_result.stderr}"
        );
        
    } finally {
        cleanup_test_app(context);
    }
}



# ---- Browser E2E Tests with Playwright ----

def _start_form_example_server -> tuple {
    """Start the form-handling example server and return (process, port, url, cwd)."""
    tests_dir = os.path.dirname(__file__);
    jac_client_root = os.path.dirname(tests_dir);
    form_example_path = os.path.join(jac_client_root, "examples", "form-handling");
    
    if not os.path.isdir(form_example_path) {
        pytest.skip("form-handling example directory not found");
    }
    
    jac_cmd = get_jac_command();
    env = get_env_with_npm();
    original_cwd = os.getcwd();
    
    server_port = get_free_port();
    server = Popen(
        [*jac_cmd, "start", "-p", str(server_port)],
        cwd=form_example_path,
        env=env,
    );
    
    wait_for_port("127.0.0.1", server_port, timeout=120.0);
    time.sleep(5);
    
    return (
        server,
        server_port,
        f"http://127.0.0.1:{server_port}",
        original_cwd
    );
}

def _stop_form_example_server(server: Popen, original_cwd: str) -> None {
    """Stop the form example server and clean up."""
    server.terminate();
    try {
        server.wait(timeout=15);
    } except Exception {
        server.kill();
        server.wait(timeout=5);
    }
    time.sleep(1);
    gc.collect();
    os.chdir(original_cwd);
}

test "E2E: form example renders all field types" {
    """Test that all field types render in the browser."""
    (server, port, url, original_cwd) = _start_form_example_server();
    
    try {
        with sync_playwright() as p {
            browser = p.chromium.launch(headless=True);
            context = browser.new_context();
            page = context.new_page();
            
            try {
                # Navigate to form example
                page.goto(url, wait_until="networkidle", timeout=60000);
                page.wait_for_timeout(2000);
                
                # Check that all field types are present
                assert page.locator('input[type="text"]').count() > 0, "Text input missing";
                assert page.locator('input[type="email"]').count() > 0, "Email input missing";
                assert page.locator('input[type="password"]').count() > 0, "Password input missing";
                assert page.locator('input[type="tel"]').count() > 0, "Tel input missing";
                assert page.locator('input[type="url"]').count() > 0, "URL input missing";
                assert page.locator('input[type="number"]').count() > 0, "Number input missing";
                assert page.locator('input[type="date"]').count() > 0, "Date input missing";
                assert page.locator('input[type="datetime-local"]').count() > 0, "DateTime input missing";
                assert page.locator('select').count() > 0, "Select dropdown missing";
                assert page.locator('input[type="radio"]').count() > 0, "Radio buttons missing";
                assert page.locator('textarea').count() > 0, "Textarea missing";
                assert page.locator('input[type="checkbox"]').count() > 0, "Checkbox missing";
                
                print("[E2E] All field types rendered successfully");
                
            } finally {
                context.close();
                browser.close();
            }
        }
    } finally {
        _stop_form_example_server(server, original_cwd);
    }
}