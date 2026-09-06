# Todo-Liste für die Cabo App

## 1. iOS Universal Links aktivieren

Android App Links sind fertig und im Build verifiziert. Für iOS fehlt nur noch
die Apple Developer Team ID.

**Stand im Repository (erledigt):**

* `ios/Runner/Runner.entitlements` mit `applinks:www.buggxs.com`, verdrahtet
  über `CODE_SIGN_ENTITLEMENTS` in allen drei Build-Konfigurationen.
* `FlutterDeepLinkingEnabled = false` in `Info.plist` — sonst landet
  `/cabo/verified` in `AppNavigator.generateRoute` und fällt auf die
  Error-Route durch. `app_links` übernimmt das Routing.

**Was noch fehlt:**

1. **Team ID besorgen:** [Apple Developer Account](https://developer.apple.com/account)
   → Membership.
2. **`apple-app-site-association` ausliefern.** Im Website-Repository
   (`~/workspace/web/website`) liegt eine Vorlage unter
   `src/assets/.well-known/apple-app-site-association.template`. Die dortige
   `README.md` beschreibt die drei Schritte: Team ID einsetzen, Rewrite in
   `vercel.json` vor dem SPA-Catch-all, und einen `headers`-Eintrag für
   `Content-Type: application/json` — die Datei hat keine Endung, Vercel rät
   den Typ nicht, und Apple lehnt sie sonst stillschweigend ab.
3. **Apple Developer Portal:** Capability „Associated Domains" für die App-ID
   `com.buggxs.cabo` aktivieren und das Provisioning Profile neu generieren.

Apple cached die Datei aggressiv — nach dem Deploy einen Tag Puffer einplanen
und die App neu installieren.

## 2. Firebase Console

* Authentication → Sign-in method → **E-Mail/Passwort aktivieren**.
  „Email link (passwordless sign-in)" bewusst **aus** lassen: das ist der Pfad,
  der eine Firebase-Hosting-Custom-Domain als `linkDomain` verlangt.
* Authentication → Settings → Authorized domains → **`www.buggxs.com`**
  hinzufügen. Ohne das lehnt Firebase die continueUrl mit
  `auth/unauthorized-continue-uri` ab.
* Anonymous-Provider muss **aktiv bleiben** — jeder Nutzer wird beim Start
  anonym angemeldet.
* Templates → „E-Mail-Adresse bestätigen" → deutsche Übersetzung und
  Absendername prüfen.

## 3. Play Console prüfen

Der SHA-256-Fingerprint im live ausgelieferten `assetlinks.json` muss der
**Play-App-Signing-Key** sein, nicht nur der lokale Upload-Key. Sonst schlägt
die App-Links-Verifizierung für die Store-Version fehl und der Link öffnet nur
den Browser. Nachsehen unter Play Console → Setup → App signing; beide
Fingerprints dürfen im Array stehen.
