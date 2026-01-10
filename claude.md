# Tabler UI - Entwicklerdokumentation

Diese Datei enthält detaillierte Dokumentation für Entwickler, die mit dem Tabler UI Gem arbeiten.

## FormBuilder

Das Tabler UI Gem enthält einen vollständigen FormBuilder, der automatisch Tabler UI Styling auf Formulare anwendet.

### Verwendung

#### Mit dem `tabler_form_with` Helper (empfohlen)

Der einfachste Weg, den FormBuilder zu verwenden:

```erb
<%= tabler_form_with model: @user do |f| %>
  <%= f.input :name %>
  <%= f.input :email %>
  <%= f.submit "Speichern", class: "btn btn-primary" %>
<% end %>
```

#### Mit `form_with` und explizitem Builder

Alternativ können Sie den Builder auch explizit angeben:

```erb
<%= form_with model: @user, builder: TablerUi::FormBuilder do |f| %>
  <%= f.input :name %>
  <%= f.input :email %>
<% end %>
```

### Input-Typen

Der FormBuilder erkennt automatisch den Typ des Feldes basierend auf der Datenbank-Definition:

#### String-Inputs

```erb
<%= f.input :name %>
<%= f.input :email %>  <!-- Automatisch als email_field -->
<%= f.input :phone %>  <!-- Automatisch als telephone_field -->
<%= f.input :website %> <!-- Automatisch als url_field -->
<%= f.input :password %> <!-- Automatisch als password_field -->
```

#### Text-Inputs (mehrzeilig)

```erb
<%= f.input :description, as: :text %>
<%= f.input :bio, as: :text %>
```

#### Date-Inputs mit Datepicker

Date-Felder werden automatisch mit einem Datepicker versehen:

```erb
<%= f.input :birth_date %>
<%= f.input :start_date %>
```

**Datepicker Konfiguration:**

Sie können den Datepicker über data-Attribute konfigurieren:

```erb
<%= f.input :birth_date, input_html: {
  data: {
    min: "1900-01-01",
    max: Date.today.to_s,
    format: "dd.mm.yyyy"
  }
} %>
```

Verfügbare Optionen:
- `data-min`: Minimales Datum
- `data-max`: Maximales Datum
- `data-format`: Datumsformat (Standard: `yyyy-mm-dd`)

#### Integer/Number-Inputs

```erb
<%= f.input :age %>
<%= f.input :quantity %>
```

#### Boolean-Inputs (Checkboxen)

```erb
<%= f.input :active, as: :boolean %>
<%= f.input :terms_accepted, as: :boolean, label: "Ich akzeptiere die AGB" %>
```

#### Select-Inputs

```erb
<%= f.input :role,
  collection: Role.all,
  value_method: :id,
  text_method: :name %>

<%= f.input :category_id,
  collection: Category.all,
  value_method: :id,
  text_method: :name,
  label: "Kategorie auswählen" %>
```

#### Grouped Select

```erb
<%= f.input :country_id,
  as: :grouped_select,
  collection: countries_grouped_by_continent %>
```

#### Radio Buttons

Standard Radio Buttons:

```erb
<%= f.input :status,
  as: :radio_buttons,
  collection: ["aktiv", "inaktiv", "archiviert"],
  value_method: :to_s,
  text_method: :humanize %>
```

**Selectgroup Styling:**

Radio Buttons können mit verschiedenen Selectgroup-Styles dargestellt werden:

```erb
<!-- Als Buttons (Standard) -->
<%= f.input :status,
  as: :radio_buttons,
  collection: ["aktiv", "inaktiv", "archiviert"],
  selectgroup: true %>

<!-- Als Pills (abgerundete Buttons) -->
<%= f.input :role,
  as: :radio_buttons,
  collection: Role.all,
  value_method: :id,
  text_method: :name,
  selectgroup_pills: true %>

<!-- Als Boxes (größere Button-Boxen) -->
<%= f.input :plan,
  as: :radio_buttons,
  collection: ["Free", "Pro", "Enterprise"],
  selectgroup_buttons: true %>
```

#### Check Boxes (Multiple Selection)

```erb
<%= f.input :tag_ids,
  as: :check_boxes,
  collection: Tag.all,
  value_method: :id,
  text_method: :name %>
```

#### File-Inputs

```erb
<%= f.input :avatar, as: :file %>
<%= f.input :document, as: :file %>
```

#### Toggle Switch (anstatt Checkbox)

Moderne Toggle Switches für bessere UX:

```erb
<%= f.input :notifications_enabled, as: :toggle %>
<%= f.input :dark_mode, as: :toggle, label: "Dark Mode aktivieren" %>
<%= f.input :newsletter, as: :toggle %>
```

