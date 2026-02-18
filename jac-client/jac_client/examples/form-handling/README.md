# Form Handling Example

Comprehensive demonstration of JacForm auto-rendered forms with all supported field types.

## Quick Start

```bash
cd form-handling
jac client run
```

## What JacForm Offers

- **Auto-rendering** - Generate complete forms from Zod schemas
- **Type-safe validation** - Schema-based validation with Zod
- **Multiple layouts** - Vertical, grid, horizontal, inline
- **Built-in features** - Password toggles, validation errors, field configurations
- **Minimal code** - ~80% less code than manual forms

## Supported Field Types

| Type | Schema | Config |
|------|--------|--------|
| **Text** | `jacSchema.string()` | `type: "text"` |
| **Email** | `jacSchema.string().email()` | `type: "email"` |
| **Password** | `jacSchema.string()` | `type: "password"`, `showPasswordToggle: true` |
| **Tel** | `jacSchema.string()` | `type: "tel"` |
| **URL** | `jacSchema.string().url()` | `type: "url"` |
| **Number** | `jacSchema.number()` | `type: "number"` |
| **Date** | `jacSchema.string()` | `type: "date"` |
| **DateTime** | `jacSchema.string()` | `type: "datetime-local"` |
| **Select** | `jacSchema.enum([...])` | `type: "select"` |
| **Radio** | `jacSchema.enum([...])` | `type: "radio"` |
| **Textarea** | `jacSchema.string()` | `type: "textarea"`, `rows: 4` |
| **Checkbox** | `jacSchema.boolean()` | `type: "checkbox"` |

## Field Configuration Options

- `label` - Field label text
- `placeholder` - Placeholder text
- `type` - Field type (required)
- `rows` - Textarea rows (default: 4)
- `showPasswordToggle` - Show password checkbox (password fields only)
- `className` - Field wrapper CSS class
- `inputClassName` - Input element CSS class
- `labelClassName` - Label element CSS class

## Documentation

For detailed API reference and advanced usage, see [Form Handling Documentation](../../docs/advance/form-handling.md).
