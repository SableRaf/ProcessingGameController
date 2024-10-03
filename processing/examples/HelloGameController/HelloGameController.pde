import fr.raphaeldecourville.AGC4P.*;
import android.view.KeyEvent;

AndroidGameController controller;
boolean buttonA, buttonB, buttonX, buttonY, dpadUp, dpadDown, dpadLeft, dpadRight;
float joystickX = 0, joystickY = 0;

void setup() {
  size(800, 600);
  controller = new AndroidGameController(this);

  controller.setGameControllerListener(new AndroidGameController.GameControllerListener() {
    public void onJoystickMoved(float x, float y) {
      joystickX = x;  // Update the joystick position
      joystickY = y;
    }

    public void onGamepadButtonDown(int keyCode) {
      updateButtonState(keyCode, true);
    }

    public void onGamepadButtonUp(int keyCode) {
      updateButtonState(keyCode, false);
    }
  });
}

void draw() {
  background(200);

  // Draw joystick visual representation
  fill(100, 100, 250);
  ellipse(width / 2 + joystickX * 100, height / 2 + joystickY * 100, 50, 50); // Draw joystick as a circle, scaled by 100 pixels

  // Draw buttons visual representation
  drawButtonState("BUTTON_A", buttonA, 50, 50);
  drawButtonState("BUTTON_B", buttonB, 50, 70);
  drawButtonState("BUTTON_X", buttonX, 50, 90);
  drawButtonState("BUTTON_Y", buttonY, 50, 110);
  drawButtonState("DPAD_UP", dpadUp, 50, 130);
  drawButtonState("DPAD_DOWN", dpadDown, 50, 150);
  drawButtonState("DPAD_LEFT", dpadLeft, 50, 170);
  drawButtonState("DPAD_RIGHT", dpadRight, 50, 190);
}

// Function to draw each button's text, changing color when pressed
void drawButtonState(String label, boolean isPressed, int x, int y) {
  if (isPressed) {
    fill(255, 0, 0); // Red color when pressed
  } else {
    fill(150); // Grey color when not pressed
  }
  text(label, x, y);
}

// Helper function to update button states
void updateButtonState(int keyCode, boolean pressed) {
  switch (keyCode) {
    case KeyEvent.KEYCODE_BUTTON_A:
      buttonA = pressed;
      break;
    case KeyEvent.KEYCODE_BUTTON_B:
      buttonB = pressed;
      break;
    case KeyEvent.KEYCODE_BUTTON_X:
      buttonX = pressed;
      break;
    case KeyEvent.KEYCODE_BUTTON_Y:
      buttonY = pressed;
      break;
    case KeyEvent.KEYCODE_DPAD_UP:
      dpadUp = pressed;
      break;
    case KeyEvent.KEYCODE_DPAD_DOWN:
      dpadDown = pressed;
      break;
    case KeyEvent.KEYCODE_DPAD_LEFT:
      dpadLeft = pressed;
      break;
    case KeyEvent.KEYCODE_DPAD_RIGHT:
      dpadRight = pressed;
      break;
  }
}

// Helper function to convert key codes to readable names
String keyCodeToString(int keyCode) {
  switch (keyCode) {
    case KeyEvent.KEYCODE_BUTTON_A:
      return "BUTTON_A";
    case KeyEvent.KEYCODE_BUTTON_B:
      return "BUTTON_B";
    case KeyEvent.KEYCODE_BUTTON_X:
      return "BUTTON_X";
    case KeyEvent.KEYCODE_BUTTON_Y:
      return "BUTTON_Y";
    case KeyEvent.KEYCODE_DPAD_UP:
      return "DPAD_UP";
    case KeyEvent.KEYCODE_DPAD_DOWN:
      return "DPAD_DOWN";
    case KeyEvent.KEYCODE_DPAD_LEFT:
      return "DPAD_LEFT";
    case KeyEvent.KEYCODE_DPAD_RIGHT:
      return "DPAD_RIGHT";
    default:
      return "KEYCODE_" + keyCode;
  }
}