#### Color Input

Farb-Auswahl mit visuellen Farbfeldern:

```erb
<!-- Standard Farben -->
<%= f.input :theme_color, as: :color %>

<!-- Custom Farben -->
<%= f.input :brand_color, as: :color,
  colors: %w[#206bc4 #4299e1 #0ca678 #f59f00 #d63939 #ae3ec9 #6366f1] %>
```

#### Image Check (Bild-basierte Auswahl)

Auswahl mit Bildern statt Text:

```erb
<!-- Single Selection (Radio) -->
<%= f.input :avatar_id,
  as: :imagecheck,
  collection: Avatar.all,
  image_method: :image_url,
  value_method: :id,
  text_method: :name,
  show_text: true %>

<!-- Multiple Selection (Checkboxes) -->
<%= f.input :product_image_ids,
  as: :imagecheck,
  collection: ProductImage.all,
  image_method: :thumbnail_url,
  value_method: :id,
  multiple: true,
  show_text: true %>
```

#### Input Groups (mit Prepend/Append)

Inputs mit Zusatz-Text oder Buttons:

```erb
<!-- Mit Text -->
<%= f.input :website, as: :input_group, prepend: "https://" %>
<%= f.input :price, as: :input_group, append: "€" %>
<%= f.input :username, as: :input_group, prepend: "@" %>

<!-- Mit Button -->
<%= f.input :search, as: :input_group,
  append_button: link_to("Suchen", "#", class: "btn btn-primary") %>
```

#### Floating Labels

Platz-sparende Labels, die beim Focus nach oben schweben:

```erb
<%= f.input :email, as: :floating %>
<%= f.input :password, as: :floating %>
<%= f.input :message, as: :floating, type: :textarea %>
```

### Input-Optionen

Alle Input-Typen unterstützen folgende Optionen:

#### Label

```erb
<!-- Standard Label (automatisch aus Attribut-Namen) -->
<%= f.input :name %>

<!-- Custom Label -->
<%= f.input :name, label: "Vollständiger Name" %>

<!-- Kein Label -->
<%= f.input :name, label: false %>

<!-- Mit Required-Markierung -->
<%= f.input :email, required: true %>

<!-- Mit Label-Description (z.B. Zeichenzähler) -->
<%= f.input :bio,
  label: "Biografie",
  label_description: "#{@user.bio&.length || 0}/500",
  as: :text %>
```

#### Hint Text

```erb
<%= f.input :email, hint: "Wir werden Ihre E-Mail niemals weitergeben" %>
<%= f.input :password, hint: "Mindestens 8 Zeichen" %>
```

#### Input HTML Optionen

```erb
<%= f.input :name, input_html: {
  placeholder: "Max Mustermann",
  class: "custom-class",
  data: { action: "input->controller#update" }
} %>
```

#### Expliziter Input-Typ

```erb
<!-- Überschreibt automatische Typ-Erkennung -->
<%= f.input :code, as: :text %>
<%= f.input :status, as: :select, collection: Status.all %>
```

### Fehlerbehandlung

Der FormBuilder zeigt automatisch Validierungsfehler an:

```erb
<%= tabler_form_with model: @user do |f| %>
  <%= f.input :email %>
  <!-- Zeigt "ist bereits vergeben" wenn Validierung fehlschlägt -->

  <%= f.input :password %>
  <!-- Zeigt "ist zu kurz" wenn Validierung fehlschlägt -->
<% end %>
```

Fehler werden in der Klasse `invalid-feedback` angezeigt und das Input-Feld erhält automatisch die Klasse `is-invalid`.

### Vollständiges Beispiel

```erb
<%= tabler_form_with model: @user, url: users_path do |f| %>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">Benutzer bearbeiten</h3>
    </div>

    <div class="card-body">
      <%= f.input :name,
        label: "Vollständiger Name",
        hint: "Vor- und Nachname" %>

      <%= f.input :email,
        hint: "Wird für Login verwendet" %>

      <%= f.input :birth_date,
        input_html: { data: { max: Date.today.to_s } } %>

      <%= f.input :bio,
        as: :text,
        input_html: { rows: 5 } %>

      <%= f.input :role,
        collection: Role.all,
        value_method: :id,
        text_method: :name %>

      <%= f.input :active,
        as: :boolean,
        label: "Aktiver Benutzer" %>

      <%= f.input :avatar, as: :file %>
    </div>

    <div class="card-footer">
      <%= f.submit "Speichern", class: "btn btn-primary" %>
      <%= link_to "Abbrechen", users_path, class: "btn btn-link" %>
    </div>
  </div>
<% end %>
```

## Stimulus Controller

