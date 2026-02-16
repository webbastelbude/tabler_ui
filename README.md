# Tabler UI

A comprehensive Ruby on Rails component library built on top of Tabler UI framework.

## Features

- 🎨 **Beautiful Components** - Pre-built UI components following Tabler design system
- 🚀 **Rails Integration** - Seamless integration with Rails 7+ applications
- 💎 **Ruby DSL** - Intuitive Ruby syntax for building UIs
- 📱 **Responsive** - Mobile-first design with Bootstrap 5
- ⚡ **Stimulus Ready** - Built-in Stimulus controllers for interactivity
- 🎯 **Customizable** - Easy to customize and extend

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tabler_ui', git: 'https://github.com/yourusername/tabler_ui.git'
```

Then execute:

```bash
bundle install
```

### Asset Setup

Add the Tabler UI stylesheet to your `app/assets/stylesheets/application.css`:

```css
/*
 *= require tabler_ui
 */
```

Add the Tabler UI JavaScript to your `config/importmap.rb`:

```ruby
pin "tabler_ui"
```

And import it in your `app/javascript/application.js`:

```javascript
import "tabler_ui"
```

### Optional: Flags Add-on

For country flags in your application, add to your `app/assets/stylesheets/application.css`:

```css
/*
 *= require tabler_ui/addons/tabler-flags
 */
```

Usage:

```erb
<span class="flag flag-de"></span>
<span class="flag flag-us"></span>
<span class="flag flag-fr"></span>
```

Over 260 country flags available as SVG sprites.

### Optional: ApexCharts for Data Visualization

For interactive charts and data visualization, add to your `app/assets/stylesheets/application.css`:

```css
/*
 *= require apexcharts
 */
```

And import in `app/javascript/application.js`:

```javascript
import "apexcharts"
```

Usage with Stimulus:

```erb
<div data-controller="tabler-ui--chart"
     data-tabler-ui--chart-type-value="line"
     data-tabler-ui--chart-options-value='<%= {
       series: [{ name: "Sales", data: [30, 40, 45, 50, 49, 60, 70, 91] }],
       xaxis: { categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"] }
     }.to_json %>'></div>
```

See CLAUDE.md for comprehensive ApexCharts documentation and examples.

### Stimulus Controllers

If you want to use Tabler UI's Stimulus controllers, import them in your `app/javascript/controllers/index.js`:

```javascript
import { application } from "./application"

// Import Tabler UI controllers
import TablerUiDropdownController from "controllers/tabler_ui/dropdown_controller"
application.register("tabler-ui--dropdown", TablerUiDropdownController)
```

## Usage

Tabler UI provides a `tabler_ui` helper that gives you access to all components.

### Basic Example

```erb
<%= tabler_ui.button text: "Click me", variant: "primary", url: "#" %>
```

### Available Components

#### 1. Navbar

Create a responsive navigation bar with dropdowns:

```erb
<%= tabler_ui.navbar brand: "My App" do |navbar| %>
  <% navbar.left do |nav| %>
    <% nav.add "Dashboard", dashboard_path %>
    <% nav.add "Users", users_path %>
    <% nav.dropdown "Settings" do |dropdown| %>
      <% dropdown.add "Profile", profile_path %>
      <% dropdown.add "Logout", logout_path, method: :delete %>
    <% end %>
  <% end %>

  <% navbar.right do |nav| %>
    <% nav.add "Help", help_path %>
  <% end %>
<% end %>
```

#### 2. Page Header

Display a page title with optional breadcrumbs:

```erb
<%= tabler_ui.page_header do |ph| %>
  <% ph.pretitle = "Overview" %>
  <% ph.title = "Dashboard" %>
<% end %>
```

#### 3. Button

Various button styles and states:

```erb
<!-- Primary button -->
<%= tabler_ui.button text: "Save", variant: "primary", url: save_path %>

<!-- Outline button -->
<%= tabler_ui.button text: "Cancel", variant: "secondary", outline: true, url: cancel_path %>

<!-- Different sizes -->
<%= tabler_ui.button text: "Small", size: "sm", url: "#" %>
<%= tabler_ui.button text: "Large", size: "lg", url: "#" %>

<!-- With POST method -->
<%= tabler_ui.button text: "Delete", variant: "danger", method: :delete, url: delete_path %>

<!-- Disabled -->
<%= tabler_ui.button text: "Disabled", disabled: true, url: "#" %>
```

**Options:**
- `text` - Button label (required)
- `url` - URL to link to (default: "#")
- `variant` - Color variant: primary, secondary, success, warning, danger, info, light, dark (default: "primary")
- `outline` - Use outline style (default: false)
- `size` - Button size: sm, lg (default: normal)
- `shape` - Button shape: pill, square (default: normal)
- `icon_only` - Icon-only button (default: false)
- `method` - HTTP method: get, post, patch, delete (default: :get)
- `target` - Link target attribute
- `disabled` - Disabled state (default: false)
- `class` - Additional CSS classes

#### 4. Card

Container component with header, body, and footer:

```erb
<%= tabler_ui.card title: "User Information" do |card, slots| %>
  <% slots.body do %>
    <p>Card content goes here...</p>
  <% end %>

  <% slots.footer do %>
    <%= tabler_ui.button text: "Save", variant: "primary", url: "#" %>
  <% end %>
