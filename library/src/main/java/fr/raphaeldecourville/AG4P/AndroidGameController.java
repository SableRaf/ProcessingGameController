package fr.raphaeldecourville.AGC4P;

import processing.core.PApplet;
import android.app.Activity;
import android.view.View;
import android.view.MotionEvent;
import android.view.KeyEvent;
import android.view.InputDevice;
import java.util.HashSet;
import java.util.Set;

/**
 * AndroidGameController
 * Handles game controller inputs for Processing on Android.
 * 
 * This library allows developers to handle button presses, joystick movements,
 * and other game controller inputs in Processing Android projects.
 * 
 * @author      Raphaël de Courville
 * @modified    2024-10-03
 * @version     0.0.1
 */
public class AndroidGameController {

    // Reference to the parent sketch
    PApplet parent;

    // Root view of the activity
    View rootView;

    // Store axis values
    private float axisX = 0;
    private float axisY = 0;

    // Store pressed buttons
    private Set<Integer> buttonsPressed = new HashSet<Integer>();

    // Game controller listener
    private GameControllerListener listener;

    /**
     * Constructor, usually called in the setup() method in your sketch to
     * initialize and start the library.
     * 
     * @param parent The parent sketch.
     */
    public AndroidGameController(PApplet parent) {
        this.parent = parent;
        init();
    }

    private void init() {
        // Get the activity
        Activity activity = parent.getActivity();
        // Get the root view
        rootView = activity.findViewById(android.R.id.content);

        // Set up listeners
        setUpListeners();
    }

    private void setUpListeners() {
        rootView.setFocusable(true);
        rootView.setFocusableInTouchMode(true);
        rootView.requestFocus();

        rootView.setOnGenericMotionListener(new View.OnGenericMotionListener() {
            @Override
            public boolean onGenericMotion(View v, MotionEvent event) {
                return processGenericMotionEvent(event);
            }
        });

        rootView.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                return processKeyEvent(event);
            }
        });
    }

    private boolean processGenericMotionEvent(MotionEvent event) {
        // Check that the event came from a game controller
        if ((event.getSource() & InputDevice.SOURCE_JOYSTICK)
                == InputDevice.SOURCE_JOYSTICK
                && event.getAction() == MotionEvent.ACTION_MOVE) {

            InputDevice device = event.getDevice();

            // Process joystick axes
            axisX = getCenteredAxis(event, device, MotionEvent.AXIS_X);
            axisY = getCenteredAxis(event, device, MotionEvent.AXIS_Y);

            if (listener != null) {
                listener.onJoystickMoved(axisX, axisY);
            }

            return true;
        }
        return false;
    }

    private float getCenteredAxis(MotionEvent event, InputDevice device, int axis) {
        InputDevice.MotionRange range = device.getMotionRange(axis, event.getSource());
        if (range != null) {
            float value = event.getAxisValue(axis);
            // Apply deadzone
            if (Math.abs(value) > range.getFlat()) {
                return value;
            }
        }
        return 0;
    }

    private boolean processKeyEvent(KeyEvent event) {
        if ((event.getSource() & InputDevice.SOURCE_GAMEPAD)
                == InputDevice.SOURCE_GAMEPAD) {
            int keyCode = event.getKeyCode();

            if (event.getAction() == KeyEvent.ACTION_DOWN) {
                buttonsPressed.add(keyCode);
                if (listener != null) {
                    listener.onGamepadButtonDown(keyCode);
                }
                return true;
            } else if (event.getAction() == KeyEvent.ACTION_UP) {
                buttonsPressed.remove(keyCode);
                if (listener != null) {
                    listener.onGamepadButtonUp(keyCode);
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Set the game controller listener to receive input events.
     * 
     * @param listener An implementation of GameControllerListener.
     */
    public void setGameControllerListener(GameControllerListener listener) {
        this.listener = listener;
    }

    /**
     * Get the current X-axis value of the joystick.
     * 
     * @return X-axis value.
     */
    public float getAxisX() {
        return axisX;
    }

    /**
     * Get the current Y-axis value of the joystick.
     * 
     * @return Y-axis value.
     */
    public float getAxisY() {
        return axisY;
    }

    /**
     * Check if a button is currently pressed.
     * 
     * @param keyCode The key code of the button.
     * @return True if the button is pressed, false otherwise.
     */
    public boolean isButtonPressed(int keyCode) {
        return buttonsPressed.contains(keyCode);
    }

    /**
     * Get the set of currently pressed buttons.
     * 
     * @return A set of key codes.
     */
    public Set<Integer> getPressedButtons() {
        return new HashSet<Integer>(buttonsPressed);
    }

    /**
     * Interface for receiving game controller input events.
     */
    public interface GameControllerListener {
        void onJoystickMoved(float x, float y);

        void onGamepadButtonDown(int keyCode);

        void onGamepadButtonUp(int keyCode);
    }
}