### Datepicker Controller

Der Datepicker Controller wird automatisch auf alle Date-Inputs angewendet, wenn Sie den FormBuilder verwenden.

#### Manuelle Verwendung

Falls Sie den Datepicker manuell auf ein Feld anwenden möchten:

```erb
<input type="text"
  data-controller="tabler-ui--datepicker"
  data-format="dd.mm.yyyy"
  data-min="2024-01-01"
  data-max="2024-12-31">
```

#### Date Range Picker

Für einen Date Range Picker verwenden Sie ein Container-Element:

```erb
<div data-controller="tabler-ui--datepicker">
  <input type="text" name="start_date">
  <input type="text" name="end_date">
</div>
```

#### Konfiguration

Der Datepicker basiert auf [vanillajs-datepicker](https://mymth.github.io/vanillajs-datepicker/) und unterstützt folgende Optionen:

- **format**: Datumsformat (Standard: `yyyy-mm-dd`)
  - Beispiele: `dd.mm.yyyy`, `mm/dd/yyyy`, `yyyy-mm-dd`
- **minDate**: Minimales auswählbares Datum
- **maxDate**: Maximales auswählbares Datum
- **weekStart**: Wochenbeginn (Standard: 1 = Montag)
- **weekNumbers**: Wochennummern anzeigen (Standard: 1 = ja)
- **autohide**: Automatisch ausblenden nach Auswahl (Standard: true)

Alle Optionen werden über data-Attribute konfiguriert:

```erb
<%= f.input :event_date, input_html: {
  data: {
    format: "dd.mm.yyyy",
    min: Date.today.to_s,
    max: 1.year.from_now.to_date.to_s
  }
} %>
```

## Styling-Anpassungen

### CSS-Klassen

Der FormBuilder verwendet folgende Tabler UI CSS-Klassen:

- **Form Group**: `mb-3` (Margin Bottom)
- **Label**: Standard `<label>` Tag
- **Input**: `form-control`
- **Select**: `form-select`
- **Checkbox/Radio**: `form-check`, `form-check-input`, `form-check-label`
- **Hint**: `form-hint`
- **Error**: `invalid-feedback`
- **Invalid Input**: `is-invalid`

### Custom Styling

Sie können zusätzliche CSS-Klassen über die `input_html` Option hinzufügen:

```erb
<%= f.input :name, input_html: { class: "input-lg" } %>
```

Oder direkt auf das Form-Element:

```erb
<%= tabler_form_with model: @user, html: { class: "custom-form" } do |f| %>
  ...
<% end %>
```

## Installation & Setup

### Importmap

Das Gem fügt automatisch die benötigten JavaScript-Abhängigkeiten zu Ihrer Importmap hinzu:

- `@hotwired/stimulus`
- `vanillajs-datepicker` (von CDN)
- Alle Tabler UI Stimulus Controller

### Stimulus Controller registrieren

Die Controller werden automatisch unter dem Namespace `tabler-ui--` registriert:

```javascript
// Automatisch verfügbar:
// - tabler-ui--datepicker
// - tabler-ui--dropdown
// etc.
```

### CSS

Das Datepicker CSS wird automatisch geladen, wenn Sie `tabler_ui` in Ihrem Stylesheet einbinden:

```css
/*
 *= require tabler_ui
 */
```

Dies lädt automatisch:
- Tabler UI Framework CSS
- Datepicker CSS (von CDN)

## Erweiterte Form Helper (Tabler UI Spezial)

Der FormBuilder unterstützt alle speziellen Tabler UI Form Helper:

### 1. Form Selectgroup

Gruppierte Radio/Checkbox Buttons mit drei verschiedenen Styles:

```erb
<!-- Standard Selectgroup -->
<%= f.input :payment_method,
  as: :radio_buttons,
  collection: ["Kreditkarte", "PayPal", "Überweisung"],
  selectgroup: true %>

<!-- Pills (abgerundete Buttons) -->
<%= f.input :subscription,
  as: :radio_buttons,
  collection: ["Monatlich", "Jährlich"],
  selectgroup_pills: true,
  label: "Abrechnungszeitraum" %>

<!-- Boxes (größere Button-Boxen) -->
<%= f.input :plan,
  as: :radio_buttons,
  collection: ["Basic", "Pro", "Enterprise"],
  selectgroup_buttons: true,
  label: "Tarif wählen" %>
```

Auch für Checkboxen verfügbar:

```erb
<%= f.input :features,
  as: :check_boxes,
  collection: ["SSL", "Backup", "CDN"],
  selectgroup_pills: true %>
```

### 2. Form Image Check

Visuelle Auswahl mit Bildern:

```erb
<%= f.input :avatar_id,
  as: :imagecheck,
  collection: @avatars,
  image_method: :url,
  value_method: :id,
  text_method: :name,
  show_text: true,
  label: "Avatar auswählen" %>
```

Für Multiple Selection:

```erb
<%= f.input :gallery_image_ids,
  as: :imagecheck,
  collection: @images,
  image_method: :thumbnail,
  multiple: true,
  show_text: true %>
```

### 3. Form Color Input

Farb-Auswahl mit Farbfeldern:

```erb
<!-- Standard Farben -->
<%= f.input :theme_color, as: :color %>

<!-- Custom Farben -->
<%= f.input :accent_color,
  as: :color,
  colors: %w[#ff0000 #00ff00 #0000ff #ffff00 #ff00ff #00ffff],
  label: "Akzentfarbe" %>

<!-- Objekt-Collection -->
<%= f.input :brand_color,
  as: :color,
  colors: BrandColor.all,
  value_method: :hex_code %>
```

### 4. Toggle Switches

Moderne Switches statt Checkboxen:

```erb
<%= f.input :email_notifications, as: :toggle %>
<%= f.input :dark_mode, as: :toggle, label: "Dark Mode" %>
<%= f.input :two_factor_auth, as: :toggle, label: "2FA aktivieren" %>
```

### 5. Input Groups

Inputs mit Prepend/Append-Elementen:

```erb
<!-- Text prepend/append -->
<%= f.input :website, as: :input_group, prepend: "https://" %>
<%= f.input :price, as: :input_group, append: "€", label: "Preis" %>
<%= f.input :discount, as: :input_group, append: "%", label: "Rabatt" %>

<!-- Icon prepend -->
<%= f.input :email,
  as: :input_group,
  prepend: content_tag(:span, "📧", class: "input-group-text") %>

<!-- Button append -->
<%= f.input :coupon_code,
  as: :input_group,
  append_button: link_to("Anwenden", "#", class: "btn btn-primary"),
  label: "Gutscheincode" %>
```

### 6. Floating Labels

Platz-sparende, moderne Labels:

```erb
<%= f.input :email, as: :floating %>
<%= f.input :password, as: :floating %>
<%= f.input :phone, as: :floating, label: "Telefonnummer" %>

<!-- Für Textarea -->
<%= f.input :notes, as: :floating, type: :textarea %>
```

### 7. Label Descriptions

Labels mit zusätzlichen Informationen:

```erb
<!-- Zeichenzähler -->
<%= f.input :bio,
  as: :text,
  label: "Biografie",
  label_description: "#{@user.bio&.length || 0}/500" %>

<!-- Weitere Infos -->
<%= f.input :slug,
  label: "URL-Slug",
  label_description: "nur-kleinbuchstaben-und-bindestriche" %>

<!-- Required-Markierung -->
<%= f.input :email, required: true %>
```

## Best Practices

### 1. Verwenden Sie `tabler_form_with`

```erb
<!-- Gut -->
<%= tabler_form_with model: @user do |f| %>

<!-- Weniger gut -->
<%= form_with model: @user, builder: TablerUi::FormBuilder do |f| %>
```

### 2. Nutzen Sie die automatische Typ-Erkennung

```erb
<!-- Gut - Automatische Typ-Erkennung -->
<%= f.input :email %>
<%= f.input :birth_date %>

<!-- Weniger gut - Explizite Typ-Angabe -->
<%= f.input :email, as: :string, input_html: { type: :email } %>
```

### 3. Gruppieren Sie verwandte Felder in Cards

```erb
<%= tabler_form_with model: @user do |f| %>
  <div class="card mb-3">
    <div class="card-header">
      <h3 class="card-title">Persönliche Daten</h3>
    </div>
    <div class="card-body">
      <%= f.input :name %>
      <%= f.input :email %>
    </div>
  </div>

  <div class="card">
    <div class="card-header">
      <h3 class="card-title">Einstellungen</h3>
    </div>
    <div class="card-body">
      <%= f.input :role %>
      <%= f.input :active %>
    </div>
  </div>
<% end %>
```

### 4. Verwenden Sie Hints für Benutzerführung

```erb
<%= f.input :password,
  hint: "Mindestens 8 Zeichen, muss Zahlen und Buchstaben enthalten" %>

<%= f.input :email,
  hint: "Diese E-Mail wird für Benachrichtigungen verwendet" %>
```

### 5. Konfigurieren Sie Date-Picker sinnvoll

```erb
<!-- Geburtsdatum - nicht in der Zukunft -->
<%= f.input :birth_date,
  input_html: { data: { max: Date.today.to_s } } %>

<!-- Event-Datum - nicht in der Vergangenheit -->
<%= f.input :event_date,
  input_html: { data: { min: Date.today.to_s } } %>
```

## Troubleshooting

### Datepicker funktioniert nicht

1. Stellen Sie sicher, dass `tabler_ui` in Ihrer `application.css` eingebunden ist
2. Prüfen Sie, ob Stimulus korrekt initialisiert ist
3. Überprüfen Sie die Browser-Console auf JavaScript-Fehler

### Styling stimmt nicht

1. Stellen Sie sicher, dass `tabler_ui` im Stylesheet eingebunden ist
2. Überprüfen Sie, ob Tabler CSS korrekt geladen wird
3. Prüfen Sie auf CSS-Konflikte mit anderen Frameworks

### Validierungsfehler werden nicht angezeigt

1. Stellen Sie sicher, dass das Model die Fehler im `errors`-Hash hat
2. Prüfen Sie, ob der Attributname korrekt ist
3. Verwenden Sie `@user.errors.full_messages` zum Debuggen

## Alert Komponente

Die Alert-Komponente zeigt kontextuelle Feedback-Nachrichten an.

### Basis Verwendung

```erb
<!-- Success Alert -->
<%= tabler_ui.alert variant: "success", message: "Ihre Änderungen wurden gespeichert!" %>

<!-- Info Alert -->
<%= tabler_ui.alert variant: "info", message: "Neue Updates verfügbar." %>

<!-- Warning Alert -->
<%= tabler_ui.alert variant: "warning", message: "Ihr Test-Zugang läuft in 3 Tagen ab." %>

<!-- Danger Alert -->
<%= tabler_ui.alert variant: "danger", message: "Ein Fehler ist aufgetreten." %>
```

### Alert Varianten

Verfügbare Varianten:
- `success` - Erfolgs-Meldungen (grün, mit Checkmark-Icon)
- `info` - Informationen (blau, mit Info-Icon)
- `warning` - Warnungen (gelb, mit Warnung-Icon)
- `danger` - Fehler (rot, mit Fehler-Icon)

Sie können auch andere Tabler-Farben verwenden: `primary`, `secondary`, `lime`, `cyan`, etc.

### Mit Titel

```erb
<%= tabler_ui.alert
  variant: "success",
  title: "Erfolgreich gespeichert",
  message: "Ihre Profil-Änderungen wurden erfolgreich gespeichert." %>
```

### Dismissible (schließbar)

```erb
<%= tabler_ui.alert
  variant: "info",
  message: "Dies ist eine schließbare Nachricht.",
  dismissible: true %>
```

### Important Style

Wichtige Alerts mit farbigem Hintergrund:

```erb
<%= tabler_ui.alert
  variant: "warning",
  title: "Wichtig",
  message: "Bitte aktualisieren Sie Ihr Passwort.",
  important: true %>
```

### Mit Link

```erb
<%= tabler_ui.alert
  variant: "info",
  message: "Neue Features verfügbar.",
  link: "/changelog",
  link_text: "Mehr erfahren" %>
```

### Ohne Icon

```erb
<%= tabler_ui.alert
  variant: "success",
  message: "Gespeichert",
  icon: false %>
```

### Custom Icon

```erb
<%= tabler_ui.alert
  variant: "info",
  message: "Download bereit",
  icon: "download" %>
```

### Mit Block-Content

Für komplexeren HTML-Content:

```erb
<%= tabler_ui.alert variant: "success" do %>
  <strong>Gratulation!</strong> Ihr Account wurde erstellt.
  <%= link_to "Jetzt einloggen", login_path, class: "alert-link" %>
<% end %>
```

### Mit Slots

```erb
<%= tabler_ui.alert variant: "danger" do |alert, slots| %>
  <% slots.body do %>
    <h4 class="alert-title">Fehler beim Hochladen</h4>
    <p>Die folgenden Dateien konnten nicht hochgeladen werden:</p>
    <ul>
      <li>dokument.pdf - Zu groß</li>
      <li>bild.jpg - Ungültiges Format</li>
    </ul>
  <% end %>
<% end %>
```

### Alle Optionen

```erb
<%= tabler_ui.alert
  variant: "info",              # Alert-Typ (success, info, warning, danger)
  title: "Titel",               # Optional: Alert-Titel
  message: "Nachricht",         # Alert-Nachricht
  icon: "info-circle",          # Optional: Custom Icon (oder false für kein Icon)
  dismissible: true,            # Schließbar (default: false)
  important: true,              # Important Style mit Hintergrund (default: false)
  link: "/more",                # Optional: Link-URL
  link_text: "Mehr Info",       # Link-Text (default: "Learn more")
  custom_class: "my-custom"     # Zusätzliche CSS-Klassen
%>
```

### Beispiele aus der Praxis

#### Erfolgs-Meldung nach Formular-Submit

```erb
<% if flash[:notice] %>
  <%= tabler_ui.alert
    variant: "success",
    message: flash[:notice],
    dismissible: true %>
<% end %>
```

#### Fehler-Anzeige

```erb
<% if @user.errors.any? %>
  <%= tabler_ui.alert variant: "danger", dismissible: true do %>
    <h4 class="alert-title">
      <%= pluralize(@user.errors.count, "Fehler") %> verhindert das Speichern:
    </h4>
    <ul class="mb-0">
      <% @user.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  <% end %>
<% end %>
```

#### Warnung mit Aktion

```erb
<%= tabler_ui.alert
  variant: "warning",
  title: "Zahlung überfällig",
  message: "Ihre letzte Zahlung ist überfällig. Bitte aktualisieren Sie Ihre Zahlungsmethode.",
  link: billing_path,
  link_text: "Zur Abrechnung",
  important: true %>
```

#### Info mit Custom Content

```erb
<%= tabler_ui.alert variant: "info", icon: "gift" do %>
  <strong>Sonderangebot!</strong>
  Nutzen Sie den Code <code>SAVE20</code> für 20% Rabatt.
  <%= link_to "Jetzt einlösen", checkout_path(coupon: "SAVE20"), class: "alert-link" %>
<% end %>
```

## Dark Mode Toggle

Die Dark Mode Toggle Komponente ermöglicht das Umschalten zwischen Light, Dark und System-Theme.

### In der Navbar

Der Toggle kann an beliebiger Stelle in der Navbar eingefügt werden:

```erb
<%= tabler_ui.navbar do |navbar| %>
  <% navbar.brand = link_to("MyApp", root_path) %>
  <% navbar.left do |nav| %>
    <% nav.add "Home", url: root_path %>
    <% nav.add "About", url: about_path %>
  <% end %>
  <% navbar.right do |nav| %>
    <% nav.dark_mode_toggle %>
    <% nav.divider %>
    <% nav.add "Login", url: login_path %>
  <% end %>
<% end %>
```

Verfügbare Navbar-Items:
- `nav.add "Title", url: path` - Normaler Link
- `nav.dropdown "Title" do |dd| ... end` - Dropdown-Menü
- `nav.dark_mode_toggle` - Dark Mode Umschalter
- `nav.divider` - Vertikaler Trenner

### Standalone Komponente

Sie können den Toggle auch eigenständig verwenden:

```erb
<%= tabler_ui.dark_mode_toggle %>

<!-- Mit Größe -->
<%= tabler_ui.dark_mode_toggle size: :sm %>
<%= tabler_ui.dark_mode_toggle size: :lg %>

<!-- Mit Custom CSS-Klasse -->
<%= tabler_ui.dark_mode_toggle class: "my-custom-class" %>
```

### Funktionsweise

Der Toggle wechselt durch drei Modi:
1. **Light** (Sonne-Icon) - Helles Theme
2. **Dark** (Mond-Icon) - Dunkles Theme
3. **System** (Monitor-Icon) - Folgt der Systemeinstellung

Die Einstellung wird im `localStorage` gespeichert und bleibt beim Neuladen erhalten.

### Stimulus Controller

Der Dark Mode Controller kann auch manuell verwendet werden:

```html
<div data-controller="tabler-ui--dark-mode">
  <button data-action="click->tabler-ui--dark-mode#toggle">
    <span data-tabler-ui--dark-mode-target="light">☀️</span>
    <span data-tabler-ui--dark-mode-target="dark" class="d-none">🌙</span>
    <span data-tabler-ui--dark-mode-target="system" class="d-none">💻</span>
  </button>
</div>
```

Der Controller:
- Setzt `data-bs-theme="dark"` oder `data-bs-theme="light"` auf `<body>`
- Speichert die Einstellung in `localStorage` unter dem Key `theme`
- Reagiert auf Änderungen der System-Präferenz bei "System"-Modus

## Illustration Komponente

Die Illustration-Komponente rendert SVG-Illustrationen von Tabler UI inline.

### Basis Verwendung

```erb
<!-- Standard (light Variante) -->
<%= tabler_ui.illustration name: "not-found" %>

<!-- Dark Variante -->
<%= tabler_ui.illustration name: "not-found", variant: "dark" %>
```

### Mit Größenangabe

Verfügbare Größen: `xs` (100px), `sm` (150px), `md` (200px), `lg` (300px), `xl` (400px), `xxl` (600px)

```erb
<%= tabler_ui.illustration name: "error", size: :md %>

<!-- Oder mit expliziter Pixel-Größe -->
<%= tabler_ui.illustration name: "error", size: 250 %>
```

### Mit Custom CSS-Klasse

```erb
<%= tabler_ui.illustration name: "search", class: "my-custom-class" %>
```

### Alle Optionen

```erb
<%= tabler_ui.illustration
  name: "not-found",      # Name der Illustration (ohne .svg)
  variant: "light",       # "light" oder "dark" (default: "light")
  size: :lg,              # xs, sm, md, lg, xl, xxl oder Pixel-Wert
  class: "custom-class"   # Zusätzliche CSS-Klassen
%>
```

### Verfügbare Illustrationen

Alle Illustrationen sind in `light` und `dark` Varianten verfügbar:

**Fehler & Status:**
- `403`, `500`, `not-found`, `error`

**Personen:**
- `boy`, `boy-and-cat`, `boy-and-laptop`, `boy-girl`, `boy-gives-flowers`
- `boy-refresh`, `boy-with-key`, `girl-phone`, `girl-refresh`

**Aktivitäten:**
- `bicycle`, `dance`, `guitar`, `music`, `painting`, `podcast`
- `shopping`, `weightlifting`, `kite`, `ice-skates`, `electric-scooter`

**Business & Arbeit:**
- `building`, `calendar`, `chart`, `chart-circle`, `folders`, `project`
- `hybrid-work`, `computer-fix`, `mobile-computer`, `printer`

**Kommunikation:**
- `conversation`, `email`, `message`, `video`

**Feiertage:**
- `christmas-tree`, `christmas-gifts`, `christmas-fireplace`, `snowman`
- `easter-bunny`, `easter-egg`, `halloween-pumpkin`
- `valentines-day-gift`, `valentines-day-heart`, `valentines-day-love`
- `new-year`, `new-year-2`

**Sonstiges:**
- `ai`, `archive`, `cat`, `dart`, `discount`, `fingerprint`, `flowers`
- `ghost`, `gift`, `good-info`, `good-news`, `bad-news`, `neutral-info`
- `icons`, `loading`, `map-destination`, `morning`, `payment`, `search`
- `shield`, `telescope`, `tiredness`, `to-do`, `vr`, `wait`

### Beispiele aus der Praxis

#### 404 Fehlerseite

```erb
<div class="empty">
  <div class="empty-img">
    <%= tabler_ui.illustration name: "not-found", size: :lg %>
  </div>
  <h1 class="empty-title">Seite nicht gefunden</h1>
  <p class="empty-subtitle text-secondary">
    Die angeforderte Seite existiert nicht.
  </p>
  <%= link_to "Zur Startseite", root_path, class: "btn btn-primary" %>
</div>
```

#### Leerer Zustand

```erb
<div class="empty">
  <div class="empty-img">
    <%= tabler_ui.illustration name: "search", size: :md %>
  </div>
  <p class="empty-title">Keine Ergebnisse gefunden</p>
  <p class="empty-subtitle text-secondary">
    Versuchen Sie es mit anderen Suchbegriffen.
  </p>
</div>
```

#### Wartungsseite

```erb
<div class="empty">
  <div class="empty-img">
    <%= tabler_ui.illustration name: "computer-fix", size: :xl %>
  </div>
  <h1 class="empty-title">Wartungsarbeiten</h1>
  <p class="empty-subtitle text-secondary">
    Wir sind bald wieder für Sie da.
  </p>
</div>
```

## Placeholder Komponente

Die Placeholder-Komponente zeigt Skeleton-Loading-Zustände für Content an.

### Basis Verwendung

```erb
<!-- Text Placeholder -->
<%= tabler_ui.placeholder type: :text, width: 9 %>

<!-- Mehrere Textzeilen -->
<%= tabler_ui.placeholder type: :text, lines: [10, 11, 8] %>

<!-- Avatar Placeholder -->
<%= tabler_ui.placeholder type: :avatar %>

<!-- Bild Placeholder -->
<%= tabler_ui.placeholder type: :image, ratio: "21x9" %>
```

### Placeholder Typen

Verfügbare Typen:
- `text` - Textzeilen-Placeholder
- `avatar` - Avatar-Placeholder (rund oder eckig)
- `image` - Bild-Placeholder mit Aspect Ratio
- `button` - Button-Placeholder
- `card` - Vollständiges Card-Skeleton
- `list` - Listen-Element mit Avatar

### Mit Animation

```erb
<!-- Glow Animation -->
<%= tabler_ui.placeholder type: :card, animation: :glow %>

<!-- Wave Animation -->
<%= tabler_ui.placeholder type: :text, lines: [9, 10, 8], animation: :wave %>
```

### Text Placeholder

```erb
<!-- Einzelne Zeile -->
<%= tabler_ui.placeholder type: :text, width: 9 %>

<!-- Mehrere Zeilen mit verschiedenen Breiten -->
<%= tabler_ui.placeholder type: :text, lines: [10, 11, 8, 9] %>

<!-- Mit Größe (xs, sm, lg, xl) -->
<%= tabler_ui.placeholder type: :text, width: 7, size: "lg" %>
```

### Avatar Placeholder

```erb
<!-- Standard (rund) -->
<%= tabler_ui.placeholder type: :avatar %>

<!-- Eckig -->
<%= tabler_ui.placeholder type: :avatar, rounded: false %>

<!-- Mit Größe -->
<%= tabler_ui.placeholder type: :avatar, size: "lg" %>
```

### Image Placeholder

```erb
<!-- Standard (21x9) -->
<%= tabler_ui.placeholder type: :image %>

<!-- Mit spezifischem Ratio -->
<%= tabler_ui.placeholder type: :image, ratio: "16x9" %>
<%= tabler_ui.placeholder type: :image, ratio: "4x3" %>
<%= tabler_ui.placeholder type: :image, ratio: "1x1" %>
```

### Button Placeholder

```erb
<!-- Standard -->
<%= tabler_ui.placeholder type: :button, width: 4 %>

<!-- Mit Variante -->
<%= tabler_ui.placeholder type: :button, width: 4, variant: "primary" %>
<%= tabler_ui.placeholder type: :button, width: 6, variant: "secondary" %>
```

### Card Placeholder

```erb
<!-- Vollständiges Card-Skeleton -->
<%= tabler_ui.placeholder type: :card, animation: :glow %>

<!-- Ohne Bild -->
<%= tabler_ui.placeholder type: :card, show_image: false %>

<!-- Ohne Button -->
<%= tabler_ui.placeholder type: :card, show_button: false %>
```

### List Placeholder

```erb
<!-- Listen-Element mit Avatar -->
<%= tabler_ui.placeholder type: :list %>

<!-- Mit Animation -->
<%= tabler_ui.placeholder type: :list, animation: :glow %>
```

### Alle Optionen

```erb
<%= tabler_ui.placeholder
  type: :card,            # Placeholder-Typ (:text, :avatar, :image, :button, :card, :list)
  width: 9,               # Spaltenbreite für Text/Button (1-12)
  size: "lg",             # Größe (xs, sm, lg, xl)
  animation: :glow,       # Animation (:glow, :wave)
  ratio: "21x9",          # Aspect Ratio für Bilder (1x1, 4x3, 16x9, 21x9)
  variant: "primary",     # Button-Variante
  lines: [10, 11, 8],     # Array von Breiten für mehrere Textzeilen
  rounded: true,          # Avatar abgerundet (default: true)
  show_image: true,       # Bild in Card anzeigen (default: true)
  show_button: true,      # Button in Card anzeigen (default: true)
  custom_class: "my-cls"  # Zusätzliche CSS-Klassen
%>
```

### Beispiele aus der Praxis

#### Loading Card Grid

```erb
<div class="row row-cards">
  <% 4.times do %>
    <div class="col-3">
      <%= tabler_ui.placeholder type: :card, animation: :glow %>
    </div>
  <% end %>
</div>
```

#### Loading User Profile

```erb
<div class="card">
  <div class="card-body py-5 text-center">
    <div class="placeholder-glow">
      <%= tabler_ui.placeholder type: :avatar, size: "lg" %>
      <div class="mt-3 w-75 mx-auto">
        <%= tabler_ui.placeholder type: :text, width: 9 %>
        <%= tabler_ui.placeholder type: :text, lines: [10, 8], size: "xs" %>
      </div>
    </div>
  </div>
</div>
```

#### Loading List

```erb
<div class="card">
  <ul class="list-group list-group-flush placeholder-glow">
    <% 4.times do %>
      <li class="list-group-item">
        <%= tabler_ui.placeholder type: :list %>
      </li>
    <% end %>
  </ul>
</div>
```

#### Loading Text Content

```erb
<div class="card">
  <div class="card-body placeholder-glow">
    <%= tabler_ui.placeholder type: :text, width: 9 %>
    <%= tabler_ui.placeholder type: :text, lines: [10, 12, 11, 8, 10], size: "xs" %>
  </div>
</div>
```

## Weiterführende Ressourcen

- [Tabler UI Dokumentation](https://tabler.io/)
- [Star Rating JS Dokumentation](https://github.com/niksd1/star-rating.js)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [Rails Form Helpers Guide](https://guides.rubyonrails.org/form_helpers.html)
