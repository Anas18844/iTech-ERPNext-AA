# ERPNext UI Documentation

> Comprehensive guide to the UI architecture, structure, and implementation of ERPNext v15

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Technology Stack](#technology-stack)
- [Directory Structure](#directory-structure)
- [Frontend Framework](#frontend-framework)
- [UI Components](#ui-components)
- [JavaScript Organization](#javascript-organization)
- [Templates & HTML](#templates--html)
- [Styling System](#styling-system)
- [Configuration](#configuration)
- [Development Patterns](#development-patterns)
- [Best Practices](#best-practices)

---

## Architecture Overview

ERPNext is built on the **Frappe Framework**, a custom full-stack Python framework designed specifically for business applications.

### Core Architecture Pattern

```
┌─────────────────────────────────────┐
│   Client Browser                    │
│  ┌──────────────────────────────┐  │
│  │  JavaScript (jQuery + Vue)   │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  CSS (SCSS + CSS Variables)  │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
              ↕ AJAX/HTTP
┌─────────────────────────────────────┐
│   Frappe Server                     │
│  ┌──────────────────────────────┐  │
│  │  Jinja2 Templates            │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  Python Controllers          │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  MariaDB Database            │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

### UI Rendering Strategy

**Hybrid Approach:**
1. **Server-side rendering** - Initial page load with Jinja2 templates
2. **Client-side enhancement** - JavaScript for interactivity and AJAX
3. **Progressive enhancement** - Works without JavaScript for basic functionality

---

## Technology Stack

### JavaScript Libraries

| Library | Purpose | Usage |
|---------|---------|-------|
| **jQuery** | DOM manipulation, AJAX | Core framework dependency |
| **Vue.js** | Reactive components | Selective use for complex UIs |
| **moment.js** | Date/time handling | Throughout the application |
| **Chart.js** | Charts and graphs | Dashboard visualizations |
| **c3.js** | Alternative charting | Report visualizations |
| **Sortable.js** | Drag and drop | List reordering |
| **PhotoSwipe** | Image galleries | Product images, attachments |
| **Gantt** | Timeline views | Project management |
| **onScan.js** | Barcode scanning | Inventory operations |

### CSS Technologies

- **SCSS** - CSS preprocessor for maintainable styles
- **CSS Grid** - Modern layout system
- **Flexbox** - Component layouts
- **CSS Variables** - Theming and customization
- **Bootstrap Grid** - Responsive framework (Frappe provides)

### Build System

- **Frappe CLI** - Builds and bundles assets
- **Bundle files** - `.bundle.js` and `.bundle.scss` for optimization
- **Asset pipeline** - Automatic minification and concatenation

---

## Directory Structure

```
erpnext/
│
├── public/                      # Static frontend assets
│   ├── js/                      # JavaScript files (52 files, ~4,000 lines)
│   │   ├── controllers/         # Base controllers for DocTypes
│   │   │   ├── transaction.js
│   │   │   ├── taxes_and_totals.js
│   │   │   ├── buying.js
│   │   │   ├── selling.js
│   │   │   ├── stock_controller.js
│   │   │   └── accounts.js
│   │   │
│   │   ├── utils/               # Utility functions
│   │   │   ├── party.js
│   │   │   ├── item_selector.js
│   │   │   ├── barcode_scanner.js
│   │   │   ├── serial_no_batch_selector.js
│   │   │   ├── customer_quick_entry.js
│   │   │   ├── crm_activities.js
│   │   │   └── ledger_preview.js
│   │   │
│   │   ├── erpnext.bundle.js    # Main application bundle
│   │   ├── point-of-sale.bundle.js
│   │   ├── bank-reconciliation-tool.bundle.js
│   │   └── item-dashboard.bundle.js
│   │
│   ├── scss/                    # Styling files (8 files)
│   │   ├── erpnext.bundle.scss
│   │   ├── erpnext.scss         # Core styles (604 lines)
│   │   ├── point-of-sale.scss   # POS interface
│   │   ├── website.scss         # Public website
│   │   ├── order-page.scss
│   │   └── call_popup.scss
│   │
│   ├── images/                  # Image assets
│   │   ├── erpnext-logo.svg
│   │   ├── erpnext-favicon.svg
│   │   └── [illustrations, icons]
│   │
│   └── sounds/                  # Audio notifications
│       └── bell.mp3
│
├── templates/                   # Jinja2 templates (109 files)
│   ├── includes/
│   │   └── macros.html          # Reusable template macros (400 lines)
│   │
│   ├── generators/              # Web page generators
│   │   ├── bom.html
│   │   └── sales_partner.html
│   │
│   ├── emails/                  # Email templates
│   │   ├── confirm_appointment.html
│   │   └── [various email templates]
│   │
│   ├── print_formats/           # Print layouts
│   │   └── includes/
│   │       ├── items.html
│   │       ├── taxes.html
│   │       └── total.html
│   │
│   ├── form_grid/               # Grid row templates
│   │   ├── item_grid.html
│   │   ├── material_request_grid.html
│   │   └── stock_entry_grid.html
│   │
│   └── pages/                   # Static pages
│
├── www/                         # Web routes and public pages
│   ├── book_appointment/        # Appointment booking UI
│   ├── support/                 # Support portal
│   └── [various portal pages]
│
└── [modules]/                   # Business modules
    ├── accounts/
    ├── stock/
    ├── selling/
    ├── buying/
    └── [etc]
        ├── page/                # Custom pages per module
        │   └── point_of_sale/   # Example: POS application
        │       ├── pos_controller.js
        │       ├── pos_item_cart.js
        │       ├── pos_payment.js
        │       └── [12 files total]
        │
        ├── doctype/             # DocType customizations
        │   └── [doctype_name]/
        │       ├── [doctype_name].js        # Client-side logic
        │       ├── [doctype_name]_list.js   # List view customization
        │       └── [doctype_name]_dashboard.py
        │
        └── report/              # Custom reports (52 total)
            └── [report_name]/
                ├── [report_name].js
                └── [report_name].py
```

---

## Frontend Framework

### Frappe Framework Concepts

#### 1. DocTypes (Document Types)

DocTypes are the core entity model in Frappe. Each DocType has:

```javascript
// Client-side DocType controller
frappe.ui.form.on('Sales Invoice', {
    refresh: function(frm) {
        // Called when form loads
    },

    onload: function(frm) {
        // Called on first load
    },

    customer: function(frm) {
        // Called when customer field changes
    }
});
```

#### 2. Pages

Custom full-page applications:

```javascript
frappe.pages['point-of-sale'].on_page_load = function(wrapper) {
    var page = frappe.ui.make_app_page({
        parent: wrapper,
        title: 'Point of Sale',
        single_column: true
    });

    // Initialize page controller
    new erpnext.PointOfSale.Controller(wrapper);
}
```

#### 3. Workspaces

JSON-based dashboard configuration:

```json
{
    "name": "Selling",
    "category": "Modules",
    "cards": [
        {
            "type": "shortcut",
            "label": "Sales Order",
            "link_to": "Sales Order"
        }
    ]
}
```

---

## UI Components

### 1. Point of Sale (POS) System

**Location:** `erpnext/selling/page/point_of_sale/`

**Components:**

```javascript
// Main controller
erpnext.PointOfSale.Controller
├── erpnext.PointOfSale.ItemSelector      // Product grid
├── erpnext.PointOfSale.ItemCart          // Shopping cart
├── erpnext.PointOfSale.Payment           // Payment interface
├── erpnext.PointOfSale.NumberPad         // Numeric input
├── erpnext.PointOfSale.PastOrderList     // Order history
└── erpnext.PointOfSale.ItemDetails       // Product details
```

**Features:**
- Grid-based product selection
- Real-time cart updates
- Multiple payment methods
- Barcode scanning support
- Customer selection and creation
- Receipt printing

**Usage Pattern:**

```javascript
class Controller {
    constructor(wrapper) {
        this.wrapper = $(wrapper);
        this.page = wrapper.page;
        this.check_opening_entry();
    }

    init_item_selector() {
        this.item_selector = new erpnext.PointOfSale.ItemSelector({
            wrapper: this.$components_wrapper,
            pos_profile: this.pos_profile,
            settings: this.settings,
            events: {
                item_selected: (item) => this.on_item_selected(item)
            }
        });
    }
}
```

### 2. BOM Configurator

**Location:** `erpnext/manufacturing/page/bom_configurator/`

**Purpose:** Visual Bill of Materials builder with tree structure

**Features:**
- Drag-and-drop component organization
- Real-time cost calculation
- Multi-level BOM support
- Material requirement planning

### 3. Bank Reconciliation Tool

**Location:** `erpnext/accounts/page/bank_reconciliation/`

**Features:**
- Statement import
- Transaction matching
- Automated reconciliation
- Manual adjustment interface

### 4. Dashboard Widgets

**Chart Types:**
- Line charts (trend analysis)
- Bar charts (comparisons)
- Pie charts (distributions)
- Heatmaps (utilization)

**Configuration:**

```python
# In doctype_dashboard.py
def get_data():
    return {
        'fieldname': 'sales_order',
        'transactions': [
            {'label': 'Fulfillment', 'items': ['Sales Invoice', 'Delivery Note']},
            {'label': 'Purchasing', 'items': ['Material Request', 'Purchase Order']}
        ]
    }
```

### 5. Item Selector

**Location:** `erpnext/public/js/utils/item_selector.js`

**Purpose:** Universal item selection dialog

**Features:**
- Search and filter
- Grid or list view
- Barcode scanning
- Batch and serial number selection
- Stock availability display

**Usage:**

```javascript
new erpnext.ItemSelector({
    item_code: frm.doc.item_code,
    callback: function(item) {
        // Handle selected item
        frm.set_value('item_code', item.item_code);
    }
});
```

### 6. Form Grids

Inline editable tables in forms:

**Template Location:** `erpnext/templates/form_grid/`

**Example:** `item_grid.html`

```html
<div class="row">
    <div class="col-sm-12">
        <div class="form-group">
            <div class="clearfix">
                <label class="control-label">
                    {{ _("Item Code") }}
                </label>
            </div>
            <div class="control-value">
                {{ doc.item_code }}
            </div>
        </div>
    </div>
</div>
```

---

## JavaScript Organization

### Controller Pattern

**Base Controllers:** `erpnext/public/js/controllers/`

```javascript
// Transaction Controller (base for all transactions)
erpnext.TransactionController = class TransactionController extends frappe.ui.form.Controller {
    onload() {
        // Initialize form
    }

    setup() {
        // Setup field properties
    }

    refresh() {
        // Update UI on refresh
    }

    calculate_taxes_and_totals() {
        // Tax calculations
    }
}

// Selling Controller (extends Transaction)
erpnext.selling.SellingController = class SellingController extends erpnext.TransactionController {
    setup() {
        super.setup();
        // Selling-specific setup
    }
}

// Sales Invoice (extends Selling)
erpnext.accounts.SalesInvoiceController = class SalesInvoiceController
    extends erpnext.selling.SellingController {
    refresh() {
        super.refresh();
        // Sales invoice specific logic
    }
}
```

### Utility Modules

**Module Pattern:**

```javascript
// Create namespace
frappe.provide("erpnext.utils");

// Define utility
erpnext.utils.party = {
    get_party_details: function(frm, method, args, callback) {
        // Implementation
    },

    set_taxes: function(frm, method, args) {
        // Implementation
    }
};
```

### Event System

**Global Events:**

```javascript
// Listen for events
$(document).on('app_ready', function() {
    // App initialized
});

// Frappe events
frappe.realtime.on('doc_update', function(data) {
    // Document updated in real-time
});
```

### AJAX Pattern

```javascript
frappe.call({
    method: 'erpnext.accounts.doctype.sales_invoice.sales_invoice.get_bank_cash_account',
    args: {
        mode_of_payment: mode_of_payment,
        company: company
    },
    callback: function(r) {
        if (r.message) {
            // Handle response
        }
    }
});
```

---

## Templates & HTML

### Jinja2 Macros

**Location:** `erpnext/templates/includes/macros.html`

**Common Macros:**

```jinja
{%- macro product_image_square(website_item, css_class="") -%}
<div class="product-image {{ css_class }}">
    <img src="{{ website_item.website_image or website_item.image }}"
         alt="{{ website_item.item_name }}">
</div>
{%- endmacro -%}

{%- macro item_card(item, settings) -%}
<div class="col-sm-4 item-card">
    {{ product_image_square(item) }}
    <div class="item-name">{{ item.item_name }}</div>
    <div class="item-price">{{ item.formatted_price }}</div>
</div>
{%- endmacro -%}

{%- macro ratings_with_title(average, reviews) -%}
<div class="ratings">
    {% for i in range(5) %}
        <i class="fa fa-star{% if i >= average %}-o{% endif %}"></i>
    {% endfor %}
    <span class="review-count">({{ reviews }})</span>
</div>
{%- endmacro -%}
```

### Template Inheritance

```jinja
{% extends "templates/web.html" %}

{% block title %}{{ doc.item_name }}{% endblock %}

{% block page_content %}
<div class="product-page">
    {{ product_image_square(doc) }}
    <h1>{{ doc.item_name }}</h1>
    <p>{{ doc.description }}</p>
</div>
{% endblock %}
```

### Print Format Templates

**Location:** `erpnext/templates/print_formats/includes/`

```jinja
{# items.html #}
<table class="table table-bordered">
    <thead>
        <tr>
            <th>Item</th>
            <th>Qty</th>
            <th>Rate</th>
            <th>Amount</th>
        </tr>
    </thead>
    <tbody>
        {% for item in doc.items %}
        <tr>
            <td>{{ item.item_name }}</td>
            <td>{{ item.qty }}</td>
            <td>{{ item.rate }}</td>
            <td>{{ item.amount }}</td>
        </tr>
        {% endfor %}
    </tbody>
</table>
```

---

## Styling System

### SCSS Architecture

**Main Bundle:** `erpnext/public/scss/erpnext.bundle.scss`

```scss
// Import core styles
@import "erpnext";
@import "call_popup";
@import "point-of-sale";
```

### Core Styles

**File:** `erpnext/public/scss/erpnext.scss` (604 lines)

**Structure:**

```scss
// CSS Variables for theming
:root {
    --primary: #e74c3c;
    --secondary: #95a5a6;
    --success: #27ae60;
    --danger: #c0392b;
    --border-color: #d1d8dd;
}

// Dashboard components
.desk-page .main-section {
    padding: 15px;
}

// POS Interface
.pos-card {
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 15px;
}

// Healthcare-specific
.exercise-card {
    display: flex;
    align-items: center;
    padding: 10px;

    .exercise-image {
        width: 80px;
        height: 80px;
        object-fit: cover;
    }
}

// Plant floor visualization
.plant-floor {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 15px;

    .workstation {
        border: 2px solid var(--border-color);
        padding: 15px;

        &.active {
            border-color: var(--success);
        }

        &.idle {
            border-color: var(--secondary);
        }
    }
}
```

### Point of Sale Styling

**File:** `erpnext/public/scss/point-of-sale.scss`

```scss
.pos-page {
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 20px;
    height: calc(100vh - 60px);

    @media (max-width: 991px) {
        grid-template-columns: 1fr;
    }
}

.pos-item-selector {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 15px;

    .item-card {
        border: 1px solid var(--border-color);
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.2s;

        &:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .item-image {
            width: 100%;
            height: 120px;
            object-fit: cover;
        }

        .item-name {
            padding: 10px;
            font-weight: 500;
        }

        .item-price {
            padding: 0 10px 10px;
            color: var(--primary);
            font-size: 1.1em;
        }
    }
}

.pos-cart {
    background: white;
    border-left: 1px solid var(--border-color);
    display: flex;
    flex-direction: column;

    .cart-items {
        flex: 1;
        overflow-y: auto;
    }

    .cart-totals {
        border-top: 2px solid var(--border-color);
        padding: 15px;

        .grand-total {
            font-size: 1.5em;
            font-weight: bold;
            color: var(--primary);
        }
    }
}

.number-pad {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 10px;

    button {
        padding: 20px;
        font-size: 1.2em;
        border: 1px solid var(--border-color);
        background: white;
        cursor: pointer;

        &:hover {
            background: var(--primary);
            color: white;
        }
    }
}
```

### Responsive Design

```scss
// Mobile breakpoints
@media (max-width: 767px) {
    .pos-page {
        grid-template-columns: 1fr;
    }

    .item-card {
        min-width: 120px !important;
    }
}

// Tablet breakpoints
@media (min-width: 768px) and (max-width: 991px) {
    .pos-item-selector {
        grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
    }
}
```

### CSS Variables for Theming

```scss
// Define custom theme
:root {
    --primary: #2e7d32;        // Green theme
    --text-color: #212121;
    --bg-color: #ffffff;
    --border-color: #e0e0e0;
}

// Dark mode support
[data-theme="dark"] {
    --primary: #66bb6a;
    --text-color: #ffffff;
    --bg-color: #1e1e1e;
    --border-color: #424242;
}
```

---

## Configuration

### hooks.py

**Location:** `erpnext/hooks.py` (669 lines)

**Key Configurations:**

```python
# Application metadata
app_name = "erpnext"
app_title = "ERPNext"
app_publisher = "Frappe Technologies Pvt. Ltd."
app_description = "Open Source ERP"
app_icon = "fa fa-th"
app_color = "#e74c3c"
app_email = "info@erpnext.com"
app_license = "GNU General Public License (v3)"

# Frontend assets
app_include_js = "erpnext.bundle.js"
app_include_css = "erpnext.bundle.css"
web_include_js = "erpnext-web.bundle.js"
web_include_css = "erpnext-web.bundle.css"

# DocType-specific JavaScript
doctype_js = {
    "Address": "public/js/address.js",
    "Communication": "public/js/communication.js",
    "Event": "public/js/event.js",
    "Newsletter": "public/js/newsletter.js",
    "Contact": "public/js/contact.js",
}

# DocType-specific List JavaScript
doctype_list_js = {
    "Sales Order": "selling/doctype/sales_order/sales_order_list.js",
    "Sales Invoice": "accounts/doctype/sales_invoice/sales_invoice_list.js",
    "Purchase Order": "buying/doctype/purchase_order/purchase_order_list.js",
}

# Calendars (for Calendar view)
calendars = [
    "Task",
    "Work Order",
    "Leave Application",
    "Sales Order",
    "Holiday List",
]

# Website settings
website_context = {
    "favicon": "/assets/erpnext/images/erpnext-favicon.svg",
    "splash_image": "/assets/erpnext/images/erpnext-logo.svg",
}

# Background jobs
scheduler_events = {
    "cron": {
        "0 0 * * *": [
            "erpnext.accounts.doctype.gl_entry.gl_entry.rename_gle_sle_docs"
        ]
    },
    "daily": [
        "erpnext.stock.reorder_item.reorder_item"
    ]
}

# Permissions
permission_query_conditions = {
    "Event": "erpnext.event.get_permission_query_conditions",
}

# Fixtures (default data)
fixtures = [
    "Workflow",
    "Workflow State",
    "Custom Field",
]
```

### .eslintrc

```json
{
    "env": {
        "browser": true,
        "es2022": true,
        "node": true
    },
    "extends": "eslint:recommended",
    "globals": {
        "frappe": "readonly",
        "Vue": "readonly",
        "$": "readonly",
        "jQuery": "readonly",
        "moment": "readonly",
        "Chart": "readonly"
    },
    "parserOptions": {
        "ecmaVersion": 2022,
        "sourceType": "module"
    },
    "rules": {
        "indent": ["error", "tab"],
        "linebreak-style": ["error", "unix"],
        "quotes": ["error", "double"],
        "semi": ["error", "always"]
    }
}
```

### package.json

```json
{
    "name": "erpnext",
    "version": "15.0.0",
    "description": "Open Source ERP",
    "main": "index.js",
    "scripts": {
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "dependencies": {
        "onscan.js": "^1.5.2"
    },
    "devDependencies": {},
    "keywords": ["erp", "frappe"],
    "author": "Frappe Technologies",
    "license": "GPL-3.0"
}
```

---

## Development Patterns

### 1. Creating a Custom DocType Form

**Step 1:** Create JavaScript file

**Location:** `erpnext/[module]/doctype/[doctype_name]/[doctype_name].js`

```javascript
frappe.ui.form.on('Your DocType', {
    // Called when form loads
    refresh: function(frm) {
        // Add custom buttons
        if (frm.doc.docstatus === 1) {
            frm.add_custom_button(__('Create Invoice'), function() {
                // Button action
            });
        }

        // Set field properties
        frm.set_df_property('field_name', 'read_only', 1);

        // Add filters to link fields
        frm.set_query('item_code', function() {
            return {
                filters: {
                    'is_sales_item': 1
                }
            };
        });
    },

    // Called on first load only
    onload: function(frm) {
        // Initialize
    },

    // Called before form is displayed
    setup: function(frm) {
        // Setup field options, queries, etc.
    },

    // Field-specific triggers
    customer: function(frm) {
        // Called when customer field changes
        if (frm.doc.customer) {
            frappe.call({
                method: 'get_customer_details',
                args: {
                    customer: frm.doc.customer
                },
                callback: function(r) {
                    frm.set_value('customer_name', r.message.customer_name);
                }
            });
        }
    },

    // Child table events
    items_add: function(frm, cdt, cdn) {
        // Called when row added to items table
    },

    items_remove: function(frm, cdt, cdn) {
        // Called when row removed from items table
    }
});

// Child table field events
frappe.ui.form.on('Your DocType Item', {
    item_code: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        // Handle item selection in child table
    },

    qty: function(frm, cdt, cdn) {
        let row = locals[cdt][cdn];
        row.amount = row.qty * row.rate;
        frm.refresh_field('items');
    }
});
```

### 2. Creating a Custom Page

**Step 1:** Create page directory

**Location:** `erpnext/[module]/page/[page_name]/`

**Step 2:** Create `[page_name].py`

```python
from frappe import _

def get_data():
    return {
        "name": "page-name",
        "title": _("Page Title"),
        "route": "page-name",
        "icon": "fa fa-chart",
        "type": "page",
        "is_standard": 1
    }
```

**Step 3:** Create `[page_name].js`

```javascript
frappe.pages['page-name'].on_page_load = function(wrapper) {
    var page = frappe.ui.make_app_page({
        parent: wrapper,
        title: 'Page Title',
        single_column: true
    });

    // Create page controller
    new PageController(wrapper, page);
}

class PageController {
    constructor(wrapper, page) {
        this.wrapper = $(wrapper);
        this.page = page;
        this.make();
    }

    make() {
        // Create UI
        this.$container = $('<div class="page-content"></div>')
            .appendTo(this.wrapper.find('.page-content'));

        this.render();
    }

    render() {
        // Render content
        this.$container.html(`
            <div class="custom-page">
                <h2>Welcome to Custom Page</h2>
            </div>
        `);
    }
}
```

**Step 4:** Create `[page_name].html` (optional template)

```html
<div class="custom-page-layout">
    <div class="sidebar">
        <!-- Sidebar content -->
    </div>
    <div class="main-content">
        <!-- Main content -->
    </div>
</div>
```

### 3. Creating Custom List Views

**Location:** `erpnext/[module]/doctype/[doctype_name]/[doctype_name]_list.js`

```javascript
frappe.listview_settings['Your DocType'] = {
    // Add custom buttons
    add_fields: ['status', 'customer', 'grand_total'],

    // Custom filters
    get_indicator: function(doc) {
        if (doc.status === 'Open') {
            return [__('Open'), 'orange', 'status,=,Open'];
        } else if (doc.status === 'Completed') {
            return [__('Completed'), 'green', 'status,=,Completed'];
        }
    },

    // Custom button in list view
    onload: function(listview) {
        listview.page.add_inner_button(__('Custom Action'), function() {
            // Action for selected items
            let selected = listview.get_checked_items();
            // Process selected items
        });
    },

    // Format list columns
    formatters: {
        grand_total: function(value) {
            return format_currency(value);
        }
    }
};
```

### 4. Creating Dashboards

**Location:** `erpnext/[module]/doctype/[doctype_name]/[doctype_name]_dashboard.py`

```python
from frappe import _

def get_data():
    return {
        'fieldname': 'sales_order',
        'non_standard_fieldnames': {
            'Payment Entry': 'reference_name',
            'Journal Entry': 'reference_name',
        },
        'internal_links': {
            'Quotation': ['items', 'prevdoc_docname'],
        },
        'transactions': [
            {
                'label': _('Fulfillment'),
                'items': ['Sales Invoice', 'Delivery Note', 'Work Order']
            },
            {
                'label': _('Purchasing'),
                'items': ['Material Request', 'Purchase Order']
            },
            {
                'label': _('Payment'),
                'items': ['Payment Entry', 'Journal Entry']
            },
        ]
    }
```

### 5. Custom Server-Side Methods

**Location:** `erpnext/[module]/doctype/[doctype_name]/[doctype_name].py`

```python
import frappe
from frappe.model.document import Document

class YourDocType(Document):
    @frappe.whitelist()
    def custom_method(self):
        """Custom server-side method callable from client"""
        # Implementation
        return {"status": "success"}

@frappe.whitelist()
def global_method(doctype, name):
    """Global method callable from any client code"""
    doc = frappe.get_doc(doctype, name)
    # Process document
    return doc.as_dict()
```

**Calling from JavaScript:**

```javascript
// Call instance method
frm.call({
    method: 'custom_method',
    doc: frm.doc,
    callback: function(r) {
        // Handle response
    }
});

// Call global method
frappe.call({
    method: 'erpnext.module.doctype.your_doctype.your_doctype.global_method',
    args: {
        doctype: 'Your DocType',
        name: 'DOC-001'
    },
    callback: function(r) {
        // Handle response
    }
});
```

---

## Best Practices

### 1. JavaScript Best Practices

#### Use Frappe's Utility Functions

```javascript
// Good - Use Frappe utilities
frappe.show_alert({
    message: __('Document saved successfully'),
    indicator: 'green'
});

frappe.throw(__('Invalid value'));

frappe.msgprint(__('Please select a customer'));

frappe.confirm(
    __('Are you sure you want to delete this item?'),
    function() { /* Yes */ },
    function() { /* No */ }
);

// Bad - Don't use native alert/confirm
alert('Document saved');
if (confirm('Delete?')) { }
```

#### Translation Support

```javascript
// Always wrap strings for translation
__('Customer')
__('Total Amount: {0}', [amount])
__('Items')

// In templates
{{ _("Customer Name") }}
```

#### Async/Await Pattern

```javascript
// Modern async pattern
async refresh(frm) {
    try {
        let customer_details = await frappe.db.get_value('Customer',
            frm.doc.customer,
            ['customer_name', 'territory']
        );

        frm.set_value('customer_name', customer_details.customer_name);
    } catch (error) {
        frappe.msgprint(__('Error fetching customer details'));
    }
}
```

### 2. CSS/SCSS Best Practices

#### Use CSS Variables

```scss
// Define variables
:root {
    --card-padding: 15px;
    --card-border: 1px solid var(--border-color);
    --card-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

// Use variables
.card {
    padding: var(--card-padding);
    border: var(--card-border);
    box-shadow: var(--card-shadow);
}
```

#### Mobile-First Responsive Design

```scss
// Mobile first (default styles for mobile)
.container {
    padding: 10px;
}

// Tablet and up
@media (min-width: 768px) {
    .container {
        padding: 20px;
    }
}

// Desktop and up
@media (min-width: 992px) {
    .container {
        padding: 30px;
        max-width: 1200px;
    }
}
```

#### Component-Based SCSS

```scss
// Component: card.scss
.card {
    border: 1px solid var(--border-color);
    border-radius: 4px;

    &__header {
        padding: 15px;
        border-bottom: 1px solid var(--border-color);
    }

    &__body {
        padding: 15px;
    }

    &__footer {
        padding: 15px;
        border-top: 1px solid var(--border-color);
    }

    // Modifiers
    &--highlighted {
        border-color: var(--primary);
        box-shadow: 0 0 0 2px rgba(var(--primary-rgb), 0.1);
    }
}
```

### 3. Template Best Practices

#### Use Macros for Reusability

```jinja
{# Define macro #}
{% macro render_field(label, value, type="text") %}
<div class="field-group">
    <label>{{ _(label) }}</label>
    <div class="field-value" data-type="{{ type }}">
        {{ value }}
    </div>
</div>
{% endmacro %}

{# Use macro #}
{{ render_field("Customer", doc.customer_name) }}
{{ render_field("Amount", doc.grand_total, "currency") }}
```

#### Conditional Rendering

```jinja
{% if doc.status == "Open" %}
    <span class="badge badge-warning">Open</span>
{% elif doc.status == "Completed" %}
    <span class="badge badge-success">Completed</span>
{% else %}
    <span class="badge badge-secondary">{{ doc.status }}</span>
{% endif %}
```

#### Loop with Counter

```jinja
{% for item in doc.items %}
<tr class="{% if loop.index % 2 == 0 %}even{% else %}odd{% endif %}">
    <td>{{ loop.index }}</td>
    <td>{{ item.item_name }}</td>
    <td>{{ item.qty }}</td>
</tr>
{% endfor %}
```

### 4. Performance Best Practices

#### Debounce User Input

```javascript
// Debounce function
let timeout;
frappe.ui.form.on('Your DocType', {
    search_query: function(frm) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            // Perform search after user stops typing
            perform_search(frm.doc.search_query);
        }, 300);
    }
});
```

#### Lazy Loading

```javascript
// Load data only when needed
let cached_data = null;

function get_data() {
    if (cached_data) {
        return Promise.resolve(cached_data);
    }

    return frappe.call({
        method: 'get_large_dataset',
        callback: function(r) {
            cached_data = r.message;
        }
    });
}
```

#### Batch Operations

```javascript
// Bad - Multiple individual calls
items.forEach(item => {
    frappe.call({
        method: 'process_item',
        args: { item: item }
    });
});

// Good - Single batch call
frappe.call({
    method: 'process_items_batch',
    args: { items: items }
});
```

### 5. Security Best Practices

#### Input Validation

```javascript
// Validate before submission
frappe.ui.form.on('Your DocType', {
    validate: function(frm) {
        if (!frm.doc.customer) {
            frappe.throw(__('Customer is required'));
        }

        if (frm.doc.grand_total < 0) {
            frappe.throw(__('Amount cannot be negative'));
        }

        // Validate email format
        if (frm.doc.email && !frappe.validate_email(frm.doc.email)) {
            frappe.throw(__('Invalid email address'));
        }
    }
});
```

#### XSS Prevention

```javascript
// Bad - Directly inserting user input
$('.container').html(user_input);

// Good - Escape HTML
$('.container').text(user_input);

// Or use Frappe's escaping
$('.container').html(frappe.utils.escape_html(user_input));
```

#### SQL Injection Prevention

```python
# Bad - String concatenation
frappe.db.sql("SELECT * FROM `tabCustomer` WHERE name = '%s'" % customer_name)

# Good - Parameterized query
frappe.db.sql("SELECT * FROM `tabCustomer` WHERE name = %s", (customer_name,))

# Better - Use ORM methods
frappe.get_all('Customer', filters={'name': customer_name})
```

---

## Common Tasks Reference

### Adding a Custom Field Programmatically

```javascript
// In form refresh
frm.add_custom_button(__('Custom Action'), function() {
    // Action
}, __('Actions'));  // Button group
```

### Filtering Link Fields

```javascript
frm.set_query('item_code', 'items', function(doc, cdt, cdn) {
    let row = locals[cdt][cdn];
    return {
        filters: {
            'is_sales_item': 1,
            'disabled': 0
        }
    };
});
```

### Formatting Currency

```javascript
// Format currency
format_currency(1000, 'USD');  // $1,000.00

// In forms
frm.format_currency(1000, frm.doc.currency);
```

### Working with Child Tables

```javascript
// Add row
let row = frm.add_child('items');
row.item_code = 'ITEM-001';
row.qty = 10;
frm.refresh_field('items');

// Remove row
frm.clear_table('items');
frm.refresh_field('items');

// Get all rows
let items = frm.doc.items || [];

// Calculate total
let total = 0;
$.each(frm.doc.items || [], function(i, item) {
    total += item.amount;
});
```

### Database Queries

```javascript
// Get single value
frappe.db.get_value('Customer', customer, 'customer_name')
    .then(r => {
        console.log(r.message.customer_name);
    });

// Get single document
frappe.db.get_doc('Sales Order', 'SO-001')
    .then(doc => {
        console.log(doc);
    });

// Get list
frappe.db.get_list('Item', {
    fields: ['name', 'item_name', 'item_group'],
    filters: {
        'is_sales_item': 1
    },
    limit: 20
}).then(items => {
    console.log(items);
});
```

### Dialog Creation

```javascript
let d = new frappe.ui.Dialog({
    title: __('Enter Details'),
    fields: [
        {
            label: __('Customer'),
            fieldname: 'customer',
            fieldtype: 'Link',
            options: 'Customer',
            reqd: 1
        },
        {
            label: __('Date'),
            fieldname: 'date',
            fieldtype: 'Date',
            default: frappe.datetime.get_today()
        }
    ],
    primary_action_label: __('Submit'),
    primary_action(values) {
        console.log(values);
        d.hide();
    }
});

d.show();
```

---

## Troubleshooting

### Common Issues

#### 1. JavaScript Not Loading

**Problem:** Custom JS not executing

**Solution:**
- Clear browser cache
- Run `bench clear-cache`
- Check browser console for errors
- Verify file path in hooks.py

#### 2. CSS Not Applying

**Problem:** Styles not showing

**Solution:**
- Run `bench build`
- Check SCSS syntax errors
- Verify import in bundle file
- Clear browser cache

#### 3. Template Not Rendering

**Problem:** Jinja template shows errors

**Solution:**
- Check template syntax
- Verify context variables exist
- Look in server logs: `bench --site [site] logs`

#### 4. Permission Errors

**Problem:** "Insufficient Permission" errors

**Solution:**
- Check user roles
- Verify permission rules in DocType
- Check permission_query_conditions in hooks.py

---

## Resources

### Official Documentation
- [Frappe Framework Docs](https://frappeframework.com/docs)
- [ERPNext User Manual](https://docs.erpnext.com)
- [Frappe School](https://frappe.school)

### Developer Resources
- [Frappe GitHub](https://github.com/frappe/frappe)
- [ERPNext GitHub](https://github.com/frappe/erpnext)
- [Frappe Forum](https://discuss.erpnext.com)

### Tools
- **Bench CLI** - Development and deployment tool
- **Browser DevTools** - Debugging frontend code
- **Frappe Desk** - Built-in admin interface

---

## Appendix: File Reference

### Key Files to Know

| File | Purpose |
|------|---------|
| `hooks.py` | Application configuration and hooks |
| `[doctype].js` | Client-side DocType controller |
| `[doctype].py` | Server-side DocType controller |
| `[doctype]_list.js` | List view customization |
| `[doctype]_dashboard.py` | Dashboard configuration |
| `macros.html` | Reusable Jinja macros |
| `erpnext.bundle.js` | Main JavaScript bundle |
| `erpnext.scss` | Core application styles |

### Module Structure Example

```
erpnext/selling/
├── doctype/
│   ├── sales_order/
│   │   ├── sales_order.json          # DocType definition
│   │   ├── sales_order.py            # Server controller
│   │   ├── sales_order.js            # Client controller
│   │   ├── sales_order_list.js       # List customization
│   │   ├── sales_order_dashboard.py  # Dashboard
│   │   └── test_sales_order.py       # Unit tests
│   └── sales_order_item/             # Child DocType
│
├── page/
│   └── point_of_sale/                # Custom page
│       ├── point_of_sale.json
│       ├── point_of_sale.py
│       └── point_of_sale.js
│
├── report/
│   └── sales_analytics/              # Custom report
│       ├── sales_analytics.json
│       ├── sales_analytics.py
│       └── sales_analytics.js
│
└── workspace/
    └── selling/                      # Workspace config
        └── selling.json
```

---

**Document Version:** 1.0
**Last Updated:** 2025-11-08
**ERPNext Version:** 15
**Frappe Framework:** Compatible with v15+