<% end %>
```

**Options:**
- `title` - Card title (optional)
- `size` - Card size: md, lg (optional)
- `class` - Additional CSS classes

**Slots:**
- `header` - Custom header content
- `body` - Main card content
- `footer` - Footer content

#### 5. Dropdown

Dropdown menu with items and dividers:

```erb
<%= tabler_ui.dropdown label: "Actions", button_variant: "primary" do |dropdown| %>
  <% dropdown.item "Edit", edit_path %>
  <% dropdown.item "Delete", delete_path, method: :delete %>
  <% dropdown.divider %>
  <% dropdown.header "More Actions" %>
  <% dropdown.item "Archive", archive_path %>
<% end %>
```

**Options:**
- `label` - Dropdown button label (required)
- `button_variant` - Button color variant (default: "primary")
- `align` - Menu alignment: left, right (default: "left")

**Methods:**
- `item(title, url, **options)` - Add dropdown item
- `divider` - Add divider
- `header(title)` - Add header/section title

#### 6. Avatar

Display user avatars with initials or images:

```erb
<!-- With initials -->
<%= tabler_ui.avatar initials: "JD", size: "md" %>

<!-- With image -->
<%= tabler_ui.avatar image: user_avatar_url(@user), size: "lg" %>

<!-- Different sizes -->
<%= tabler_ui.avatar initials: "SM", size: "sm" %>
<%= tabler_ui.avatar initials: "XL", size: "xl" %>
```

**Options:**
- `initials` - Text to display (e.g., "JD" for John Doe)
- `image` - Image URL (overrides initials if provided)
- `size` - Avatar size: sm, md, lg, xl (default: "md")
- `class` - Additional CSS classes

#### 7. Table

Data tables with sorting and actions:

```erb
<%= tabler_ui.table do |table| %>
  <% table.column "Name", :name, sortable: true %>
  <% table.column "Email", :email %>
  <% table.column "Status", :status %>
  <% table.column "Actions" do |user| %>
    <%= link_to "Edit", edit_user_path(user) %>
  <% end %>

  <% table.data @users %>
<% end %>
```

**Options:**
- `column(header, attribute, **options)` - Define table column
  - `sortable` - Enable sorting (default: false)
  - Block - Custom cell rendering
- `data(collection)` - Set data source

## Advanced Usage

### Using Slots

Some components support slots for more complex content:

```erb
<%= tabler_ui.card do |card, slots| %>
  <% slots.header do %>
    <h3 class="card-title">Custom Header</h3>
    <div class="card-actions">
      <%= link_to "Action", "#" %>
    </div>
  <% end %>

  <% slots.body do %>
    <p>Your custom content...</p>
  <% end %>

  <% slots.footer do %>
    <div class="d-flex">
      <%= tabler_ui.button text: "Cancel", variant: "secondary", url: "#" %>
      <%= tabler_ui.button text: "Save", variant: "primary", url: "#" %>
    </div>
  <% end %>
<% end %>
```

### Custom CSS Classes

All components accept a `class` parameter for additional styling:

```erb
<%= tabler_ui.button text: "Custom", class: "mt-3 mb-2", url: "#" %>
<%= tabler_ui.card class: "shadow-sm", title: "Title" do |card, slots| %>
  ...
<% end %>
```

### Accessing OpenStruct Attributes

Components use OpenStruct for flexible attribute access:

```erb
<%= tabler_ui.button do |btn| %>
  <% btn.text = "Click me" %>
  <% btn.variant = "primary" %>
  <% btn.url = some_path %>
<% end %>
```

## Component Reference

### Color Variants

Most components support these color variants:
- `primary` (default) - Blue
- `secondary` - Gray
- `success` - Green
- `warning` - Yellow
- `danger` - Red
- `info` - Cyan
- `light` - Light gray
- `dark` - Dark gray

### Size Options

Components that support sizing use these values:
- `sm` - Small
- (default) - Normal/Medium
- `lg` - Large
- `xl` - Extra Large (avatar only)

## Browser Support

Tabler UI supports all modern browsers:
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Development

After checking out the repo, run `bundle install` to install dependencies.

### Running Tests

```bash
bundle exec rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## License

This gem is available as open source under the terms of the MIT License.

## Credits

Built with [Tabler UI](https://tabler.io/) - A beautiful dashboard UI kit based on Bootstrap 5.
