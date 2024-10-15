# ``HitoriCode``

**HitoriCode** is modern code editor for efficient programming.

## Features

**HitoriCode** is divided into two main parts. The window and system management composed of AppKit, and the View that interacts with the user composed of SwiftUI.

### AppKit

AppKit in HitoriCode is mainly used to operate parts closely related to the macOS system, such as managing the life cycle of applications and windows, configuring the menu bar, and building communication with LSP and execution.

### SwiftUI

SwiftUI in HitoriCode is responsible for creating UIs that can interact with users, reflecting the results of interactions as states, and configuring the system to operate with the results of user interactions by calling functions defined in AppKit. The most closely related examples of this are system terminals and code editors.

## Topics

### AppKit

- ``HitoriConfig``
- ``HitoriMenu``
- ``HitoriWindow``
- ``HitoriWindowController``
- ``HitoriWindowManager``
- ``HitoriWindowStyle``

### Landing

- ``LandingView``
- ``LandingWelcomeScreen``
- ``LandingFinishScreen``
