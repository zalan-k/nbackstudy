import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

mouse.mouseMove(x, y); % Replace int x ; int y with appropriate screen coordinates
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
