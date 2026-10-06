# Party Tracker — natywny widget iOS

To jest natywny widget SwiftUI + WidgetKit z przyciskami `+`, `−` i `Reset`.

## Założenia
- iOS 17+
- Small widget
- Shoty: 0–20, limit 15
- Piwa: 0–10, limit 2
- kolor pomarańczowy na limicie
- kolor czerwony po przekroczeniu
- kliknięcia są wykonywane przez `AppIntent`, więc widget nie powinien otwierać aplikacji

Apple opisuje interaktywne widgety i `Button(intent:)` od iOS 17.

## Budowanie bez Maca — GitHub Actions

1. Utwórz nowe repozytorium GitHub.
2. Wgraj całą zawartość tego folderu.
3. Otwórz zakładkę **Actions**.
4. Uruchom workflow **Build unsigned IPA**.
5. Po zakończeniu pobierz artefakt `PartyTracker-unsigned`.
6. W środku będzie `PartyTracker-unsigned.ipa`.
7. Podpisz i zainstaluj IPA przez Sideloadly / AltStore na Windowsie.

Darmowe podpisanie Apple ID zwykle wymaga ponownego podpisania po 7 dniach.

## Lokalny build na Macu
Jeżeli kiedyś będziesz miał dostęp do Maca:

```bash
brew install xcodegen
xcodegen generate
open PartyTracker.xcodeproj
```

Następnie wybierz swój Team w Signing & Capabilities i uruchom aplikację na iPhonie.


## Automatyczny build
Po każdym pushu do `main` lub `master` GitHub Actions automatycznie uruchomi build. Jeśli build się nie powiedzie, workflow zapisuje `xcodebuild.log` jako artefakt, żeby można było poprawić konkretny błąd.
