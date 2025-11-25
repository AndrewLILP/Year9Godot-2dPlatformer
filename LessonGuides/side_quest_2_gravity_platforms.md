# Side Quest 2: Success Checklists
## Gravity Flip & Moving Platforms

**Student Name:** ____________________  
**Date:** ____________________

---

## ✅ Part A: Moving Platforms - Success Checklist

**Before moving to Part B, verify all items below:**

### Scene Setup
- [ ] `moving_platform.tscn` created and saved in project
- [ ] Root node is **AnimatableBody2D** (NOT StaticBody2D!)
- [ ] CollisionShape2D child added with RectangleShape2D
- [ ] ColorRect child added for visual appearance
- [ ] StartPoint (Marker2D) child added at position (0, 0)
- [ ] EndPoint (Marker2D) child added at desired offset position

### Script Configuration
- [ ] `moving_platform.gd` script attached to root node
- [ ] Script has professional comments explaining each section
- [ ] Script uses `global_position` for movement calculations
- [ ] Script includes exported variables (@export) for customization

### Inspector Settings (CRITICAL!)
- [ ] **Sync to Physics:** ✓ **ENABLED** in Inspector
- [ ] Collision Layer set to **4** (Environment)
- [ ] Speed exported variable visible in Inspector
- [ ] Pause Duration exported variable visible in Inspector
- [ ] Auto Start exported variable visible in Inspector

### Level Integration
- [ ] At least one moving platform instance added to level_1
- [ ] Platform positioned where desired in level editor
- [ ] EndPoint adjusted to create movement path
- [ ] Platform appears at correct position (where you placed it)

### Testing - Platform Movement
- [ ] Platform starts moving automatically when game runs
- [ ] Platform moves smoothly between start and end points (no stuttering)
- [ ] Platform reaches end point correctly
- [ ] Platform pauses at end point (if pause_duration > 0)
- [ ] Platform returns to start point
- [ ] Platform loops continuously without errors

### Testing - Player Interaction
- [ ] **Player stands on platform** (don't press movement keys)
  - Player moves WITH platform smoothly ✓
- [ ] **Player walks on platform** in same direction as movement
  - Player walks normally, moves faster overall ✓
- [ ] **Player walks on platform** opposite to movement direction
  - Player walks normally but slower (treadmill effect - expected!) ✓
- [ ] **Player jumps while on platform**
  - Player lands back on platform ✓
- [ ] **Player can walk off the edge**
  - Player falls normally ✓

### Debug Verification
- [ ] Output panel shows "MOVING PLATFORM INITIALIZED" message
- [ ] Output shows start and end positions
- [ ] Output shows "Moving to END/START position" messages
- [ ] No error messages appear in Output panel
- [ ] Distance calculation appears correct in Output

### Final Checks
- [ ] All scene files saved (Ctrl+S)
- [ ] Level file saved (Ctrl+Shift+S)
- [ ] No red error indicators in Scene tree
- [ ] Platform carries player without sliding off

**Part A Completion:** ⬜ **COMPLETE** | ⬜ **NEEDS REVIEW**

**Notes/Issues:**

## ✅ Part B: Gravity Flip Button - Success Checklist

**Before finishing, verify all items below:**

### Scene Setup
- [ ] `gravity_button.tscn` created and saved
- [ ] Root node is Area2D
- [ ] CollisionShape2D child added with RectangleShape2D (48×48)
- [ ] ColorRect child added for button visual (48×48, centered)
- [ ] Label child added for direction arrow indicator

### Script Configuration
- [ ] `gravity_button.gd` script attached to root node
- [ ] Script has professional comments
- [ ] Script connects to `body_entered` signal
- [ ] Script finds player using `get_first_node_in_group("player")`
- [ ] Script has color constants (COLOR_NORMAL, COLOR_FLIPPED)

### Player Script Modifications
- [ ] Opened `player.gd` successfully
- [ ] Added `var gravity_multiplier: float = 1.0` at top of script
- [ ] Modified gravity line to include `* gravity_multiplier`
  - `velocity += get_gravity() * delta * gravity_multiplier` ✓
- [ ] Modified jump line to include `* gravity_multiplier`
  - `velocity.y = JUMP_VELOCITY * gravity_multiplier` ✓
- [ ] Saved player.gd script

### Player Group Configuration
- [ ] Opened level_1.tscn
- [ ] Selected Player node
- [ ] Clicked Node tab (next to Inspector)
- [ ] Added player to **"player"** group (lowercase)
- [ ] Verified group appears in Groups list

### Level Integration
- [ ] Gravity button instance added to level_1
- [ ] Button positioned on accessible platform
- [ ] Room above and below button for testing
- [ ] Initial button color is GREEN

### Testing - Button Visual Feedback
- [ ] Button starts as **GREEN 🟢** with **↓** arrow
- [ ] Touching button changes color to **RED 🔴**
- [ ] Arrow changes to **↑** when flipped
- [ ] Touching button again returns to **GREEN 🟢** with **↓**
- [ ] Color transitions work every time

### Testing - Gravity Mechanics (Normal)
- [ ] Player falls DOWNWARD normally before touching button
- [ ] Player stands on floor platforms
- [ ] Jump goes UPWARD (away from floor)
- [ ] All movement controls work correctly

### Testing - Gravity Mechanics (Flipped)
- [ ] Touching button makes player fall UPWARD
- [ ] Player continues falling upward until hitting ceiling
- [ ] Player can walk on ceiling platforms
- [ ] Jump goes DOWNWARD (away from ceiling)
- [ ] Left/Right movement still works correctly

### Testing - Gravity Toggle
- [ ] Can toggle gravity on and off repeatedly
- [ ] Each toggle changes button color
- [ ] Each toggle changes arrow direction
- [ ] Gravity state matches button appearance
- [ ] No errors when toggling multiple times

### Debug Verification
- [ ] Output shows "GRAVITY BUTTON INITIALIZED"
- [ ] Output shows "✓ Player found: [player name]"
- [ ] Output shows "✓ Player has gravity_multiplier variable"
- [ ] Output shows "Player activated gravity button!" on touch
- [ ] Output shows "🔄 GRAVITY FLIPPED" or "🔄 GRAVITY NORMAL"
- [ ] No error messages in Output panel

### Final Checks
- [ ] All scripts saved (Ctrl+S for each)
- [ ] All scenes saved (Ctrl+Shift+S)
- [ ] No red error indicators in Scene tree
- [ ] Both mechanics work together without conflicts
- [ ] Can ride moving platform with normal gravity
- [ ] Can ride moving platform with flipped gravity

**Part B Completion:** ⬜ **COMPLETE** | ⬜ **NEEDS REVIEW**

**Notes/Issues:**
