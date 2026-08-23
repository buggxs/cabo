# Repository of the Cabo Board App

![vorstellungs graphic](https://github.com/buggxs/cabo/assets/32867155/e3d46293-556b-4a5c-9e0e-d6df8fa8cabb)

![](https://img.shields.io/github/tag/pandao/editor.md.svg) ![](https://img.shields.io/github/release/pandao/editor.md.svg) ![](https://img.shields.io/github/issues/pandao/editor.md.svg)

The app can be used as an addition to the [cabo card game](https://www.amazon.de/Smiling-Monster-Games-CABO-Kartenspiel/dp/B07351NZ6S).  
It is currently available at the Google Play store in testing phase. To publish this app in production it needs 20 people who register as testers in the Play store. If you want to be one of the 20 awesome people, please feel free to contact me.  
You are also welcome to participate in the further development of the app.

## Installation

1. **Java 21 installieren**  
   Stelle sicher, dass auf deinem Rechner Java 21 installiert ist.

2. **Repository clonen**
   ```sh
   git clone https://github.com/buggxs/cabo.git
   cd cabo
   ```

3. **FVM nutzen (empfohlen)**  
   Installiere [FVM](https://fvm.app/) (Flutter Version Management), falls noch nicht geschehen:
   ```sh
   dart pub global activate fvm
   ```

4. **Flutter-Version im Projekt setzen**
   ```sh
   fvm use
   ```

5. **Abhängigkeiten installieren**
   ```sh
   fvm flutter pub get
   ```

6. **App starten**
   ```sh
   fvm flutter run
   ```

**Hinweis:**  
Momentan ist die App nur für **Android** im Play Store supported.

## Firebase Setup & SHA-1 Fingerprint

Damit Firebase (z.B. Google Sign-In, Crashlytics) lokales Debugging zulässt, musst du deinen lokalen Debug SHA-1 Fingerprint in deinem Firebase-Projekt hinterlegen.

Den Fingerprint kannst du dir mit folgendem command im Terminal anzeigen lassen:
```sh
cd android
./gradlew signingReport
```
Suche in der Ausgabe nach `Variant: debug` und kopiere den `SHA1` Schlüssel, um ihn in der Google Cloud Console unter deinen Android-App-Einstellungen als Fingerabdruck hinzuzufügen.

## Announcements pflegen

Announcements sind Hinweise, die beim App-Start als Dialog erscheinen (z.B. neue Features). Sie werden **nicht** über ein App-Update ausgeliefert, sondern über ein einzelnes Firestore-Dokument gepflegt:

> Collection `announcements` → Dokument `current`

Die App liest dieses Dokument öffentlich (ohne Login). Schreiben ist ausschliesslich über die Firebase Console bzw. das Admin-SDK möglich (siehe `firestore.rules` im Backend-Repository).

### Vollständiges Beispiel

```json
{
  "id": "settings-2026-08",
  "title": {
    "de": "Neue Designs",
    "en": "New designs"
  },
  "message": {
    "de": "Wähle jetzt dein Lieblings-Design in den Einstellungen.",
    "en": "Pick your favourite design in the settings now."
  },
  "imageUrl": "https://firebasestorage.googleapis.com/.../announcements%2Fdesigns.png?alt=media",
  "actions": [
    {
      "type": "navigate",
      "label": { "de": "Zu den Einstellungen", "en": "To settings" },
      "route": "settings_screen"
    },
    {
      "type": "dismiss",
      "label": { "de": "Später", "en": "Later" }
    }
  ]
}
```

### Felder

| Feld | Pflicht | Beschreibung |
| --- | --- | --- |
| `id` | ja | Frei wählbarer String. Die App merkt sich die zuletzt gesehene `id` lokal. **Eine neue `id` bedeutet: der Dialog wird erneut angezeigt.** Wird die `id` beibehalten, sehen bestehende Nutzer den Dialog nicht noch einmal — auch wenn sich Titel oder Text geändert haben. |
| `title.de` / `title.en` | ja | Überschrift je Sprache. Frei wählbarer Text. |
| `message.de` / `message.en` | ja | Fliesstext je Sprache. Frei wählbarer Text. |
| `imageUrl` | nein | Bild-URL für den Dialog-Header. `null` oder weggelassen → es wird stattdessen ein Standard-Icon angezeigt. Bilder liegen im Firebase Storage unter `announcements/` (öffentlich lesbar, siehe `storage.rules` im Backend-Repository). Lädt das Bild nicht, fällt der Dialog stillschweigend auf das Icon zurück. |
| `actions` | nein | Array mit Buttons. `null`, weggelassen oder `[]` → es wird der Standard-Button „Okay" angezeigt. |

### Aktionen (`actions`)

Die **erste** Aktion wird als primärer Button gerendert, die **zweite** als Textbutton darunter. **Ab der dritten Aktion wird ignoriert** — es werden also nie mehr als 2 Buttons angezeigt.

| Feld | Pflicht | Beschreibung |
| --- | --- | --- |
| `type` | ja | `"navigate"` oder `"dismiss"`. |
| `label.de` / `label.en` | ja | Buttonbeschriftung je Sprache. Frei wählbarer Text. |
| `route` | nur bei `navigate` | Zielroute innerhalb der App, siehe Tabelle unten. |

| `type` | Verhalten |
| --- | --- |
| `navigate` | Schliesst den Dialog und navigiert zur angegebenen `route`. |
| `dismiss` | Schliesst nur den Dialog (entspricht dem Standard-Button). `route` wird ignoriert. |

Erlaubte Werte für `route` (Whitelist in `AppNavigator.announcementRoutes`):

| Route | Ziel |
| --- | --- |
| `main_menu_screen` | Hauptmenü |
| `game_history_screen` | Spielverlauf |
| `about_screen` | Über die App |
| `rule_set_screen` | Regelwerk |
| `settings_screen` | Einstellungen |

Screens, die Argumente benötigen (`statistics_screen`, `end_game_screen`), sind bewusst **nicht** ansteuerbar, da sich Route-Argumente nicht über das Dokument übergeben lassen.

### Fehlertoleranz

Das Dokument wird remote gepflegt, deshalb verhält sich die App bei fehlerhaften Werten defensiv statt abzustürzen:

- Unbekannter oder fehlender `type` (z.B. `"open_url"`) → wird wie `dismiss` behandelt.
- `route` unbekannt oder nicht in der Whitelist → der Dialog schliesst trotzdem, es wird **nicht** navigiert, der Fehler wird geloggt.
- Firestore nicht erreichbar oder Dokument fehlt → es wird kein Dialog angezeigt.

### Anzeigelogik

- Der Dialog erscheint **nicht beim allerersten App-Start** — neue Nutzer sollen zuerst die App sehen.
- Danach wird er einmal pro `id` gezeigt und anschliessend lokal als gesehen markiert.
- Zum Testen lässt sich der Dialog im Debug-Build über den Debug-Bereich im „Über die App"-Screen jederzeit erzwingen, ohne den Gesehen-Status zu verändern.

<p float="left">
  <img src="https://github.com/user-attachments/assets/6d750656-e5ba-427e-8def-59c817348847" width="200" />
  <img src="https://github.com/user-attachments/assets/f09791ba-ec12-4d24-8b64-4203f0551506" width="200" />
  <img src="https://github.com/user-attachments/assets/e1526ef2-76e7-41f4-9b6c-46413eb0fd43" width="200" />
  <img src="https://github.com/user-attachments/assets/c560a852-dfbd-434f-8a7f-5bf1cc52186f" width="200" />
</p>

