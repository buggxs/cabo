# Todo-Liste für die Cabo App

## 1. Deep Linking für iOS implementieren

Für die passwortlose Anmeldung muss auch für iOS das Deep Linking (Universal Links) eingerichtet werden, damit die App nach dem Klick auf den Verifizierungslink geöffnet wird.

**Nützliche Informationen:**

*   **Domain:** `www.buggxs.com`
*   **App Bundle ID:** `com.buggxs.cabo`
*   **Pfad für die Konfigurationsdatei:** `https://www.buggxs.com/.well-known/apple-app-site-association`

**Vorgehen:**

1.  **`apple-app-site-association`-Datei erstellen und hochladen:**
    *   Erstelle eine Datei namens `apple-app-site-association` (ohne Endung).
    *   Lade sie auf deinen Server, sodass sie unter dem oben genannten Pfad erreichbar ist.
    *   **Wichtig:** Der Server muss die Datei mit dem `Content-Type: application/json` ausliefern.
    *   **Inhalt der Datei:**
        ```json
        {
          "applinks": {
            "details": [
              {
                "appID": "DEIN_TEAM_ID.com.buggxs.cabo",
                "paths": ["/cabo-verify-email"]
              }
            ]
          }
        }
        ```
    *   Ersetze `DEIN_TEAM_ID` durch deine Apple Developer Team ID. Du findest sie in deinem [Apple Developer Account](https://developer.apple.com/account) unter "Membership".

2.  **Xcode-Projekt konfigurieren:**
    *   Öffne `ios/Runner.xcworkspace` in Xcode.
    *   Gehe zu **Signing & Capabilities -> Associated Domains**.
    *   Füge den Eintrag `applinks:www.buggxs.com` hinzu.
